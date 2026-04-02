from django.db import models
from django.contrib.auth.models import AbstractUser

class Usuario(AbstractUser):
    TIPO_CHOICES = (
        ('PASSAGEIRO', 'Passageiro'),
        ('MOTORISTA', 'Motorista'),
        ('ADMIN', 'Administrador'),
    )
    tipo = models.CharField(max_length=20, choices=TIPO_CHOICES, default='PASSAGEIRO')
    telefone = models.CharField(max_length=20, unique=True, null=True)
    foto_perfil = models.ImageField(upload_to='perfis/', null=True, blank=True)
    fcm_token = models.CharField(max_length=255, null=True, blank=True) # Para notificações
    codigo_verificacao = models.CharField(max_length=6, null=True, blank=True)
    
    def __str__(self):
        return f"{self.username} ({self.tipo})"

class Motorista(models.Model):
    usuario = models.OneToOneField(Usuario, on_delete=models.CASCADE, related_name='perfil_motorista')
    numero_carta = models.CharField(max_length=50)
    placa_veiculo = models.CharField(max_length=20)
    modelo_veiculo = models.CharField(max_length=100)
    aprovado = models.BooleanField(default=False)
    foto_documento_id = models.ImageField(upload_to='motoristas/docs/', null=True, blank=True)
    foto_carta_conducao = models.ImageField(upload_to='motoristas/docs/', null=True, blank=True)
    online = models.BooleanField(default=False)
    latitude_atual = models.FloatField(null=True, blank=True)
    longitude_atual = models.FloatField(null=True, blank=True)

    def __str__(self):
        return f"Motorista: {self.usuario.first_name} - {self.placa_veiculo}"

class Corrida(models.Model):
    STATUS_CHOICES = (
        ('PENDENTE', 'Aguardando Motorista'),
        ('ACEITA', 'Motorista a Caminho'),
        ('EM_CURSO', 'Em Viagem'),
        ('CONCLUIDA', 'Finalizada'),
        ('CANCELADA', 'Cancelada'),
    )
    passageiro = models.ForeignKey(Usuario, on_delete=models.CASCADE, related_name='corridas_pedidas')
    motorista = models.ForeignKey(Motorista, on_delete=models.SET_NULL, null=True, blank=True, related_name='corridas_realizadas')
    origem_latitude = models.FloatField()
    origem_longitude = models.FloatField()
    destino_latitude = models.FloatField()
    destino_longitude = models.FloatField()
    origem_endereco = models.CharField(max_length=255)
    destino_endereco = models.CharField(max_length=255)
    preco_estimado = models.DecimalField(max_digits=10, decimal_places=2)
    distancia_km = models.FloatField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='PENDENTE')
    data_criacao = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Corrida {self.id} - {self.status}"

class Avaliacao(models.Model):
    corrida = models.OneToOneField(Corrida, on_delete=models.CASCADE)
    estrelas = models.IntegerField()
    comentario = models.TextField(blank=True)
    
    def __str__(self):
        return f"{self.estrelas} Estrelas para Corrida {self.corrida.id}"
