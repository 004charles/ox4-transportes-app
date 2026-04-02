import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';
import 'package:ox4_app/services/auth_service.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({Key? key}) : super(key: key);

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  String _tipoUsuario = 'PASSAGEIRO';
  bool _isLoading = false;

  Future<void> _handleRegistro() async {
    setState(() => _isLoading = true);
    
    final success = await AuthService.registrar(
      username: _telefoneController.text, // Usando telefone como username para simplicidade
      email: _emailController.text,
      password: _senhaController.text,
      telefone: _telefoneController.text,
      tipo: _tipoUsuario,
    );

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta criada com sucesso! Por favor, faça login.')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao criar conta. Tente outro telefone/email.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('Preencha seus dados para começar.', style: TextStyle(color: AppColors.textGray)),
            const SizedBox(height: 30),
            _buildField(label: 'Nome Completo', hint: 'Ex: João Paulo', controller: _nomeController),
            _buildField(label: 'E-mail', hint: 'exemplo@ox4.com', controller: _emailController),
            _buildField(label: 'Número de Telefone', hint: '9xxxxxxxx', controller: _telefoneController),
            _buildField(label: 'Senha', hint: '********', obscure: true, controller: _senhaController),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Tipo de Conta:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
            ),
            Row(
              children: [
                Radio(value: 'PASSAGEIRO', groupValue: _tipoUsuario, onChanged: (v) => setState(() => _tipoUsuario = v as String)),
                const Text('Passageiro'),
                const SizedBox(width: 20),
                Radio(value: 'MOTORISTA', groupValue: _tipoUsuario, onChanged: (v) => setState(() => _tipoUsuario = v as String)),
                const Text('Motorista'),
              ],
            ),
            
            const SizedBox(height: 30),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _handleRegistro,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Registrar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({required String label, required String hint, required TextEditingController controller, bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }
}
