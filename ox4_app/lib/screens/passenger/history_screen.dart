import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class TelaHistoricoViagens extends StatelessWidget {
  const TelaHistoricoViagens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Viagens')),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: 5,
        separatorBuilder: (_, __) => const Divider(height: 30),
        itemBuilder: (context, index) {
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.grayBg, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.drive_eta, color: AppColors.primaryBlue),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Hoje, 10:15', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Av. Central -> Aeroporto Int.', style: TextStyle(color: AppColors.textGray, fontSize: 12)),
                  ],
                ),
              ),
              const Text('2.500 Kz', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
            ],
          );
        },
      ),
    );
  }
}
