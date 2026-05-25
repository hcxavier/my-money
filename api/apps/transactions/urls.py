from django.urls import path
from apps.transactions.views import (
    TransactionListCreateView,
    TransactionDetailView,
    CategoryListCreateView,
    CategoryDetailView,
    MetricsView,
    UploadthingCallbackView,
)

urlpatterns = [
    path("transactions", TransactionListCreateView.as_view(), name="transactions-list-create"),
    path("transactions/categories", CategoryListCreateView.as_view(), name="categories-list-create"),
    path("transactions/categories/<str:id>", CategoryDetailView.as_view(), name="categories-detail"),
    path("transactions/<str:id>", TransactionDetailView.as_view(), name="transactions-detail"),
    path("metrics", MetricsView.as_view(), name="metrics"),
    path("api/uploadthing", UploadthingCallbackView.as_view(), name="uploadthing-callback"),
]
