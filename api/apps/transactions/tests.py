import io
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from apps.users.factories import UserFactory
from apps.users.services import issue_user_token
from apps.transactions.models import Category, Transaction, TransactionType
from apps.transactions.factories import CategoryFactory, TransactionFactory

class TransactionAndCategoryTests(APITestCase):
    def setUp(self):

        self.user = UserFactory(
            email="finance@example.com",
            name="Finance Guy",
            password="securepassword123",
        )
        self.token = issue_user_token(user=self.user)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {self.token}")

        self.other_user = UserFactory(
            email="other@example.com",
            name="Other Guy",
            password="securepassword123",
        )
        self.other_token = issue_user_token(user=self.other_user)

        self.cat1 = CategoryFactory(name="Alimentação")
        self.cat2 = CategoryFactory(name="Transporte")

    def test_category_crud_and_integrity_rules(self):
        categories_url = reverse("categories-list-create")

        response = self.client.get(categories_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        self.assertEqual(len(response.data), 2)
        self.assertEqual(response.data[0]["name"], "Alimentação")

        response = self.client.post(categories_url, {"name": "Alimentação"}, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

        response = self.client.post(categories_url, {"name": "Saúde"}, format="json")
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(Category.objects.filter(name="Saúde").exists())

        saude_cat = Category.objects.get(name="Saúde")

        TransactionFactory(
            user=self.user,
            amount=45.90,
            type=TransactionType.EXPENSE,
            title="Almoço",
            category=self.cat1,
        )

        cat1_delete_url = reverse("categories-detail", kwargs={"id": self.cat1.id})
        response = self.client.delete(cat1_delete_url)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(response.data["success"])
        self.assertIn("Falha na integridade", response.data["error"]["message"])

        saude_delete_url = reverse("categories-detail", kwargs={"id": saude_cat.id})
        response = self.client.delete(saude_delete_url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Category.objects.filter(id=saude_cat.id).exists())

    def test_transaction_crud_and_ownership(self):
        transactions_url = reverse("transactions-list-create")

        response = self.client.post(
            transactions_url,
            {
                "amount": 1500.00,
                "type": TransactionType.INCOME,
                "title": "Salário Mensal",
                "categoryId": self.cat2.id,
            },
            format="json",
        )
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Transaction.objects.filter(user=self.user).count(), 1)

        tx = Transaction.objects.first()

        response = self.client.get(transactions_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]["title"], "Salário Mensal")
        self.assertEqual(response.data[0]["amount"], 1500.00)

        tx_detail_url = reverse("transactions-detail", kwargs={"id": tx.id})

        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {self.other_token}")

        response = self.client.put(tx_detail_url, {"title": "Tentativa Invasão"}, format="json")
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

        response = self.client.delete(tx_detail_url)
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {self.token}")

        response = self.client.put(tx_detail_url, {"title": "Salário Corrigido", "amount": 1600.00}, format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        tx.refresh_from_db()
        self.assertEqual(tx.title, "Salário Corrigido")
        self.assertEqual(tx.amount, 1600.00)

        response = self.client.delete(tx_detail_url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(Transaction.objects.filter(id=tx.id).count(), 0)

    def test_metrics_calculation(self):
        metrics_url = reverse("metrics")

        response = self.client.get(metrics_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["income"]["total"], 0.0)
        self.assertIsNone(response.data["income"]["lastDate"])
        self.assertEqual(response.data["expenses"]["total"], 0.0)
        self.assertIsNone(response.data["expenses"]["lastDate"])
        self.assertEqual(response.data["total"]["netBalance"], 0.0)
        self.assertIsNone(response.data["total"]["firstDate"])
        self.assertIsNone(response.data["total"]["lastDate"])

        TransactionFactory(
            user=self.user,
            amount=200.00,
            type=TransactionType.INCOME,
            title="Freela",
            category=self.cat1,
        )
        TransactionFactory(
            user=self.user,
            amount=50.00,
            type=TransactionType.EXPENSE,
            title="Janta",
            category=self.cat1,
        )

        response = self.client.get(metrics_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["income"]["total"], 200.0)
        self.assertIsNotNone(response.data["income"]["lastDate"])
        self.assertEqual(response.data["expenses"]["total"], 50.0)
        self.assertIsNotNone(response.data["expenses"]["lastDate"])
        self.assertEqual(response.data["total"]["netBalance"], 150.0)
        self.assertIsNotNone(response.data["total"]["firstDate"])
        self.assertIsNotNone(response.data["total"]["lastDate"])

    def test_uploadthing_callback_simulation(self):
        uploadthing_url = reverse("uploadthing-callback")

        file_data = io.BytesIO(b"file content")
        file_data.name = "callback_avatar.png"

        response = self.client.post(uploadthing_url, {"file": file_data}, format="multipart")
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        self.user.refresh_from_db()
        self.assertIn("callback_avatar", self.user.image_url)
