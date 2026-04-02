from rest_framework import serializers
from .models import Usuario, Motorista, Corrida, Avaliacao

class UsuarioSerializer(serializers.ModelSerializer):
    perfil_motorista = serializers.SerializerMethodField()

    class Meta:
        model = Usuario
        fields = ('id', 'username', 'email', 'telefone', 'tipo', 'foto_perfil', 'password', 'first_name', 'last_name', 'perfil_motorista')
        extra_kwargs = {'password': {'write_only': True}}

    def get_perfil_motorista(self, obj):
        if hasattr(obj, 'perfil_motorista'):
            m = obj.perfil_motorista
            return {
                'aprovado': m.aprovado,
                'placa_veiculo': m.placa_veiculo,
                'modelo_veiculo': m.modelo_veiculo,
                'foto_documento_id': getattr(m.foto_documento_id, 'url', None) if m.foto_documento_id else None,
                'foto_carta_conducao': getattr(m.foto_carta_conducao, 'url', None) if m.foto_carta_conducao else None,
            }
        return None

class MotoristaSerializer(serializers.ModelSerializer):
    usuario = UsuarioSerializer(read_only=True)
    class Meta:
        model = Motorista
        fields = '__all__'

class CorridaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Corrida
        fields = '__all__'
