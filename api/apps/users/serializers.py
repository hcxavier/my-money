from rest_framework import serializers
from apps.users.models import User

class UserRegisterSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=255)
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True, style={"input_type": "password"})

class UserLoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True, style={"input_type": "password"})

class UserCompleteSerializer(serializers.ModelSerializer):
    imageUrl = serializers.SerializerMethodField()
    createdAt = serializers.DateTimeField(source="created_at")

    class Meta:
        model = User
        fields = ["id", "name", "email", "imageUrl", "createdAt"]

    def get_imageUrl(self, obj):
        return obj.image_url if obj.image_url else None
