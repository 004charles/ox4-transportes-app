from django.urls import path
from .views import (RegistroView, LoginView, EnviarCodigoView, VerificarCodigoView, 
                    PerfilView, DeletarContaView, CriarCorridaView, CorridasPendentesView, MudarEstadoCorridaView, EstimarCorridaView)


urlpatterns = [
    path('registrar/', RegistroView.as_view(), name='api_registrar'),
    path('login/', LoginView.as_view(), name='api_login'),
    path('enviar-codigo/', EnviarCodigoView.as_view(), name='api_enviar_codigo'),
    path('verificar-codigo/', VerificarCodigoView.as_view(), name='api_verificar_codigo'),
    path('perfil/', PerfilView.as_view(), name='api_perfil'),
    path('deletar-conta/', DeletarContaView.as_view(), name='api_deletar_conta'),
    
    # Rotas de Match/Corrida
    path('corridas/', CriarCorridaView.as_view(), name='api_criar_corrida'),
    path('corridas/pendentes/', CorridasPendentesView.as_view(), name='api_corridas_pendentes'),
    path('corridas/<int:pk>/estado/', MudarEstadoCorridaView.as_view(), name='api_mudar_estado_corrida'),
    path('estimativa/', EstimarCorridaView.as_view(), name='api_estimar_corrida'),
]
