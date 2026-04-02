from django.urls import path
from . import views

urlpatterns = [
    path('', views.index, name='dashboard_index'),
    path('login/', views.login_view, name='dashboard_login'),
    path('logout/', views.logout_view, name='dashboard_logout'),
    path('usuarios/', views.listar_usuarios, name='dashboard_usuarios'),
    path('motoristas/', views.listar_motoristas, name='dashboard_motoristas'),
    path('corridas/', views.listar_corridas, name='dashboard_corridas'),
    path('motoristas/aprovar/<int:motorista_id>/', views.aprovar_motorista, name='dashboard_aprovar'),
]
