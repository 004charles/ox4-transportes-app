import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';
import 'package:ox4_app/services/auth_service.dart';

class FullMenuScreen extends StatefulWidget {
  const FullMenuScreen({Key? key}) : super(key: key);

  @override
  State<FullMenuScreen> createState() => _FullMenuScreenState();
}

class _FullMenuScreenState extends State<FullMenuScreen> {
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await AuthService.getPerfil();
    setState(() {
      _userProfile = profile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Foto de Perfil Centralizada - Agora Clicável
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: (_userProfile != null && _userProfile!['foto_perfil'] != null && _userProfile!['foto_perfil'].toString().startsWith('http')) 
                        ? NetworkImage(_userProfile!['foto_perfil']) 
                        : null,
                    child: (_userProfile == null || _userProfile!['foto_perfil'] == null) 
                        ? const Icon(Icons.person, size: 50, color: Colors.grey) 
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_userProfile == null)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue, // OX4 Primary Color!!
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Iniciar sessão ou registar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Para aceder a viagens, serviços e aos seus favoritos',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Text(_userProfile!['first_name'] ?? _userProfile!['username'] ?? 'Passageiro', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(_userProfile!['telefone'] ?? '', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
                
              const SizedBox(height: 30),

              // Menu Items Estilo Yango
              _buildMenuItem(Icons.local_offer_outlined, 'Descontos e ofertas', onTap: () {}, subtitle: 'Introduzir código promocional'),
              _buildMenuItem(Icons.credit_card_outlined, 'Métodos de pagamento', onTap: () => Navigator.pushNamed(context, '/passenger_wallet')),
              _buildMenuItem(Icons.bookmark_border, 'As Minhas Viagens', onTap: () => Navigator.pushNamed(context, '/passenger_history')),
              _buildMenuItem(Icons.headset_mic_outlined, 'Suporte', onTap: () {}),

              const SizedBox(height: 10),
              // Ganhar como Motorista Highlight Card - Agora com Rota Real
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/driver_register');
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E), // Preto da Yango
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
                        child: const Icon(Icons.star, color: Colors.black, size: 16),
                      ),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Text('Ganhar como motorista', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.redAccent),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),
              _buildMenuItem(Icons.shield_outlined, 'Segurança', onTap: () {}),
              _buildMenuItem(Icons.settings_outlined, 'Definições', onTap: () => Navigator.pushNamed(context, '/settings')),
              _buildMenuItem(Icons.info_outline, 'Informações', onTap: () {}),
              
              if (_userProfile != null) ...[
                const SizedBox(height: 20),
                _buildMenuItem(Icons.logout, 'Terminar Sessão', iconColor: Colors.red, textColor: Colors.red, onTap: () async {
                  await AuthService.logout();
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                }),
              ],
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {String? subtitle, VoidCallback? onTap, Color? iconColor, Color? textColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? Colors.black87),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: textColor)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)) : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.black54),
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: subtitle != null ? 4 : 0),
      ),
    );
  }
}
