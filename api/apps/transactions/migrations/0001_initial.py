
import apps.transactions.models
import django.core.validators
import django.db.models.deletion
from django.db import migrations, models

class Migration(migrations.Migration):

    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name="Category",
            fields=[
                ("created_at", models.DateTimeField(auto_now_add=True, db_index=True)),
                ("updated_at", models.DateTimeField(auto_now=True)),
                (
                    "id",
                    models.CharField(
                        default=apps.transactions.models.generate_category_id,
                        editable=False,
                        max_length=50,
                        primary_key=True,
                        serialize=False,
                    ),
                ),
                ("name", models.CharField(max_length=100, unique=True)),
            ],
            options={
                "db_table": "categories",
            },
        ),
        migrations.CreateModel(
            name="Transaction",
            fields=[
                ("created_at", models.DateTimeField(auto_now_add=True, db_index=True)),
                ("updated_at", models.DateTimeField(auto_now=True)),
                (
                    "id",
                    models.CharField(
                        default=apps.transactions.models.generate_transaction_id,
                        editable=False,
                        max_length=50,
                        primary_key=True,
                        serialize=False,
                    ),
                ),
                (
                    "amount",
                    models.DecimalField(
                        decimal_places=2,
                        max_digits=12,
                        validators=[django.core.validators.MinValueValidator(0.01)],
                    ),
                ),
                (
                    "type",
                    models.CharField(
                        choices=[("entrada", "Entrada"), ("saida", "Saída")],
                        db_index=True,
                        max_length=10,
                    ),
                ),
                ("title", models.CharField(max_length=255)),
                (
                    "category",
                    models.ForeignKey(
                        on_delete=django.db.models.deletion.PROTECT,
                        related_name="transactions",
                        to="transactions.category",
                    ),
                ),
            ],
            options={
                "db_table": "transactions",
                "ordering": ["-created_at"],
            },
        ),
    ]
