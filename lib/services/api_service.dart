import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  // Get stored token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Store token
  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Remove token (logout)
  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Generic GET request
  Future<Map<String, dynamic>> _get(String endpoint) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await _client
        .get(Uri.parse('${Config.baseUrl}$endpoint'), headers: headers)
        .timeout(Config.apiTimeout);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  // Generic POST request
  Future<Map<String, dynamic>> _post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await _client
        .post(
          Uri.parse('${Config.baseUrl}$endpoint'),
          headers: headers,
          body: json.encode(data),
        )
        .timeout(Config.apiTimeout);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }

  // Generic PUT request
  Future<Map<String, dynamic>> _put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await _client
        .put(
          Uri.parse('${Config.baseUrl}$endpoint'),
          headers: headers,
          body: json.encode(data),
        )
        .timeout(Config.apiTimeout);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update data: ${response.statusCode}');
    }
  }

  // Authentication methods
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

  Future<void> logout() async {
    await _removeToken();
  }

  // Data fetching methods
  Future<Map<String, dynamic>> fetchWeather(
    double latitude,
    double longitude,
  ) async {
    return await _get('${Config.weatherEndpoint}?lat=$latitude&lon=$longitude');
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
    return await _delete('${Config.removeCropEndpoint}/$cropId');
  }

  // Generic DELETE request
  Future<Map<String, dynamic>> _delete(String endpoint) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    final response = await _client
        .delete(Uri.parse('${Config.baseUrl}$endpoint'), headers: headers)
        .timeout(Config.apiTimeout);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data: ${response.statusCode}');
    }
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

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  void dispose() {
    _client.close();
  }
}
