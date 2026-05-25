
from django.db import migrations, models

def migrate_transaction_types(apps, schema_editor):
    Transaction = apps.get_model("transactions", "Transaction")
    Transaction.objects.filter(type="entrada").update(type="income")
    Transaction.objects.filter(type="saida").update(type="expense")

def rollback_transaction_types(apps, schema_editor):
    Transaction = apps.get_model("transactions", "Transaction")
    Transaction.objects.filter(type="income").update(type="entrada")
    Transaction.objects.filter(type="expense").update(type="saida")

class Migration(migrations.Migration):

    dependencies = [
        ("transactions", "0002_initial"),
    ]

    operations = [
        migrations.RunPython(migrate_transaction_types, rollback_transaction_types),
        migrations.AlterField(
            model_name="transaction",
            name="type",
            field=models.CharField(
                choices=[("income", "Income"), ("expense", "Expense")],
                db_index=True,
                max_length=10,
            ),
        ),
    ]
