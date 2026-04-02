from django.contrib import admin
from .models import Usuario, Motorista, Corrida, Avaliacao

@admin.register(Usuario)
class UsuarioAdmin(admin.ModelAdmin):
    list_display = ('username', 'email', 'telefone', 'tipo', 'is_staff')
    search_fields = ('username', 'telefone', 'email')
    list_filter = ('tipo', 'is_staff')

@admin.register(Motorista)
class MotoristaAdmin(admin.ModelAdmin):
    list_display = ('usuario', 'placa_veiculo', 'aprovado', 'online')
    list_editable = ('aprovado',)
    list_filter = ('aprovado', 'online')

@admin.register(Corrida)
class CorridaAdmin(admin.ModelAdmin):
    list_display = ('id', 'passageiro', 'motorista', 'status', 'preco_estimado', 'data_criacao')
    list_filter = ('status', 'data_criacao')

admin.site.register(Avaliacao)
