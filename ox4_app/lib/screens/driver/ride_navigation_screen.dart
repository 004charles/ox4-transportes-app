import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class TelaNavegacaoMotorista extends StatelessWidget {
  const TelaNavegacaoMotorista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // GPS Map Mock
          Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.navigation, size: 80, color: AppColors.primaryBlue))),
          
          // Directions Bar
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.primaryBlue, borderRadius: BorderRadius.circular(16)),
              child: const Text('Siga em frente na Av. Central - 500m', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),

          // SOS
          Positioned(bottom: 250, right: 20, child: FloatingActionButton(backgroundColor: AppColors.dangerRed, onPressed: () {}, child: const Text('SOS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),

          // Bottom Controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 25, backgroundColor: AppColors.grayBg, child: Icon(Icons.person)),
                      const SizedBox(width: 15),
                      const Expanded(child: Text('Indo buscar João Paulo', style: TextStyle(fontWeight: FontWeight.bold))),
                      IconButton(icon: const Icon(Icons.chat, color: AppColors.primaryBlue), onPressed: () {}),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/ride_rating'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
                      child: const Text('Finalizar Corrida (Receber 2.500 Kz)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
