import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ox4_motorista/services/auth_service.dart';
import 'package:ox4_motorista/screens/dashboard.dart';
import 'package:ox4_motorista/screens/upload_docs_screen.dart';
import 'package:ox4_motorista/theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  String? token = await messaging.getToken();
  if (token != null) {
    print("FCM TOKEN GERADO: \$token");
    // Tentativa silenciosa de atualizar o backend se tiver sessão ativa
    AuthService.updatePerfil({'fcm_token': token}); 
  }
  
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Recebi uma chamada de nova viagem em 1º plano!');
    // A UI poderia desenhar um AlertDialog aqui com o alerta "NOVA VIAGEM!"
  });

  runApp(const Ox4DriverApp());
}

class Ox4DriverApp extends StatelessWidget {
  const Ox4DriverApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OX4 Pro',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: DriverColors.primaryDark,
        cardColor: DriverColors.cardColor,
        primaryColor: DriverColors.accentGold,
        fontFamily: 'Inter',
      ),
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/upload_docs': (context) => const UploadDocsScreen(),
      },
    );
  }
}
