import os
import uuid
import jwt
from django.conf import settings
from django.core.files.storage import default_storage
from django.core.exceptions import ValidationError
from django.utils import timezone
from oauth2_provider.models import Application, AccessToken
from apps.users.models import User

def create_user(*, email, name, password) -> User:
    if User.objects.filter(email=email).exists():
        raise ValidationError({"email": ["Email already registered."]})

    user = User.objects.create_user(email=email, name=name, password=password)
    return user

def get_or_create_default_oauth_application() -> Application:
    app = Application.objects.filter(name="My Money").first()
    if not app:
        app = Application.objects.create(
            name="My Money",
            client_type=Application.CLIENT_CONFIDENTIAL,
            authorization_grant_type=Application.GRANT_PASSWORD,
            user=None
        )
    return app

def generate_jwt(*, user: User) -> str:
    payload = {
        "user_id": user.id,
        "email": user.email,
        "exp": timezone.now() + timezone.timedelta(days=7),
        "iat": timezone.now(),
        "jti": uuid.uuid4().hex
    }
    return jwt.encode(payload, settings.SECRET_KEY, algorithm="HS256")

def issue_user_token(*, user: User) -> str:
    token_str = generate_jwt(user=user)
    app = get_or_create_default_oauth_application()
    expires = timezone.now() + timezone.timedelta(days=7)

    AccessToken.objects.create(
        user=user,
        application=app,
        token=token_str,
        expires=expires,
        scope="read write"
    )
    return token_str

def validate_jwt_token(token_str: str) -> bool:
    try:
        payload = jwt.decode(token_str, settings.SECRET_KEY, algorithms=["HS256"])
        user_id = payload.get("user_id")
        if not user_id:
            return False

        exists = AccessToken.objects.filter(
            token=token_str,
            expires__gt=timezone.now(),
            user_id=user_id,
            user__is_active=True
        ).exists()
        return exists
    except (jwt.PyJWTError, KeyError):
        return False

def update_profile_image(*, user: User, file_obj, request_host: str = "localhost:3000") -> str:

    base = os.path.splitext(file_obj.name)[0]
    ext = os.path.splitext(file_obj.name)[1]
    filename = f"avatars/{base}_{uuid.uuid4().hex}{ext}"

    path = default_storage.save(filename, file_obj)

    image_url = f"http://{request_host}/media/{path}"

    user.image_url = image_url
    user.save(update_fields=["image_url", "updated_at"])

    return image_url

def delete_user(*, user: User) -> None:

    user.transactions.all().delete()
    user.delete()
