import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class TelaCadastroMotorista extends StatelessWidget {
  const TelaCadastroMotorista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Parceiro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fotografe seus documentos originais para análise da central.', style: TextStyle(color: AppColors.textGray)),
            const SizedBox(height: 30),
            _buildDocItem('Bilhete de Identidade / Passaporte', Icons.badge_outlined),
            _buildDocItem('Carta de Condução', Icons.drive_eta_outlined),
            _buildDocItem('Livrete do Veículo', Icons.article_outlined),
            _buildDocItem('Seguro / Inspecção', Icons.verified_user_outlined),
            const SizedBox(height: 15),
            Row(
              children: [
                Checkbox(value: true, onChanged: (v) {}),
                const Expanded(
                  child: Text(
                    'Aceito os Termos e Condições de Parceiro OX4.',
                    style: TextStyle(fontSize: 12, color: AppColors.textGray),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 30),
            TextField(
              decoration: InputDecoration(
                hintText: 'Placa do Carro (Ex: LD-12-34-AO)',
                filled: true,
                fillColor: AppColors.grayBg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/driver_approval'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('Enviar para Análise', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: AppColors.grayBorder), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue),
          const SizedBox(width: 15),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
          const Icon(Icons.add_a_photo, color: AppColors.lightBlue, size: 20),
        ],
      ),
    );
  }
}
