import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class TelaGanhosMotorista extends StatelessWidget {
  const TelaGanhosMotorista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seus Ganhos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Esta Semana', style: TextStyle(color: AppColors.textGray, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('145.800 Kz', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.grayBg, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  _row('Viagens Concluídas', '42', isBold: false),
                  const SizedBox(height: 10),
                  _row('Gorjetas', '1.500 Kz', isBold: false),
                  const Divider(height: 30),
                  _row('Pronto para Saque', '147.300 Kz', color: AppColors.successGreen),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('Transferir para o Banco', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {Color? color, bool isBold = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textGray)),
        Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color ?? AppColors.darkText)),
      ],
    );
  }
}
