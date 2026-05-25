from django.db.models import Sum, Max, Min
from django.db.models.query import QuerySet
from apps.transactions.models import Transaction, TransactionType

def get_user_transactions(
    *,
    user,
    date_start=None,
    date_end=None,
    category_ids=None,
    transaction_type=None,
    search_query=None
) -> QuerySet:

    queryset = Transaction.objects.filter(user=user).select_related("category")

    if date_start:
        queryset = queryset.filter(created_at__date__gte=date_start)
    if date_end:
        queryset = queryset.filter(created_at__date__lte=date_end)
    if category_ids:
        queryset = queryset.filter(category_id__in=category_ids)
    if transaction_type:
        queryset = queryset.filter(type=transaction_type)
    if search_query:
        queryset = queryset.filter(title__icontains=search_query)

    return queryset.order_by("-created_at")

def calculate_user_metrics(*, user) -> dict:

    income_agg = Transaction.objects.filter(user=user, type=TransactionType.INCOME).aggregate(
        total=Sum("amount"),
        max_date=Max("created_at")
    )
    outflow_agg = Transaction.objects.filter(user=user, type=TransactionType.EXPENSE).aggregate(
        total=Sum("amount"),
        max_date=Max("created_at")
    )
    overall_agg = Transaction.objects.filter(user=user).aggregate(
        min_date=Min("created_at"),
        max_date=Max("created_at")
    )

    total_income = float(income_agg["total"]) if income_agg["total"] is not None else 0.0
    total_outflow = float(outflow_agg["total"]) if outflow_agg["total"] is not None else 0.0

    return {
        "income": {
            "total": total_income,
            "lastDate": income_agg["max_date"]
        },
        "expenses": {
            "total": total_outflow,
            "lastDate": outflow_agg["max_date"]
        },
        "total": {
            "netBalance": total_income - total_outflow,
            "firstDate": overall_agg["min_date"],
            "lastDate": overall_agg["max_date"]
        }
    }
