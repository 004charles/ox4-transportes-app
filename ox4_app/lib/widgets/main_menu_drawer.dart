import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ox4_app/services/theme_service.dart';
import 'package:ox4_app/services/auth_service.dart';

class MainMenuDrawer extends StatefulWidget {
  const MainMenuDrawer({Key? key}) : super(key: key);

  @override
  State<MainMenuDrawer> createState() => _MainMenuDrawerState();
}

class _MainMenuDrawerState extends State<MainMenuDrawer> {
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('user_data');
    if (dataString != null) {
      if (mounted) setState(() => _userData = json.decode(dataString));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryBlue),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppColors.primaryBlue),
            ),
            accountName: Text(_userData?['first_name'] ?? 'Carregando...', style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(_userData?['email'] ?? ''),
            otherAccountsPictures: [
              IconButton(
                icon: const Icon(Icons.brightness_2, color: Colors.white), // Moon icon
                onPressed: () => ThemeService.toggleTheme(),
              )
            ],
          ),
          _buildItem(Icons.person_outline, 'Perfil do Usuário', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/profile');
          }),
          _buildItem(Icons.history, 'Histórico', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/passenger_history');
          }),
          _buildItem(Icons.share, 'Convidar Amigos', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/invite');
          }),
          _buildItem(Icons.security, 'Segurança (SOS)', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/ride_tracking');
          }),
          _buildItem(Icons.settings, 'Definições', () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/settings');
          }),
          const Spacer(),
          const Divider(),
          _buildItem(Icons.exit_to_app, 'Sair da Conta', () async {
            await AuthService.logout();
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
          }, color: AppColors.dangerRed),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primaryBlue),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}
