import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';
import 'package:ox4_app/services/auth_service.dart';
import 'dart:async';

class TelaBuscandoMotorista extends StatefulWidget {
  const TelaBuscandoMotorista({Key? key}) : super(key: key);

  @override
  State<TelaBuscandoMotorista> createState() => _TelaBuscandoMotoristaState();
}

class _TelaBuscandoMotoristaState extends State<TelaBuscandoMotorista> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  Timer? _statusTimer;
  Map<String, dynamic>? _rideData;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.5, end: 2.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // Inicia Polling real assim que os frames montarem
    WidgetsBinding.instance.addPostFrameCallback((_) => _startPolling());
  }

  void _startPolling() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null || args['id'] == null) return;
    _rideData = args;

    _statusTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
       if (_rideData == null) return;
       final statusData = await AuthService.getStatusCorrida(_rideData!['id']);
       if (statusData != null && statusData['status'] == 'ACEITE') {
           timer.cancel();
           if (mounted) {
             Navigator.pushReplacementNamed(context, '/ride_tracking', arguments: statusData);
           }
       }
    });

    // Timeout de 1 minuto para não ficar infinitamente buscando no MVP
    Future.delayed(const Duration(minutes: 1), () {
      _statusTimer?.cancel();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryBlue.withOpacity(0.5),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryBlue,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                  ),
                  child: const Icon(Icons.search, color: Colors.white, size: 40),
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Text(
              'Buscando Motorista...',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
            ),
            const SizedBox(height: 10),
            Text(
              'A verificar viaturas num raio de 5 Kms',
              style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6), fontSize: 14),
            ),
            const SizedBox(height: 50),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.dangerRed),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Cancelar Pedido', style: TextStyle(color: AppColors.dangerRed, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
