import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationService {
  static const String apiKey = 'AIzaSyBeSLqVhpYN2wh9UvVKE0OwQxdRv-2RAeE';

  // Autocomplete: retorna uma lista de previsões baseadas no que o utilizador está a escrever
  static Future<List<dynamic>> getAutocomplete(String search) async {
    if (search.isEmpty) return [];

    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&components=country:ao&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return data['predictions'];
        }
      }
      return [];
    } catch (e) {
      print('Erro ao obter autocomplete: $e');
      return [];
    }
  }

  // Obter as coordenadas exatas através do PlaceId retornado no Autocomplete
  static Future<Map<String, double>?> getPlaceDetails(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=geometry&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final location = data['result']['geometry']['location'];
          return {
            'lat': location['lat'],
            'lng': location['lng'],
          };
        }
      }
      return null;
    } catch (e) {
      print('Erro ao obter detalhes do local: $e');
      return null;
    }
  }

  // Distance Matrix: Calcula a distância e ETA exatos tendo em conta as ruas e tráfego
  static Future<Map<String, dynamic>?> getDistanceMatrix(
      double startLat, double startLng, double endLat, double endLng) async {
    final String origin = '$startLat,$startLng';
    final String destination = '$endLat,$endLng';
    
    final String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['rows'].isNotEmpty) {
          final elements = data['rows'][0]['elements'][0];
          if (elements['status'] == 'OK') {
            // value é retornado em metros e segundos
            return {
              'distance_text': elements['distance']['text'],
              'distance_value': elements['distance']['value'], // metros
              'duration_text': elements['duration']['text'],
              'duration_value': elements['duration']['value'], // segundos
            };
          }
        }
      }
      return null;
    } catch (e) {
      print('Erro na Distance Matrix: $e');
      return null;
    }
  }

  // Permissões e captura de posição via Geolocator
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings(); // Força o usuário a abrir menu de GPS
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }
}
