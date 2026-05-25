import factory
from apps.users.models import User

class UserFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = User
        django_get_or_create = ("email",)

    name = factory.Faker("name")
    email = factory.Sequence(lambda n: f"user{n}@example.com")

    @classmethod
    def _create(cls, model_class, *args, **kwargs):
        manager = cls._get_manager(model_class)

        if "password" not in kwargs:
            kwargs["password"] = "securepassword123"
        return manager.create_user(*args, **kwargs)
