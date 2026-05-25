from django.core.exceptions import ValidationError
from django.utils.dateparse import parse_date
from django.conf import settings
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser

from apps.transactions.models import Category, Transaction, TransactionType
from apps.transactions.serializers import (
    CategorySerializer,
    TransactionItemSerializer,
    TransactionCreateSerializer,
)
from apps.transactions import services, selectors
from apps.users import services as user_services

class TransactionListCreateView(APIView):

    pagination_class = None

    def get(self, request):

        date_start_str = request.query_params.get("startDate")
        date_end_str = request.query_params.get("endDate")
        category_ids = request.query_params.getlist("categoryIds")
        transaction_type = request.query_params.get("type")
        search_query = request.query_params.get("search")

        date_start = None
        if date_start_str:
            date_start = parse_date(date_start_str)
            if not date_start:
                raise ValidationError({"startDate": ["Invalid date format. Use YYYY-MM-DD."]})

        date_end = None
        if date_end_str:
            date_end = parse_date(date_end_str)
            if not date_end:
                raise ValidationError({"endDate": ["Invalid date format. Use YYYY-MM-DD."]})

        if transaction_type and transaction_type not in TransactionType.values:
            raise ValidationError({"type": [f"Must be either {', '.join(TransactionType.values)}."]})

        transactions = selectors.get_user_transactions(
            user=request.user,
            date_start=date_start,
            date_end=date_end,
            category_ids=category_ids,
            transaction_type=transaction_type,
            search_query=search_query,
        )

        serializer = TransactionItemSerializer(transactions, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = TransactionCreateSerializer(data=request.data)
        if not serializer.is_valid():
            raise ValidationError(serializer.errors)

        validated_data = serializer.validated_data
        try:
            transaction = services.create_transaction(
                user=request.user,
                amount=validated_data["amount"],
                type=validated_data["type"],
                title=validated_data["title"],
                category_id=validated_data["categoryId"],
            )
        except ValidationError as e:
            raise e

        return Response(status=status.HTTP_201_CREATED)

class TransactionDetailView(APIView):
    def _get_transaction_or_raise(self, id, user):
        try:
            transaction = Transaction.objects.get(id=id)
        except Transaction.DoesNotExist:
            raise ValidationError({"detail": "Transaction not found."})

        if transaction.user != user:

            from rest_framework.exceptions import PermissionDenied
            raise PermissionDenied("A transação não pertence ao usuário logado.")

        return transaction

    def put(self, request, id):
        transaction = self._get_transaction_or_raise(id, request.user)

        serializer = TransactionCreateSerializer(data=request.data, partial=True)
        if not serializer.is_valid():
            raise ValidationError(serializer.errors)

        validated_data = serializer.validated_data

        fields = {}
        if "amount" in validated_data:
            fields["amount"] = validated_data["amount"]
        if "type" in validated_data:
            fields["type"] = validated_data["type"]
        if "title" in validated_data:
            fields["title"] = validated_data["title"]
        if "categoryId" in validated_data:
            fields["category_id"] = validated_data["categoryId"]

        try:
            services.update_transaction(transaction=transaction, **fields)
        except ValidationError as e:
            raise e

        return Response(status=status.HTTP_200_OK)

    def delete(self, request, id):
        transaction = self._get_transaction_or_raise(id, request.user)
        services.delete_transaction(transaction=transaction)
        return Response(status=status.HTTP_204_NO_CONTENT)

class CategoryListCreateView(APIView):
    pagination_class = None

    def get(self, request):
        categories = Category.objects.all().order_by("name")
        serializer = CategorySerializer(categories, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        name = request.data.get("name")
        if not name:
            raise ValidationError({"name": ["This field is required."]})

        try:
            services.create_category(name=name)
        except ValidationError as e:
            raise e

        return Response(status=status.HTTP_201_CREATED)

class CategoryDetailView(APIView):
    def delete(self, request, id):
        try:
            services.delete_category(category_id=id)
        except ValidationError as e:

            raise e
        return Response(status=status.HTTP_204_NO_CONTENT)

class MetricsView(APIView):
    def get(self, request):
        metrics = selectors.calculate_user_metrics(user=request.user)
        return Response(metrics, status=status.HTTP_200_OK)

class UploadthingCallbackView(APIView):
    parser_classes = [MultiPartParser, FormParser]

    def post(self, request):
        file_obj = request.FILES.get("file")
        if not file_obj:
            raise ValidationError({"file": ["No file was provided."]})

        if file_obj.size > settings.MAX_UPLOAD_SIZE:
            raise ValidationError({"file": [f"File size exceeds maximum limit of {settings.MAX_UPLOAD_SIZE // (1024 * 1024)}MB."]})

        request_host = request.get_host()

        user_services.update_profile_image(
            user=request.user,
            file_obj=file_obj,
            request_host=request_host,
        )
        return Response(status=status.HTTP_200_OK)
