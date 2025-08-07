from django.contrib import admin
from django.urls import path
from .views import login, sample_api, add_user_progress


urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/login', login),
    path('api/sampleapi', sample_api),
    path('api/adduserprogress',add_user_progress)
]