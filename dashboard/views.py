from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.decorators import login_required
from usuarios.models import Usuario, Motorista, Corrida
from django.db.models import Sum

def login_view(request):
    if request.user.is_authenticated:
        return redirect('dashboard_index')
    if request.method == 'POST':
        u = request.POST.get('username')
        p = request.POST.get('password')
        user = authenticate(username=u, password=p)
        if user and user.is_staff:
            login(request, user)
            return redirect('dashboard_index')
        return render(request, 'dashboard/login.html', {'error': 'Acesso negado ou credenciais inválidas.'})
    return render(request, 'dashboard/login.html')

def logout_view(request):
    logout(request)
    return redirect('dashboard_login')

@login_required(login_url='dashboard_login')
def index(request):
    total_usuarios = Usuario.objects.count()
    total_motoristas = Motorista.objects.count()
    total_corridas = Corrida.objects.count()
    ganhos_totais = Corrida.objects.filter(status='CONCLUIDA').aggregate(Sum('preco_estimado'))['preco_estimado__sum'] or 0
    corridas_recentes = Corrida.objects.order_by('-data_criacao')[:5]
    
    context = {
        'total_usuarios': total_usuarios,
        'total_motoristas': total_motoristas,
        'total_corridas': total_corridas,
        'ganhos_totais': ganhos_totais,
        'corridas_recentes': corridas_recentes,
    }
    return render(request, 'dashboard/index.html', context)

@login_required(login_url='dashboard_login')
def listar_usuarios(request):
    usuarios = Usuario.objects.all().order_by('-date_joined')
    return render(request, 'dashboard/usuarios.html', {'usuarios': usuarios})

@login_required(login_url='dashboard_login')
def listar_motoristas(request):
    motoristas = Motorista.objects.all().order_by('aprovado')
    return render(request, 'dashboard/motoristas.html', {'motoristas': motoristas})

@login_required(login_url='dashboard_login')
def listar_corridas(request):
    corridas = Corrida.objects.all().order_by('-data_criacao')
    return render(request, 'dashboard/corridas.html', {'corridas': corridas})

@login_required(login_url='dashboard_login')
def aprovar_motorista(request, motorista_id):
    motorista = Motorista.objects.get(id=motorista_id)
    motorista.aprovado = not motorista.aprovado
    motorista.save()
    return redirect('dashboard_motoristas')
