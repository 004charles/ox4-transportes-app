import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class TelaAvaliacao extends StatelessWidget {
  const TelaAvaliacao({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 100, color: AppColors.successGreen),
              const SizedBox(height: 20),
              const Text('Corrida Finalizada!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
              const Text('Valor Total: 2.500 Kz', style: TextStyle(fontSize: 18, color: AppColors.textGray)),
              const SizedBox(height: 40),
              const Text('Como foi sua viagem com Carlos?', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 40)),
              ),
              const SizedBox(height: 30),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Deixe um comentário (opcional)',
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
                  onPressed: () => Navigator.pushReplacementNamed(context, '/passenger_home'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  child: const Text('Enviar Avaliação', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
