from django.core.exceptions import ValidationError
from apps.transactions.models import Category, Transaction

def create_category(*, name) -> Category:
    cleaned_name = name.strip()
    if not cleaned_name:
        raise ValidationError({"name": ["Category name cannot be empty."]})

    if Category.objects.filter(name__iexact=cleaned_name).exists():
        raise ValidationError({"name": ["Category with this name already exists."]})

    category = Category.objects.create(name=cleaned_name)
    return category

def delete_category(*, category_id) -> None:
    try:
        category = Category.objects.get(id=category_id)
    except Category.DoesNotExist:
        raise ValidationError({"detail": "Category not found."})

    if Transaction.objects.filter(category=category).exists():
        raise ValidationError({"detail": "Falha na integridade dos dados (Existem transações usando esta categoria)."})

    category.delete()

def create_transaction(*, user, amount, type, title, category_id) -> Transaction:
    try:
        category = Category.objects.get(id=category_id)
    except Category.DoesNotExist:
        raise ValidationError({"categoryId": ["Invalid category ID."]})

    if amount <= 0:
        raise ValidationError({"amount": ["Amount must be greater than zero."]})

    transaction = Transaction.objects.create(
        user=user,
        amount=amount,
        type=type,
        title=title.strip(),
        category=category
    )
    return transaction

def update_transaction(*, transaction: Transaction, **fields) -> Transaction:
    update_fields = []

    if "category_id" in fields:
        category_id = fields["category_id"]
        try:
            category = Category.objects.get(id=category_id)
            transaction.category = category
            update_fields.append("category")
        except Category.DoesNotExist:
            raise ValidationError({"categoryId": ["Invalid category ID."]})

    if "amount" in fields:
        amount = fields["amount"]
        if amount <= 0:
            raise ValidationError({"amount": ["Amount must be greater than zero."]})
        transaction.amount = amount
        update_fields.append("amount")

    if "type" in fields:
        transaction.type = fields["type"]
        update_fields.append("type")

    if "title" in fields:
        transaction.title = fields["title"].strip()
        update_fields.append("title")

    if update_fields:
        update_fields.append("updated_at")
        transaction.save(update_fields=update_fields)

    return transaction

def delete_transaction(*, transaction: Transaction) -> None:
    transaction.delete()
