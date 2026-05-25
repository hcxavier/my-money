from django.core.exceptions import ValidationError
from apps.users.models import User

def authenticate_user(*, email, password) -> User:
    try:
        user = User.objects.get(email=email, is_active=True)
    except User.DoesNotExist:
        raise ValidationError({"non_field_errors": ["Invalid credentials."]})

    if not user.check_password(password):
        raise ValidationError({"non_field_errors": ["Invalid credentials."]})

    return user
