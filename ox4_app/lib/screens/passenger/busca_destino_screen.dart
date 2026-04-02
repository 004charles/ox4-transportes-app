import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';
import 'package:ox4_app/services/location_service.dart';
import 'dart:async';

class TelaBuscaDestino extends StatefulWidget {
  const TelaBuscaDestino({Key? key}) : super(key: key);

  @override
  State<TelaBuscaDestino> createState() => _TelaBuscaDestinoState();
}

class _TelaBuscaDestinoState extends State<TelaBuscaDestino> {
  final TextEditingController _originController = TextEditingController(text: 'A minha localização atual');
  final TextEditingController _destinationController = TextEditingController();
  List<dynamic> _placeList = [];
  Timer? _debounce;
  bool _isLoading = false;
  bool _isSearchingOrigin = false;
  
  Map<String, double>? _originCoords;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final pos = await LocationService.getCurrentPosition();
    if (pos != null) {
      setState(() {
        _originCoords = {'lat': pos.latitude, 'lng': pos.longitude};
        _originController.text = 'A minha localização atual';
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty) {
        setState(() => _isLoading = true);
        final results = await LocationService.getAutocomplete(query);
        setState(() {
          _placeList = results;
          _isLoading = false;
        });
      } else {
        setState(() => _placeList = []);
      }
    });
  }

  Future<void> _selectPlace(String placeId, String description) async {
    setState(() => _isLoading = true);
    final details = await LocationService.getPlaceDetails(placeId);
    setState(() => _isLoading = false);

    if (details != null && mounted) {
      if (_isSearchingOrigin) {
        setState(() {
          _originController.text = description;
          _originCoords = details;
          _placeList = [];
        });
      } else {
        // Passar TUDO dinâmico para ConfirmRide
        Navigator.pushNamed(context, '/confirm_ride', arguments: {
          'originName': _originController.text,
          'originLat': _originCoords?['lat'] ?? -8.839988,
          'originLng': _originCoords?['lng'] ?? 13.289437,
          'destinationName': description,
          'destinationLat': details['lat'],
          'destinationLng': details['lng']
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível obter a localização exata.')));
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Para onde vamos?')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Pickup Location (Using Geolocator position by default)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: _originController,
                enabled: true,
                onTap: () => setState(() => _isSearchingOrigin = true),
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  icon: const Icon(Icons.my_location, color: AppColors.primaryBlue, size: 20),
                  hintText: 'A minha localização atual',
                  border: InputBorder.none,
                  suffixIcon: IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () { _originController.clear(); }),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Destination Location
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: _destinationController,
                autofocus: true,
                onTap: () => setState(() => _isSearchingOrigin = false),
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  icon: const Icon(Icons.location_on, color: AppColors.primaryBlue, size: 20),
                  hintText: 'Insira o Destino (Ex: Zango...)',
                  border: InputBorder.none,
                  suffixIcon: _isLoading 
                      ? const SizedBox(width: 20, height: 20, child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2))) 
                      : IconButton(icon: const Icon(Icons.clear), onPressed: () { _destinationController.clear(); setState(() => _placeList = []); }),
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // Suggestions List
            Expanded(
              child: _placeList.isEmpty 
                  ? ListView(
                      children: [
                        _suggestionItem(Icons.home, 'Casa', 'Rua das Flores, 456', () {}),
                        _suggestionItem(Icons.work, 'Trabalho', 'Edifício Comercial, Sala 12', () {}),
                      ],
                    )
                  : ListView.builder(
                      itemCount: _placeList.length,
                      itemBuilder: (context, index) {
                        final place = _placeList[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on, color: AppColors.textGray),
                          title: Text(place['structured_formatting']['main_text'] ?? place['description'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(place['structured_formatting']['secondary_text'] ?? '', style: const TextStyle(fontSize: 12)),
                          onTap: () => _selectPlace(place['place_id'], place['description']),
                        );
                      },
                    ),
            ),
          ],
        ),
      )
    );
  }

  Widget _suggestionItem(IconData icon, String title, String sub, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textGray),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
      onTap: onTap,
    );
  }
}
