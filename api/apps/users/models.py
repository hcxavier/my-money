import uuid
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.db import models
from apps.core.models import TimeStampedModel

def generate_user_id() -> str:
    return f"usr_{uuid.uuid4().hex[:12]}"

class UserManager(BaseUserManager):
    def create_user(self, email, name, password=None, **extra_fields):
        if not email:
            raise ValueError("The Email field must be set")
        email = self.normalize_email(email)
        extra_fields.setdefault("is_active", True)

        if "id" not in extra_fields or not extra_fields["id"]:
            extra_fields["id"] = generate_user_id()

        user = self.model(email=email, name=name, **extra_fields)
        if password:
            user.set_password(password)
            user.save(using=self._db)
            return user
        user.set_unusable_password()
        user.save(using=self._db)
        return user

    def create_superuser(self, email, name, password=None, **extra_fields):
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)

        if extra_fields.get("is_staff") is not True:
            raise ValueError("Superuser must have is_staff=True.")
        if extra_fields.get("is_superuser") is not True:
            raise ValueError("Superuser must have is_superuser=True.")

        return self.create_user(email, name, password, **extra_fields)

class User(AbstractUser, TimeStampedModel):
    id = models.CharField(
        max_length=50,
        primary_key=True,
        default=generate_user_id,
        editable=False
    )
    username = None
    email = models.EmailField(unique=True, db_index=True)
    name = models.CharField(max_length=255)
    image_url = models.URLField(max_length=500, blank=True)

    objects = UserManager()

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["name"]

    class Meta:
        db_table = "users"

    def __str__(self):
        return f"{self.name} ({self.email})"
