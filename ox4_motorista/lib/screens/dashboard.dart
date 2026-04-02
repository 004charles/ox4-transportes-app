import 'package:flutter/material.dart';
import 'package:ox4_motorista/theme/colors.dart';
import 'package:ox4_motorista/services/firebase_location_service.dart';
import 'package:ox4_motorista/services/auth_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isOnline = false;
  final FirebaseLocationService _locationService = FirebaseLocationService();
  Completer<GoogleMapController> _controller = Completer();
  LatLng _driverLocation = const LatLng(-8.839988, 13.289437); // Luanda
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _pollingTimer;
  bool _showingRideModal = false;

  @override
  void initState() {
    super.initState();
    _checkApprovalStatus();
  }

  void _checkApprovalStatus() async {
    final profile = await AuthService.getPerfil();
    if (profile == null) {
      // Not logged in -> Should go to login
      return;
    }
    
    // Verificação Brutal do Django Approval Status
    if (profile['perfil_motorista'] == null || profile['perfil_motorista']['aprovado'] == false) {
      if (mounted) {
         Navigator.pushReplacementNamed(context, '/upload_docs');
      }
    }
  }

  @override
  void dispose() {
    _locationService.stopStreamingLocation();
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
       if (!isOnline || _showingRideModal) return;
       final corridas = await AuthService.getCorridasPendentes();
       if (corridas.isNotEmpty) {
         _showIncomingRide(corridas.first);
       }
    });
  }

  void _showIncomingRide(Map<String, dynamic> ride) {
    setState(() => _showingRideModal = true);
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: DriverColors.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('NOVO PEDIDO!', style: TextStyle(color: DriverColors.accentGold, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _rideInfoItem(Icons.location_on, 'DE:', ride['origem']),
            _rideInfoItem(Icons.flag, 'PARA:', ride['destino']),
            const SizedBox(height: 10),
            Text('PREÇO: \${ride['preco_estimado']} Kz', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _showingRideModal = false);
                    },
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white)),
                    child: const Text('IGNORAR', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final success = await AuthService.mudarEstadoCorrida(ride['id'], 'ACEITE');
                      if (success && mounted) {
                         Navigator.pop(context);
                         setState(() => _showingRideModal = false);
                         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Viagem Aceite! A caminho da origem.')));
                         // Aqui navegaria para o ecrã de navegação
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: DriverColors.successGreen),
                    child: const Text('ACEITAR', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ).then((_) => setState(() => _showingRideModal = false));
  }

  Widget _rideInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Expanded(child: Text(value, style: const TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: DriverColors.primaryDark,
      drawer: Drawer(
        backgroundColor: DriverColors.primaryDark,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: DriverColors.cardColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(radius: 30, backgroundColor: DriverColors.accentGold, child: Icon(Icons.person, size: 40, color: Colors.white)),
                  const SizedBox(height: 10),
                  const Text('Motorista OX4', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Ver Perfil', style: TextStyle(color: DriverColors.accentGold.withOpacity(0.8), fontSize: 13)),
                ],
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard', () => Navigator.pop(context)),
            _buildDrawerItem(Icons.account_balance_wallet, 'Ganhos', () {}),
            _buildDrawerItem(Icons.history, 'Histórico', () {}),
            _buildDrawerItem(Icons.settings, 'Definições', () {}),
            const Divider(color: DriverColors.textGray, height: 40, thickness: 0.5, indent: 20, endIndent: 20),
            _buildDrawerItem(Icons.logout, 'Sair', () async {
               await AuthService.logout();
               if(mounted) Navigator.pushReplacementNamed(context, '/login');
            }, isLogout: true),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Mapa
          Positioned.fill(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(target: _driverLocation, zoom: 15.0),
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                // controller.setMapStyle(...) // Vamos inserir o Dark Mode aqui depois
              },
            ),
          ),
          
          // Barra de Status Superior
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    await AuthService.logout();
                    if (mounted) {
                      // Simulação de volta para o login (A app do motorista deve ter um login_screen, mas para este MVP voltamos ao início ou fechamos)
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sessão Terminada.')));
                    }
                  },
                  child: CircleAvatar(backgroundColor: DriverColors.cardColor, child: const Icon(Icons.person, color: DriverColors.accentGold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isOnline ? DriverColors.successGreen : DriverColors.cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)],
                  ),
                  child: Text(
                    isOnline ? 'ESTADO: ONLINE' : 'ESTADO: OFFLINE',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: () => _scaffoldKey.currentState?.openDrawer(),
                  child: CircleAvatar(backgroundColor: DriverColors.cardColor, child: const Icon(Icons.menu, color: DriverColors.textWhite)),
                ),
              ],
            ),
          ),

          // Painel de Ganhos / Botão Power
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 250,
              decoration: const BoxDecoration(
                color: DriverColors.cardColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 15, offset: Offset(0, -5))],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isOnline = !isOnline;
                        if(isOnline) {
                           _locationService.startStreamingLocation();
                           _startPolling();
                        } else {
                           _locationService.stopStreamingLocation();
                           _pollingTimer?.cancel();
                        }
                      });
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isOnline ? DriverColors.dangerRed : DriverColors.successGreen,
                        boxShadow: [
                          BoxShadow(color: isOnline ? DriverColors.dangerRed.withOpacity(0.5) : DriverColors.successGreen.withOpacity(0.5), blurRadius: 20)
                        ]
                      ),
                      child: const Icon(Icons.power_settings_new, color: Colors.white, size: 40),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Ganhos de Hoje', style: TextStyle(color: DriverColors.textGray)),
                  const SizedBox(height: 5),
                  const Text('0.00 Kz', style: TextStyle(color: DriverColors.accentGold, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMetric('Corridas', '0'),
                      Container(height: 40, width: 1, color: DriverColors.textGray.withOpacity(0.2)),
                      _buildMetric('Tempo Online', '0h 0m'),
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
  
  Widget _buildMetric(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: DriverColors.textGray, fontSize: 12)),
        Text(value, style: const TextStyle(color: DriverColors.textWhite, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.redAccent : DriverColors.textWhite),
      title: Text(title, style: TextStyle(color: isLogout ? Colors.redAccent : DriverColors.textWhite)),
      onTap: onTap,
    );
  }
}
