import io
from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from apps.users.models import User
from apps.users.factories import UserFactory
from apps.users.services import issue_user_token
from oauth2_provider.models import AccessToken

class AuthAndUserTests(APITestCase):
    def setUp(self):

        pass

    def test_user_registration_and_login_flow(self):

        register_url = reverse("register")
        register_data = {
            "name": "John Doe",
            "email": "john@example.com",
            "password": "securepassword123",
        }
        response = self.client.post(register_url, register_data, format="json")
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIn("token", response.data)

        token = response.data["token"]

        response = self.client.post(register_url, register_data, format="json")
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(response.data["success"])
        self.assertIn("email", response.data["error"]["details"])

        login_url = reverse("login")
        login_data = {
            "email": "john@example.com",
            "password": "securepassword123",
        }
        response = self.client.post(login_url, login_data, format="json")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("token", response.data)

        validate_url = reverse("validate-token")

        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {token}")
        response = self.client.get(validate_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(response.data)

        self.client.credentials(HTTP_AUTHORIZATION="Bearer invalidtokenabc")
        response = self.client.get(validate_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertFalse(response.data)

    def test_user_profile_endpoints(self):

        user = UserFactory(
            email="profile@example.com",
            name="Profile Tester",
            password="testpassword123",
        )
        token = issue_user_token(user=user)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {token}")

        me_url = reverse("user-me")
        response = self.client.get(me_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Profile Tester")
        self.assertEqual(response.data["email"], "profile@example.com")
        self.assertIsNone(response.data["imageUrl"])

        upload_url = reverse("upload-profile-image")

        file_data = io.BytesIO(b"dummy image content")
        file_data.name = "test_avatar.jpg"

        response = self.client.post(upload_url, {"file": file_data}, format="multipart")
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("imageUrl", response.data)

        image_url = response.data["imageUrl"]
        self.assertIn("media/avatars/", image_url)

        response = self.client.get(me_url)
        self.assertEqual(response.data["imageUrl"], image_url)

        min_url = reverse("user-data-min")
        response = self.client.get(min_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["name"], "Profile Tester")
        self.assertEqual(response.data["imageUrl"], image_url)

        avatar_url = reverse("user-profile-image")
        response = self.client.get(avatar_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["imageUrl"], image_url)

    def test_user_deletion(self):
        user = UserFactory(
            email="delete@example.com",
            name="To Be Deleted",
            password="testpassword123",
        )
        token = issue_user_token(user=user)
        self.client.credentials(HTTP_AUTHORIZATION=f"Bearer {token}")

        delete_url = reverse("user-delete")
        response = self.client.delete(delete_url)
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)

        self.assertFalse(User.objects.filter(id=user.id).exists())
        self.assertFalse(AccessToken.objects.filter(token=token).exists())
