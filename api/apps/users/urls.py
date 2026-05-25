from django.urls import path
from apps.users.views import (
    UserRegisterView,
    UserLoginView,
    TokenValidateView,
    UserMeView,
    UserUploadProfileImageView,
    UserDataMinView,
    UserProfileImageView,
    UserDeleteView,
)

urlpatterns = [
    path("auth/register", UserRegisterView.as_view(), name="register"),
    path("auth/login", UserLoginView.as_view(), name="login"),
    path("auth/validate", TokenValidateView.as_view(), name="validate-token"),
    path("users/me", UserMeView.as_view(), name="user-me"),
    path("users/upload-profile-image", UserUploadProfileImageView.as_view(), name="upload-profile-image"),
    path("users/data-min", UserDataMinView.as_view(), name="user-data-min"),
    path("users/profile-image", UserProfileImageView.as_view(), name="user-profile-image"),
    path("users", UserDeleteView.as_view(), name="user-delete"),
]
