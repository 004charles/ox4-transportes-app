import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';
import 'package:ox4_app/services/auth_service.dart';

class TelaOTP extends StatefulWidget {
  const TelaOTP({Key? key}) : super(key: key);

  @override
  State<TelaOTP> createState() => _TelaOTPState();
}

class _TelaOTPState extends State<TelaOTP> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  bool _isLoading = false;

  void _verifyCode() async {
    String code = _controllers.map((c) => c.text).join();
    if (code.length < 4) return;

    setState(() => _isLoading = true);
    
    // Pegar o telefone do último registro (isso poderia ser passado via argumentos, mas vamos simular fixo ou via SharedPreferences se persistido)
    // Para este teste, vamos assumir que o usuário acabou de vir do registro.
    // O ideal é passar o telefone nos argumentos da rota.
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    String telefone = args?['telefone'] ?? "";

    final success = await AuthService.verificarCodigo(telefone, code);

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacementNamed(context, '/passenger_home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código inválido ou expirado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verificação de SMS',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 10),
            const Text(
              'Insira o código de 4 dígitos enviado para o seu terminal.',
              style: TextStyle(color: AppColors.textGray, fontSize: 16),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) => _buildOtpBox(index)),
            ),
            const SizedBox(height: 40),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Verificar Código', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: AppColors.grayBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grayBorder),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: const InputDecoration(counterText: "", border: InputBorder.none),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) {
              _focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
            if (index == 3 && value.isNotEmpty) {
              _verifyCode();
            }
          },
        ),
      ),
    );
  }
}
