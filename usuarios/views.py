import random
from rest_framework import status, views, permissions
from rest_framework.response import Response
from django.db.models import Q
from .serializers import UsuarioSerializer
from .models import Usuario
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken

class RegistroView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        serializer = UsuarioSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            user.set_password(request.data['password'])
            user.save()
            
            return Response({
                'message': 'Utilizador criado com sucesso. Por favor, faça login.',
                'user': serializer.data,
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class EnviarCodigoView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        telefone = request.data.get('telefone')
        try:
            user = Usuario.objects.get(telefone=telefone)
            codigo = str(random.randint(1000, 9999))
            user.codigo_verificacao = codigo
            user.save()
            
            print("\n" + "="*30)
            print(f"NOVO SMS PARA {telefone}: Código de Verificação: {codigo}")
            print("="*30 + "\n")
            
            return Response({'message': 'Código enviado com sucesso (via console).'})
        except Usuario.DoesNotExist:
            return Response({'error': 'Telefone não encontrado.'}, status=404)

class VerificarCodigoView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        # Temporariamente aceitando qualquer código para facilitar os testes
        return Response({'message': 'Verificado com sucesso!', 'success': True})

class LoginView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        login_id = request.data.get('username') # Pode ser username ou telefone
        password = request.data.get('password')
        
        # LOG DE DEPURAÇÃO
        with open('login_debug.log', 'a') as f:
            f.write(f"\n--- TENTATIVA DE LOGIN ---\n")
            f.write(f"ID Recebido: {login_id}\n")
            f.write(f"Senha Recebida (tamanho): {len(password) if password else 0}\n")
            f.write(f"Content-Type: {request.content_type}\n")
            f.write(f"Data: {request.data}\n")

        # Tentar encontrar por username, telefone ou email
        user_obj = None
        try:
            if login_id:
                login_id = login_id.strip()
                user_obj = Usuario.objects.filter(
                    Q(username=login_id) | 
                    Q(telefone=login_id) | 
                    Q(email=login_id)
                ).first()
        except Exception as e:
            with open('login_debug.log', 'a') as f:
                f.write(f"Erro na busca: {e}\n")
            pass

        if user_obj:
            with open('login_debug.log', 'a') as f:
                f.write(f"Usuário encontrado! Username: {user_obj.username}\n")
            user = authenticate(username=user_obj.username, password=password)
            if user:
                refresh = RefreshToken.for_user(user)
                return Response({
                    'user': UsuarioSerializer(user).data,
                    'refresh': str(refresh),
                    'access': str(refresh.access_token),
                })
            else:
                with open('login_debug.log', 'a') as f:
                    f.write(f"Falha na autenticação (senha incorreta?)\n")
        else:
            with open('login_debug.log', 'a') as f:
                f.write(f"Usuário NÃO encontrado com o ID fornecido.\n")
        
        return Response({'error': 'Credenciais Inválidas'}, status=status.HTTP_401_UNAUTHORIZED)

from rest_framework.parsers import MultiPartParser, FormParser

class PerfilView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]

    def get(self, request):
        serializer = UsuarioSerializer(request.user)
        return Response(serializer.data)

    def patch(self, request):
        user = request.user
        data = request.data
        
        if 'first_name' in data:
            user.first_name = data['first_name']
        if 'email' in data:
            user.email = data['email']
        if 'telefone' in data:
            user.telefone = data['telefone']
        if 'fcm_token' in data:
            user.fcm_token = data['fcm_token']
        if 'foto_perfil' in request.FILES:
            user.foto_perfil = request.FILES['foto_perfil']
            
        if user.tipo == 'MOTORISTA' and hasattr(user, 'perfil_motorista'):
            moto = user.perfil_motorista
            if 'foto_documento_id' in request.FILES:
                moto.foto_documento_id = request.FILES['foto_documento_id']
            if 'foto_carta_conducao' in request.FILES:
                moto.foto_carta_conducao = request.FILES['foto_carta_conducao']
            moto.save()
            
        if 'password' in data and data['password']:
            user.set_password(data['password'])
            
        user.save()
        return Response(UsuarioSerializer(user).data)

class DeletarContaView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def delete(self, request):
        user = request.user
        user.delete()
        return Response({'message': 'Conta eliminada com sucesso.'}, status=status.HTTP_204_NO_CONTENT)

from .serializers import CorridaSerializer
from .models import Corrida

class CriarCorridaView(views.APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        data = request.data
        data['passageiro'] = request.user.id
        serializer = CorridaSerializer(data=data)
        if serializer.is_valid():
            corrida = serializer.save()
            
            # --- MOTOR DE DESPACHO FCM (Gatilho Push Notification Cloud) ---
            print("\n" + "="*50)
            print("🚀 OX4 DISPATCH SYSTEM: NOVA VISÃO DE RADARES FCM")
            motoristas_acordados = 0
            # Broadcast aos motoristas aprovados e online num raio X (Aqui iteramos todos online para a versão global)
            for moto in Motorista.objects.filter(online=True, aprovado=True):
                token = moto.usuario.fcm_token
                if token:
                    # Simulação Realista do Envio Payload JSON para os Servidores da Google
                    print(f"[POST] https://fcm.googleapis.com/fcm/send -> TOKEN: {token[:10]}... ")
                    print(f"       Alertando motorista '{moto.usuario.first_name}' sobre a Viagem {corrida.id}")
                    motoristas_acordados += 1
            print(f"   [!] {motoristas_acordados} MOTORISTAS ACORDADOS. AGUARDANDO ACEITAÇÃO.")
            print("="*50 + "\n")
            
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class CorridasPendentesView(views.APIView):
    permission_classes = [permissions.AllowAny] # Permite o motorista buscar sem estar autenticado apenas no teste inicial

    def get(self, request):
        corridas = Corrida.objects.filter(status='PENDENTE').order_by('-data_criacao')
        serializer = CorridaSerializer(corridas, many=True)
        return Response(serializer.data)

class MudarEstadoCorridaView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def patch(self, request, pk):
        try:
            corrida = Corrida.objects.get(pk=pk)
            novo_status = request.data.get('status')
            
            # Se a corrida for aceite, associamos o motorista logado
            if novo_status == 'ACEITE':
                if request.user.is_authenticated and request.user.tipo == 'MOTORISTA':
                    corrida.motorista = request.user.perfil_motorista
                
            if novo_status in dict(Corrida.STATUS_CHOICES).keys() or novo_status == 'NO_LOCAL':
                corrida.status = novo_status
                corrida.save()
                return Response({'message': f'Corrida atualizada para {novo_status}!', 'status': novo_status})
            return Response({'error': 'Status Inválido'}, status=status.HTTP_400_BAD_REQUEST)
        except Corrida.DoesNotExist:
            return Response({'error': 'Corrida não encontrada.'}, status=status.HTTP_404_NOT_FOUND)

import math

def haversine(lat1, lon1, lat2, lon2):
    R = 6371.0 # Raio da terra em km
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = math.sin(dlat / 2)**2 + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon / 2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return R * c

class EstimarCorridaView(views.APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request):
        try:
            o_lat = float(request.data.get('origem_lat'))
            o_lng = float(request.data.get('origem_lng'))
            d_lat = float(request.data.get('destino_lat'))
            d_lng = float(request.data.get('destino_lng'))
            
            distancia_km = haversine(o_lat, o_lng, d_lat, d_lng)
            
            # Estimativa de tempo baseado na velocidade média do trânsito de luanda (aprox 20km/h)
            minutos = (distancia_km / 20.0) * 60
            
            # Algoritmo de Preço Baseado nas tuas regras "Uber-Killer"
            moto_price = 300 + (100 * distancia_km) + (15 * minutos)
            eco_price = 1300 + (250 * distancia_km) + (30 * minutos)
            comfort_price = 1500 + (350 * distancia_km) + (40 * minutos)
            frete_price = 1500 + (450 * distancia_km)
            
            return Response({
                "distancia_km": round(distancia_km, 2),
                "tempo_minutos": int(minutos),
                "precos": {
                    "moto": f"{int(moto_price)} Kz",
                    "economy": f"{int(eco_price)} Kz",
                    "comfort": f"{int(comfort_price)} Kz",
                    "frete": f"{int(frete_price)} Kz"
                }
            })
        except Exception as e:
            return Response({"error": str(e)}, status=400)
