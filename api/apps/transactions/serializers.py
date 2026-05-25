from rest_framework import serializers
from apps.transactions.models import Category, Transaction, TransactionType

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Category
        fields = ["id", "name"]

class TransactionItemSerializer(serializers.ModelSerializer):
    categoryId = serializers.CharField(source="category.id")
    categoryName = serializers.CharField(source="category.name")
    createdAt = serializers.DateTimeField(source="created_at")
    amount = serializers.FloatField()

    class Meta:
        model = Transaction
        fields = [
            "id",
            "amount",
            "type",
            "title",
            "categoryId",
            "categoryName",
            "createdAt",
        ]

class TransactionCreateSerializer(serializers.Serializer):
    amount = serializers.DecimalField(max_digits=12, decimal_places=2)
    type = serializers.ChoiceField(choices=TransactionType.values)
    title = serializers.CharField(max_length=255)
    categoryId = serializers.CharField(max_length=50)
