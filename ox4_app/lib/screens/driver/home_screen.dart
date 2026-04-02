import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class TelaPrincipalMotorista extends StatelessWidget {
  const TelaPrincipalMotorista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.grayBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('0,00 Kz (Hoje)', style: TextStyle(color: AppColors.darkText, fontSize: 14)),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Você está Offline',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 10),
            const Text(
              'Fique online para começar a lucrar agora.',
              style: TextStyle(fontSize: 16, color: AppColors.textGray),
            ),
            const SizedBox(height: 50),
            
            // Go Online Button (Simulating Ride Request)
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/driver_alert'),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 10,
                      offset: const Offset(0, 15),
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'FICAR\nONLINE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textGray,
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/driver_earnings');
          if (index == 2) Navigator.pushNamed(context, '/driver_profile');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.drive_eta), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Ganhos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Conta'),
        ],
      ),
    );
  }
}
