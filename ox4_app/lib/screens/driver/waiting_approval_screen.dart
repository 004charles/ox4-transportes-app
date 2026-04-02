import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class TelaAguardandoAprovacao extends StatelessWidget {
  const TelaAguardandoAprovacao({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.hourglass_bottom, size: 100, color: Colors.amber),
              const SizedBox(height: 30),
              const Text('Em Análise...', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
              const SizedBox(height: 15),
              const Text(
                'Seus documentos foram recebidos e nossa equipa está validando (Prazo: 24h). Você receberá um SMS quando for aprovado.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGray, height: 1.5),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/driver_home'),
                child: const Text('Simular Aprovação (Demo)'),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Sair do App', style: TextStyle(color: AppColors.dangerRed, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
