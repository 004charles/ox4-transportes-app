import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';
import 'package:ox4_app/theme/map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

class TelaAcompanharViagem extends StatefulWidget {
  const TelaAcompanharViagem({Key? key}) : super(key: key);

  @override
  State<TelaAcompanharViagem> createState() => _TelaAcompanharViagemState();
}

class _TelaAcompanharViagemState extends State<TelaAcompanharViagem> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _driverLocation = const LatLng(-8.839988, 13.289437);
  Set<Marker> _markers = {};
  
  // Conexão direta Cloud
  final DatabaseReference _motoristaRef = FirebaseDatabase.instance.ref("motoristas/motorista_123/posicao");
  StreamSubscription? _posSubscription;

  @override
  void initState() {
    super.initState();
    _listenToDriver();
  }
  
  void _listenToDriver() {
    _posSubscription = _motoristaRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        double lat = data['latitude'].toDouble();
        double lng = data['longitude'].toDouble();
        double heading = data['heading']?.toDouble() ?? 0.0;
        
        setState(() {
          _driverLocation = LatLng(lat, lng);
          _markers.clear();
          _markers.add(Marker(
            markerId: const MarkerId('driver_live'),
            position: _driverLocation,
            rotation: heading, // Rota o ícone com a direção da rua
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow), // Exemplo (carro)
          ));
        });
        
        // Desliza a camara do utilizador juntamente com o carro
        _controller.future.then((mapCtrl) {
          mapCtrl.animateCamera(CameraUpdate.newLatLng(_driverLocation));
        });
      }
    });
  }
  
  @override
  void dispose() {
    _posSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Real Google Map
          Positioned.fill(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(target: _driverLocation, zoom: 16.0),
              markers: _markers,
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              style: Theme.of(context).brightness == Brightness.dark ? MapStyles.darkPremium : null,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                if (Theme.of(context).brightness == Brightness.dark) {
                  controller.setMapStyle(MapStyles.darkPremium);
                }
              },
            ),
          ),
          
          // SOS Button
          Positioned(
            top: 50,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: AppColors.dangerRed,
              onPressed: () {},
              child: const Text('SOS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),

          // Driver Info Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(radius: 30, backgroundColor: Theme.of(context).dividerColor.withOpacity(0.1), child: const Icon(Icons.person)),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Carlos Silva', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text('Toyota Corolla Prata • LD-12-34-AO', style: TextStyle(color: AppColors.textGray, fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.accentBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.call, color: AppColors.primaryBlue),
                      ),
                    ],
                  ),
                  const Divider(height: 30),
                  const Text('O Motorista está a caminho!', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.successGreen)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.dangerRed),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancelar Viagem', style: TextStyle(color: AppColors.dangerRed, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/ride_rating'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.successGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Simular Fim', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
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
