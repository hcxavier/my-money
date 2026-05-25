import factory
from apps.users.factories import UserFactory
from apps.transactions.models import Category, Transaction, TransactionType

class CategoryFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Category
        django_get_or_create = ("name",)

    name = factory.Sequence(lambda n: f"Category {n}")

class TransactionFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Transaction

    user = factory.SubFactory(UserFactory)
    category = factory.SubFactory(CategoryFactory)
    amount = factory.Faker("pydecimal", left_digits=4, right_digits=2, positive=True, min_value=1)
    type = factory.Iterator(TransactionType.values)
    title = factory.Faker("sentence", nb_words=3)
