import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';
import 'package:ox4_app/theme/map_style.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ox4_app/services/api_config.dart';
import 'package:ox4_app/services/auth_service.dart';

class TelaConfirmarCorrida extends StatefulWidget {
  const TelaConfirmarCorrida({Key? key}) : super(key: key);

  @override
  State<TelaConfirmarCorrida> createState() => _TelaConfirmarCorridaState();
}

class _TelaConfirmarCorridaState extends State<TelaConfirmarCorrida> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng _origin = const LatLng(-8.839988, 13.289437); 
  LatLng _destination = const LatLng(-8.855000, 13.295000); 
  String _originName = 'A minha localização';
  String _destinationName = 'Avenida Samora Machel';

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  
  int _selectedTabIndex = 0; 
  int _selectedCarIndex = 1; 
  
  Map<String, dynamic> _prices = {};
  bool _isLoadingPricing = true;
  String _estMinutos = '...';
  String _arrivalTime = '...';
  bool _isRequesting = false;

  ScreenCoordinate? _originScreen;
  ScreenCoordinate? _destinationScreen;

  Future<void> _updateBubblePositions() async {
    final controller = await _controller.future;
    final originPos = await controller.getScreenCoordinate(_origin);
    final destPos = await controller.getScreenCoordinate(_destination);
    if (mounted) {
      setState(() {
        _originScreen = originPos;
        _destinationScreen = destPos;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Inicia os dados assim que os frames forem montados para capturar os Arguments do ModalRoute
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadArguments());
  }

  void _loadArguments() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      setState(() {
        _origin = LatLng(args['originLat'], args['originLng']);
        _destination = LatLng(args['destinationLat'], args['destinationLng']);
        _originName = args['originName'] ?? 'A minha localização';
        _destinationName = args['destinationName'] ?? 'Destino';
      });
      _setMapMarkers();
      _fetchEstimates();
    }
  }
  
  Future<void> _fetchEstimates() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/estimativa/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'origem_lat': _origin.latitude,
          'origem_lng': _origin.longitude,
          'destino_lat': _destination.latitude,
          'destino_lng': _destination.longitude,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final int minutos = data['tempo_minutos'] ?? 0;
        final arrival = DateTime.now().add(Duration(minutes: minutos));
        
        setState(() {
          _prices = data['precos'];
          _estMinutos = '$minutos min';
          _arrivalTime = '${arrival.hour.toString().padLeft(2, '0')}:${arrival.minute.toString().padLeft(2, '0')}';
          _isLoadingPricing = false;
        });
        _updateBubblePositions();
      }
    } catch (e) {
      print('Erro ao carregar preços: \$e');
      setState(() => _isLoadingPricing = false);
    }
  }

  void _setMapMarkers() {
    setState(() {
      _markers.clear();
      _polylines.clear();
      _markers.add(Marker(markerId: const MarkerId('origin'), position: _origin));
      _markers.add(Marker(markerId: const MarkerId('destination'), position: _destination, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));

      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [_origin, _destination],
          color: AppColors.brandRed, // Red route
          width: 5,
        ),
      );
    });
  }

  Widget _buildTimeBubble(String label, {bool isOrigin = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isOrigin ? AppColors.brandRed : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isOrigin ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Future<void> _handlePedir() async {
    setState(() => _isRequesting = true);
    
    // Mapear tipo de carro selecionado
    String tipo = 'ECONOMIA';
    if (_selectedTabIndex == 1) {
      tipo = 'FRETE';
    } else {
      if (_selectedCarIndex == 0) tipo = 'MOTO';
      if (_selectedCarIndex == 2) tipo = 'CONFORTO';
    }

    final result = await AuthService.criarCorrida({
      'origem': _originName,
      'destino': _destinationName,
      'origem_lat': _origin.latitude,
      'origem_lng': _origin.longitude,
      'destino_lat': _destination.latitude,
      'destino_lng': _destination.longitude,
      'tipo_carro': tipo,
      'preco_estimado': _prices[tipo.toLowerCase().replaceAll('economia', 'economy').replaceAll('conforto', 'comfort')] ?? 'Consultar',
    });

    setState(() => _isRequesting = false);

    if (result != null && mounted) {
      Navigator.pushNamed(context, '/searching_driver', arguments: result);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao solicitar viagem. Verifique sua conexão.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mapa
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.45, // Deixa espaço para o BottomSheet de 45%
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(target: _origin, zoom: 14.0),
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              style: MapStyles.minimalistLight,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                _updateBubblePositions(); // Inicializa posições
              },
              onCameraMove: (position) => _updateBubblePositions(),
            ),
          ),

          // Balões de Tempo Dinâmicos (Stack Overlay)
          if (_originScreen != null)
            Positioned(
              left: _originScreen!.x.toDouble() - 40,
              top: _originScreen!.y.toDouble() - 60,
              child: _buildTimeBubble('\$_estMinutos', isOrigin: true),
            ),
          if (_destinationScreen != null)
            Positioned(
              left: _destinationScreen!.x.toDouble() - 60,
              top: _destinationScreen!.y.toDouble() - 60,
              child: _buildTimeBubble('chegada às \$_arrivalTime', isOrigin: false),
            ),
          
          // Back Button flutuante Top-Left
          Positioned(
            top: 50,
            left: 15,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black87),
              ),
            ),
          ),

          // Bottom Sheet Customizado "Estilo Yango"
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.48, // Quase metade da tela
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, -5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Handle bar
                   Align(
                     alignment: Alignment.center,
                     child: Container(
                       margin: const EdgeInsets.only(top: 10),
                       height: 4,
                       width: 40,
                       decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                     ),
                   ),
                   const SizedBox(height: 15),

                   // Destination Title Bar
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: Row(
                       children: [
                         const Icon(Icons.person_pin_circle, color: Colors.black87),
                         const SizedBox(width: 15),
                         Expanded(child: Text(_destinationName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                       ],
                     ),
                   ),

                   // Origin Bar
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                     child: Row(
                       children: [
                         const Icon(Icons.flag, color: Colors.black54),
                         const SizedBox(width: 15),
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                                Text(_originName, style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                                Text('Localização Atual • Precisão GPS', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                             ],
                           ),
                         ),
                         Container(
                           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                           decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
                           child: const Text('Paragens', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                         )
                       ],
                     ),
                   ),

                   // Tabs: Viagens | Entrega
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: Row(
                       children: [
                         _buildTab('Viagens', 0),
                         const SizedBox(width: 20),
                         _buildTab('Entrega', 1),
                       ],
                     ),
                   ),
                   const SizedBox(height: 15),

                   // Carrousel de Carros
                   SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: _isLoadingPricing 
                       ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                       : Row(
                           children: _selectedTabIndex == 0 
                             ? [
                                 _buildCarCard(0, 'Moto', _prices['moto'] ?? '...', _estMinutos, Icons.motorcycle),
                                 const SizedBox(width: 10),
                                 _buildCarCard(1, 'Economy', _prices['economy'] ?? '...', _estMinutos, Icons.directions_car),
                                 const SizedBox(width: 10),
                                 _buildCarCard(2, 'Comfort', _prices['comfort'] ?? '...', _estMinutos, Icons.local_taxi),
                               ]
                             : [
                                 _buildCarCard(0, 'Frete Carga', _prices['frete'] ?? '...', _estMinutos, Icons.local_shipping),
                                 const SizedBox(width: 10),
                                 _buildCarCard(1, 'Encomenda VIP', _prices['frete'] ?? '...', _estMinutos, Icons.two_wheeler),
                               ],
                         ),
                   ),

                   const Spacer(),
                   
                   // Promo Line
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         const Text('+150Kz e podes viajar na\nComfort+', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                         const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                       ],
                     ),
                   ),

                   const SizedBox(height: 15),

                   // Action Bottom Bar
                   Padding(
                     padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                     child: Row(
                       children: [
                         const Icon(Icons.payments_outlined, color: Colors.green, size: 30),
                         const SizedBox(width: 15),
                         Expanded(
                           child: ElevatedButton(
                             onPressed: _isRequesting ? null : _handlePedir,
                             style: ElevatedButton.styleFrom(
                               backgroundColor: AppColors.primaryBlue, 
                               padding: const EdgeInsets.symmetric(vertical: 16),
                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                             ),
                             child: _isRequesting 
                               ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                               : const Text('Pedir', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                           ),
                         ),
                         const SizedBox(width: 15),
                         const Icon(Icons.tune, color: Colors.black54, size: 28),
                       ],
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

  Widget _buildTab(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[200] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title, 
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey,
          )
        ),
      ),
    );
  }

  Widget _buildCarCard(int index, String title, String price, String time, IconData icon) {
    bool isSelected = _selectedCarIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedCarIndex = index),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[200] : Colors.transparent,
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey[300]!, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Container(
                   padding: const EdgeInsets.all(4),
                   decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)]),
                   child: Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                 ),
                 Icon(icon, color: Colors.black54, size: 28),
               ],
             ),
             const SizedBox(height: 15),
             Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
             Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
