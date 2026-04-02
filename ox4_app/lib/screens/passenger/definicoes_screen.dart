import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class TelaDefinicoes extends StatefulWidget {
  const TelaDefinicoes({Key? key}) : super(key: key);

  @override
  State<TelaDefinicoes> createState() => _TelaDefinicoesState();
}

class _TelaDefinicoesState extends State<TelaDefinicoes> {
  bool _notificacoesLigadas = true;
  String _idiomaSelecionado = 'Português (AO)';

  void _escolherIdioma() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Escolha o Idioma', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            _idiomaItem('Português (AO)'),
            _idiomaItem('English'),
            _idiomaItem('Français'),
          ],
        ),
      ),
    );
  }

  Widget _idiomaItem(String idioma) {
    return ListTile(
      title: Text(idioma),
      trailing: _idiomaSelecionado == idioma ? const Icon(Icons.check, color: AppColors.primaryBlue) : null,
      onTap: () {
        setState(() => _idiomaSelecionado = idioma);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Definições')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSection('Preferências'),
          _buildItem(Icons.language, 'Idioma', _idiomaSelecionado, onTap: _escolherIdioma),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Notificações', style: TextStyle(fontWeight: FontWeight.w500)),
            secondary: const Icon(Icons.notifications_none, color: AppColors.primaryBlue),
            activeColor: AppColors.primaryBlue,
            value: _notificacoesLigadas,
            onChanged: (v) => setState(() => _notificacoesLigadas = v),
          ),
          const SizedBox(height: 20),
          _buildSection('Segurança'),
          _buildItem(Icons.lock_outline, 'Mudar Senha', '', onTap: () {
            // Navega para o perfil onde já existe a opção de mudar senha
            Navigator.pushNamed(context, '/profile');
          }),
          _buildItem(Icons.verified_user_outlined, 'Status de Conta', 'Verificada'),
          const SizedBox(height: 20),
          _buildSection('Privacidade'),
          _buildItem(Icons.delete_forever_outlined, 'Apagar Conta', '', color: AppColors.dangerRed, onTap: () {
            Navigator.pushNamed(context, '/profile');
          }),
          const SizedBox(height: 40),
          const Center(
            child: Text('OX4 Transportes v1.0.1', style: TextStyle(color: AppColors.textGray, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 16)),
    );
  }

  Widget _buildItem(IconData icon, String title, String value, {Color? color, VoidCallback? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? AppColors.primaryBlue),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: AppColors.textGray)),
          const Icon(Icons.chevron_right, color: AppColors.textGray),
        ],
      ),
      onTap: onTap,
    );
  }
}
