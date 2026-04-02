import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class AlertaPedidoCorrida extends StatelessWidget {
  const AlertaPedidoCorrida({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Nova Solicitação!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
              const SizedBox(height: 10),
              const Text('Passageiro: João Paulo ⭐ 5.0', style: TextStyle(color: AppColors.textGray)),
              const Divider(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _info('Distância', '2.5 km'),
                  _info('Valor', '2.500 Kz'),
                  _info('Ganhos', '2.100 Kz'),
                ],
              ),
              const SizedBox(height: 30),
              const Text('Origem: Av. Central, 123', style: TextStyle(fontWeight: FontWeight.bold)),
              const Icon(Icons.arrow_downward, color: AppColors.lightBlue),
              const Text('Destino: Aeroporto Int.', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              Row(
                children: [
                   Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.dangerRed), padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Recusar', style: TextStyle(color: AppColors.dangerRed, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/driver_navigation'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.successGreen, padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Aceitar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(String label, String val) {
    return Column(children: [Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textGray)), Text(val, style: const TextStyle(fontWeight: FontWeight.bold))]);
  }
}
