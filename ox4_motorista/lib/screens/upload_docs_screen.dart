import 'package:flutter/material.dart';
import 'package:ox4_motorista/theme/colors.dart';

class UploadDocsScreen extends StatelessWidget {
  const UploadDocsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DriverColors.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.security, size: 80, color: DriverColors.accentGold),
              const SizedBox(height: 30),
              const Text(
                'Conta Pendente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DriverColors.textWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Por razões de segurança, precisamos de verificar os seus documentos para aprovar a sua viatura no sistema.\n\nPor favor, tire uma fotografia do seu B.I. e Carta de Condução.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: DriverColors.textGray,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 50),
              
              _buildUploadButton(Icons.badge, 'Tirar foto do Bilhete (B.I.)'),
              const SizedBox(height: 20),
              _buildUploadButton(Icons.directions_car, 'Tirar foto da Carta de Condução'),
              
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Num ambiente 100% nativo enviaríamos a imagem via multipart.
                  // Simulando envio à central de verificação.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Documentos enviados para verificação da Central OX4.'), backgroundColor: DriverColors.successGreen)
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: DriverColors.accentGold,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('SUBMETER PARA ANÁLISE', style: TextStyle(color: DriverColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: DriverColors.cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: DriverColors.textGray.withOpacity(0.3), width: 1),
      ),
      child: ListTile(
        leading: Icon(icon, color: DriverColors.textWhite),
        title: Text(title, style: const TextStyle(color: DriverColors.textWhite, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.camera_alt, color: DriverColors.accentGold),
        onTap: () {
          // Open camera logic
        },
      ),
    );
  }
}
