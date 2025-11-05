import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // --------------------------
  // 🔐 TOKEN HANDLING
  // --------------------------

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // --------------------------
  // 🌍 BASE URL
  // --------------------------

  Uri _uri(String endpoint) => Uri.parse("${Config.baseUrl}$endpoint");

  // --------------------------
  // 🧾 GENERIC REQUEST METHODS
  // --------------------------

  Future<Map<String, dynamic>> _get(String endpoint) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await _client.get(_uri(endpoint), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('GET failed: ${response.statusCode} → ${response.body}');
    }
  }

  Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await _client.post(
      _uri(endpoint),
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('POST failed: ${response.statusCode} → ${response.body}');
    }
  }

  Future<Map<String, dynamic>> _put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await _client.put(
      _uri(endpoint),
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('PUT failed: ${response.statusCode} → ${response.body}');
    }
  }

  Future<Map<String, dynamic>> _delete(String endpoint) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await _client.delete(_uri(endpoint), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'DELETE failed: ${response.statusCode} → ${response.body}',
      );
    }
  }

  // --------------------------
  // 👤 AUTHENTICATION
  // --------------------------

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _post(Config.loginEndpoint, {
      'email': email,
      'password': password,
    });

    if (response.containsKey('token')) {
      await _storeToken(response['token']);
    }

    return response;
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await _post(Config.registerEndpoint, {
      'name': name,
      'email': email,
      'password': password,
    });
    return response;
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final response = await _post(Config.verifyOtpEndpoint, {
      'email': email,
      'otp': otp,
    });

    if (response.containsKey('token')) {
      await _storeToken(response['token']);
    }

    return response;
  }

  Future<void> logout() async => await _removeToken();

  // --------------------------
  // 🌦️ FARM DATA & DASHBOARD
  // --------------------------

  Future<Map<String, dynamic>> fetchWeather(
    double latitude,
    double longitude,
  ) async {
    return await _get("${Config.weatherEndpoint}?lat=$latitude&lon=$longitude");
  }

  Future<List<Map<String, dynamic>>> fetchCropSuggestions() async {
    final response = await _get(Config.cropSuggestionsEndpoint);
    return List<Map<String, dynamic>>.from(response['crops'] ?? []);
  }

  Future<List<Map<String, dynamic>>> fetchCropSuggestionsWithParams(
    Map<String, dynamic> farmData,
  ) async {
    final response = await _post(Config.cropSuggestionsEndpoint, farmData);
    return List<Map<String, dynamic>>.from(response['crops'] ?? []);
  }

  Future<List<Map<String, dynamic>>> fetchCurrentCrops() async {
    final response = await _get(Config.currentCropsEndpoint);
    return List<Map<String, dynamic>>.from(response['crops'] ?? []);
  }

  Future<Map<String, dynamic>> addCrop(Map<String, dynamic> cropData) async {
    return await _post(Config.addCropEndpoint, cropData);
  }

  Future<Map<String, dynamic>> removeCrop(String cropId) async {
    return await _delete("${Config.removeCropEndpoint}/$cropId");
  }

  Future<List<Map<String, dynamic>>> fetchMarketPrices() async {
    final response = await _get(Config.marketPricesEndpoint);
    return List<Map<String, dynamic>>.from(response['prices'] ?? []);
  }

  Future<Map<String, dynamic>> fetchIrrigationStatus() async {
    return await _get(Config.irrigationStatusEndpoint);
  }

  Future<Map<String, dynamic>> fetchFarmConfig() async {
    return await _get(Config.farmConfigEndpoint);
  }

  Future<Map<String, dynamic>> updateFarmConfig(
    Map<String, dynamic> config,
  ) async {
    return await _put(Config.farmConfigEndpoint, config);
  }

  Future<Map<String, dynamic>> fetchProfile() async {
    return await _get(Config.profileEndpoint);
  }

  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> profile,
  ) async {
    return await _put(Config.profileEndpoint, profile);
  }

  // --------------------------
  // ✅ AUTH STATUS
  // --------------------------

  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  void dispose() => _client.close();
}
