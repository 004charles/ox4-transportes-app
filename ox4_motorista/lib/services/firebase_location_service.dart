import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseLocationService {
  StreamSubscription<Position>? _positionStream;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  
  // Exemplo de ID fixo (numa aplicação real, pegar do usuário logado)
  final String _driverId = "motorista_123";

  // Começa a transmitir o sinal de GPS físico para o Firebase em Tempo Real
  void startStreamingLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 3, // Envia para a net a cada 3 metros mexidos para suavizar o carro
    );

    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
          
      // Puxando as cordenadas e espetando instantaneamente na árvore da Google Cloud!
      _dbRef.child("motoristas/$_driverId/posicao").set({
        "latitude": position.latitude,
        "longitude": position.longitude,
        "heading": position.heading, // Serve para virar a testa do carro!
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });
      
      print("📡 Emitindo Pos: \${position.latitude}, \${position.longitude}");
    });
  }

  void stopStreamingLocation() {
    _positionStream?.cancel();
    _dbRef.child("motoristas/$_driverId/status").set("OFFLINE");
  }
}
