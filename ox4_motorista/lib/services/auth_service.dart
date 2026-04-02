import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_config.dart';

class AuthService {
  static const bool useMock = false; // Altere para false para usar o Backend Real

  static Future<bool> login(String username, String password) async {
    if (useMock) return true; // Mock: Sempre sucesso
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/login/'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access']);
        await prefs.setString('refresh_token', data['refresh']);
        await prefs.setString('user_data', json.encode(data['user']));
        return true;
      }
      print('Erro de Login ${response.statusCode}: ${response.body}');
      return false;
    } catch (e) {
      print('Exceção no Login: $e');
      return false;
    }
  }

  static Future<bool> registrar({
    required String username,
    required String password,
    required String email,
    required String telefone,
    required String tipo,
  }) async {
    if (useMock) return true; // Mock: Sempre sucesso
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/registrar/'),
        body: {
          'username': username,
          'password': password,
          'email': email,
          'telefone': telefone,
          'tipo': tipo,
        },
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', data['access']);
        return true;
      }
      print('Erro de Registro: ${response.statusCode} - ${response.body}');
      return false;
    } catch (e) {
      print('Exceção no Registro: $e');
      return false;
    }
  }

  static Future<bool> verificarCodigo(String telefone, String codigo) async {
    if (useMock) return true; // Mock: Sempre sucesso
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/verificar-codigo/'),
        body: {'telefone': telefone, 'codigo': codigo},
      );
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Erro na Verificação: $e');
      return false;
    }
  }

  static Future<bool> reenviarCodigo(String telefone) async {
    if (useMock) return true; // Mock: Sempre sucesso
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/enviar-codigo/'),
        body: {'telefone': telefone},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao Reenviar: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<Map<String, dynamic>?> getPerfil() async {
    if (useMock) return {'username': 'joao_paulo', 'first_name': 'João Paulo', 'email': 'joao.paulo@ox4.com', 'telefone': '+244 923 000 000'};
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/perfil/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Erro ao obter perfil: $e');
      return null;
    }
  }

  static Future<bool> updatePerfil(Map<String, dynamic> data, {String? imagePath}) async {
    if (useMock) return true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      
      // Se houver imagem, usamos MultipartRequest
      if (imagePath != null) {
        var request = http.MultipartRequest('PATCH', Uri.parse('${ApiConfig.baseUrl}/perfil/'));
        request.headers['Authorization'] = 'Bearer $token';
        
        // Adicionar campos de texto
        data.forEach((key, value) {
          request.fields[key] = value.toString();
        });
        
        // Adicionar imagem
        request.files.add(await http.MultipartFile.fromPath('foto_perfil', imagePath));
        
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        return response.statusCode == 200;
      } else {
        // Fallback para JSON normal se não houver foto
        final response = await http.patch(
          Uri.parse('${ApiConfig.baseUrl}/perfil/'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode(data),
        );
        return response.statusCode == 200;
      }
    } catch (e) {
      print('Erro ao atualizar perfil: $e');
      return false;
    }
  }

  static Future<bool> deletarConta() async {
    if (useMock) return true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/deletar-conta/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 204) {
        await logout();
        return true;
      }
      return false;
    } catch (e) {
      print('Erro ao deletar conta: $e');
      return false;
    }
  }

  static Future<List<dynamic>> getCorridasPendentes() async {
    if (useMock) return [];
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/corridas/pendentes/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      print('Erro ao buscar corridas: $e');
      return [];
    }
  }

  static Future<bool> mudarEstadoCorrida(int id, String status) async {
    if (useMock) return true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/corridas/$id/estado/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'status': status}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao mudar estado: $e');
      return false;
    }
  }
}
