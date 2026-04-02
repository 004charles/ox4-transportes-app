import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ox4_app/theme/colors.dart';
import 'package:ox4_app/widgets/app_logo.dart';
import 'package:ox4_app/screens/splash_screen.dart';
import 'package:ox4_app/screens/login_screen.dart';
import 'package:ox4_app/screens/registration_screen.dart';
import 'package:ox4_app/screens/otp_screen.dart';
import 'package:ox4_app/screens/passenger/home_screen.dart';
import 'package:ox4_app/screens/passenger/busca_destino_screen.dart';
import 'package:ox4_app/screens/passenger/confirm_ride_screen.dart';
import 'package:ox4_app/screens/passenger/ride_tracking_screen.dart';
import 'package:ox4_app/screens/passenger/rating_screen.dart';
import 'package:ox4_app/screens/passenger/full_menu_screen.dart';
import 'package:ox4_app/screens/passenger/wallet_screen.dart';
import 'package:ox4_app/screens/passenger/history_screen.dart';
import 'package:ox4_app/screens/passenger/profile_screen.dart';
import 'package:ox4_app/screens/passenger/invite_contacts_screen.dart';
import 'package:ox4_app/screens/passenger/definicoes_screen.dart';
import 'package:ox4_app/screens/passenger/delivery_status_screen.dart';
import 'package:ox4_app/screens/passenger/frete_status_screen.dart';
import 'package:ox4_app/screens/passenger/searching_driver_screen.dart';
import 'package:ox4_app/screens/driver/home_screen.dart';
import 'package:ox4_app/screens/driver/earnings_screen.dart';
import 'package:ox4_app/screens/driver/registration_screen.dart';
import 'package:ox4_app/screens/driver/waiting_approval_screen.dart';
import 'package:ox4_app/screens/driver/ride_request_alert.dart';
import 'package:ox4_app/screens/driver/ride_navigation_screen.dart';
import 'package:ox4_app/screens/driver/profile_screen.dart';
import 'package:ox4_app/screens/driver/ratings_screen.dart';
import 'package:ox4_app/screens/legal_screen.dart';

import 'package:ox4_app/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const OX4App());
}

class OX4App extends StatelessWidget {
  const OX4App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeService.themeMode,
      builder: (context, mode, child) {
        return MaterialApp(
          title: 'OX4 Transportes',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.white,
            primaryColor: AppColors.primaryBlue,
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryBlue,
              secondary: AppColors.lightBlue,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.white,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: AppColors.primaryBlue),
              titleTextStyle: TextStyle(color: AppColors.primaryBlue, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: AppColors.primaryBlue,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryBlue,
              secondary: AppColors.lightBlue,
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => const TelaSplash(),
            '/login': (context) => const TelaLogin(),
            '/register': (context) => const TelaCadastro(),
            '/otp': (context) => const TelaOTP(),
            '/passenger_home': (context) => const TelaPrincipalPassageiro(),
            '/busca_destino': (context) => const TelaBuscaDestino(),
            '/full_menu': (context) => const FullMenuScreen(),
            '/confirm_ride': (context) => const TelaConfirmarCorrida(),
            '/searching_driver': (context) => const TelaBuscandoMotorista(),
            '/ride_tracking': (context) => const TelaAcompanharViagem(),
            '/ride_rating': (context) => const TelaAvaliacao(),
            '/passenger_wallet': (context) => const TelaCarteira(),
            '/passenger_history': (context) => const TelaHistoricoViagens(),
            '/profile': (context) => const TelaPerfil(),
            '/invite': (context) => const TelaConvidarAmigos(),
            '/settings': (context) => const TelaDefinicoes(),
            '/driver_home': (context) => const TelaPrincipalMotorista(),
            '/driver_register': (context) => const TelaCadastroMotorista(),
            '/driver_approval': (context) => const TelaAguardandoAprovacao(),
            '/driver_alert': (context) => const AlertaPedidoCorrida(),
            '/driver_navigation': (context) => const TelaNavegacaoMotorista(),
            '/driver_earnings': (context) => const TelaGanhosMotorista(),
            '/driver_profile': (context) => const TelaPerfilMotorista(),
            '/driver_ratings': (context) => const TelaAvaliacoesMotorista(),
            '/terms': (context) => const TelaLegal(title: 'Termos e Condições'),
            '/privacy': (context) => const TelaLegal(title: 'Política de Privacidade'),
            '/delivery_status': (context) => const DeliveryStatusScreen(),
            '/frete_status': (context) => const FreteStatusScreen(),
          },
        );
      },
    );
  }
}
