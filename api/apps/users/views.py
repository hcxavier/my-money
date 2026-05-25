from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from rest_framework.parsers import MultiPartParser, FormParser
from django.core.exceptions import ValidationError
from django.conf import settings

from apps.users.serializers import (
    UserRegisterSerializer,
    UserLoginSerializer,
    UserCompleteSerializer,
)
from apps.users import services, selectors

class UserRegisterView(APIView):
    permission_classes = [AllowAny]
    throttle_scope = "sensitive"

    def post(self, request):
        serializer = UserRegisterSerializer(data=request.data)
        if not serializer.is_valid():
            raise ValidationError(serializer.errors)

        validated_data = serializer.validated_data
        try:
            user = services.create_user(
                email=validated_data["email"],
                name=validated_data["name"],
                password=validated_data["password"],
            )
        except ValidationError as e:
            raise e

        token = services.issue_user_token(user=user)
        return Response({"token": token}, status=status.HTTP_201_CREATED)

class UserLoginView(APIView):
    permission_classes = [AllowAny]
    throttle_scope = "sensitive"

    def post(self, request):
        serializer = UserLoginSerializer(data=request.data)
        if not serializer.is_valid():
            raise ValidationError(serializer.errors)

        validated_data = serializer.validated_data
        try:
            user = selectors.authenticate_user(
                email=validated_data["email"],
                password=validated_data["password"],
            )
        except ValidationError as e:
            raise e

        token = services.issue_user_token(user=user)
        return Response({"token": token}, status=status.HTTP_200_OK)

class TokenValidateView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        auth_header = request.headers.get("Authorization", "")

        if auth_header.startswith("Bearer "):
            token = auth_header.split(" ")[1]
            if not token:
                return Response(False, status=status.HTTP_200_OK)
            return Response(services.validate_jwt_token(token), status=status.HTTP_200_OK)

        token = request.query_params.get("token", "")
        if not token:
            return Response(False, status=status.HTTP_200_OK)
        return Response(services.validate_jwt_token(token), status=status.HTTP_200_OK)

class UserMeView(APIView):
    def get(self, request):
        serializer = UserCompleteSerializer(request.user)
        return Response(serializer.data, status=status.HTTP_200_OK)

class UserUploadProfileImageView(APIView):
    parser_classes = [MultiPartParser, FormParser]

    def post(self, request):
        file_obj = request.FILES.get("file")
        if not file_obj:
            raise ValidationError({"file": ["No file was provided."]})

        if file_obj.size > settings.MAX_UPLOAD_SIZE:
            raise ValidationError({"file": [f"File size exceeds maximum limit of {settings.MAX_UPLOAD_SIZE // (1024 * 1024)}MB."]})

        request_host = request.get_host()
        image_url = services.update_profile_image(
            user=request.user,
            file_obj=file_obj,
            request_host=request_host,
        )
        return Response({"imageUrl": image_url}, status=status.HTTP_200_OK)

class UserDataMinView(APIView):
    def get(self, request):
        user = request.user
        data = {
            "name": user.name,
            "imageUrl": user.image_url if user.image_url else None,
        }
        return Response(data, status=status.HTTP_200_OK)

class UserProfileImageView(APIView):
    def get(self, request):
        user = request.user
        data = {
            "imageUrl": user.image_url if user.image_url else None,
        }
        return Response(data, status=status.HTTP_200_OK)

class UserDeleteView(APIView):
    def delete(self, request):
        services.delete_user(user=request.user)
        return Response(status=status.HTTP_204_NO_CONTENT)
