import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class TelaPerfilMotorista extends StatelessWidget {
  const TelaPerfilMotorista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Motorista')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundColor: AppColors.grayBg, child: Icon(Icons.person, size: 60, color: AppColors.primaryBlue)),
            const SizedBox(height: 10),
            const Text('Carlos Silva', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('⭐ 4.9 (Parceiro OX4)', style: TextStyle(color: AppColors.textGray)),
            const SizedBox(height: 30),
            _sectionTitle('Dados do Veículo'),
            _item(Icons.directions_car, 'Toyota Corolla Prata', 'LD-12-34-AO'),
            const SizedBox(height: 20),
            _sectionTitle('Documentação'),
            _item(Icons.badge, 'Identidade', 'Validado ✅'),
            _item(Icons.drive_eta, 'Carta de Condução', 'Validado ✅'),
            _item(Icons.article, 'Livrete do Veículo', 'Validado ✅'),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.dangerRed)),
                child: const Text('Encerrar Sessão / Logout', style: TextStyle(color: AppColors.dangerRed, fontWeight: FontWeight.bold)),
              ),
            ),
             const SizedBox(height: 15),
            TextButton(
              onPressed: () {},
              child: const Text('Apagar Minha Conta de Motorista', style: TextStyle(color: AppColors.textGray, fontSize: 13)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue))));
  }

  Widget _item(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.grayBg, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 15),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
