import uuid
from django.db import models
from django.core.validators import MinValueValidator
from apps.core.models import TimeStampedModel
from apps.users.models import User

def generate_category_id() -> str:
    return f"cat_{uuid.uuid4().hex[:12]}"

def generate_transaction_id() -> str:
    return f"tr_{uuid.uuid4().hex[:12]}"

class TransactionType(models.TextChoices):
    INCOME = "income", "Income"
    EXPENSE = "expense", "Expense"

class Category(TimeStampedModel):
    id = models.CharField(
        max_length=50,
        primary_key=True,
        default=generate_category_id,
        editable=False
    )
    name = models.CharField(max_length=100, unique=True)

    class Meta:
        db_table = "categories"

    def __str__(self):
        return self.name

class TransactionQuerySet(models.QuerySet):
    def for_user(self, user):
        return self.filter(user=user)

class Transaction(TimeStampedModel):
    id = models.CharField(
        max_length=50,
        primary_key=True,
        default=generate_transaction_id,
        editable=False
    )
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="transactions",
        db_index=True
    )
    category = models.ForeignKey(
        Category,
        on_delete=models.PROTECT,
        related_name="transactions",
        db_index=True
    )
    amount = models.DecimalField(
        max_digits=12,
        decimal_places=2,
        validators=[MinValueValidator(0.01)]
    )
    type = models.CharField(
        max_length=10,
        choices=TransactionType.choices,
        db_index=True
    )
    title = models.CharField(max_length=255)

    objects = TransactionQuerySet.as_manager()

    class Meta:
        db_table = "transactions"
        ordering = ["-created_at"]

    def __str__(self):
        return f"{self.title} - {self.amount} ({self.type})"
