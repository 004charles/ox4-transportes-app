import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class TelaLegal extends StatelessWidget {
  final String title;
  const TelaLegal({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
            const SizedBox(height: 20),
            const Text(
              'Estes são os termos e condições oficiais da OX4 Transportes (su) Limitada. '
              'Ao utilizar nossos serviços, você concorda com a coleta de dados de localização em tempo real para fins de segurança e operação das viagens.\n\n'
              '1. Coleta de Dados: Coletamos nome, telefone e localização.\n'
              '2. Segurança: Oferecemos botão SOS para emergências.\n'
              '3. Cancelamento: Aplicam-se taxas de cancelamento após 5 minutos.\n'
              '4. Privacidade: Seus dados são protegidos conforme a lei local de proteção de dados (LPD).',
              style: TextStyle(color: AppColors.textGray, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
