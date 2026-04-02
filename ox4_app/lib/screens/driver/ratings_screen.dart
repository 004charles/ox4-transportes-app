import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';

class TelaAvaliacoesMotorista extends StatelessWidget {
  const TelaAvaliacoesMotorista({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Avaliações')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text('Média Total', style: TextStyle(color: AppColors.textGray)),
                const Text('4.9', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (_) => const Icon(Icons.star, color: Colors.amber))),
                const Text('baseado em 128 viagens', style: TextStyle(fontSize: 12, color: AppColors.textGray)),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.grayBg, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('João P.', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('⭐ 5.0', style: TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Ótimo motorista, muito educado e o carro estava muito limpo. Recomendo!', style: TextStyle(color: AppColors.darkText, fontSize: 13)),
                      const SizedBox(height: 8),
                      const Text('Ontem, 14:20', style: TextStyle(color: AppColors.textGray, fontSize: 11)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
