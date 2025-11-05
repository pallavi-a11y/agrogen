import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_service.dart';

class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Language settings
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  // User data
  String userName = 'John Doe';
  String farmName = 'Green Valley Acres';
  String location = 'California';
  String? authToken;
  bool isLoggedIn = false;

  // Loading states
  bool isLoadingWeather = false;
  bool isLoadingCrops = false;
  bool isLoadingPrices = false;
  bool isLoadingIrrigation = false;

  // Data
  Map<String, dynamic>? weatherData;
  List<Map<String, dynamic>>? cropSuggestions;
  List<Map<String, dynamic>> _currentCrops = [];
  List<Map<String, dynamic>>? marketPrices;
  Map<String, dynamic>? irrigationStatus;
  Map<String, dynamic>? farmConfig;

  List<Map<String, dynamic>> get currentCrops => _currentCrops;

  // Error handling
  String? errorMessage;

  // Authentication methods
  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      authToken = response['token'];
      isLoggedIn = true;
      userName = response['user']['name'] ?? userName;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      await _apiService.register(name, email, password);
      // After registration, might need OTP verification
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await _apiService.verifyOtp(email, otp);
      authToken = response['token'];
      isLoggedIn = true;
      userName = response['user']['name'] ?? userName;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
    authToken = null;
    isLoggedIn = false;
    notifyListeners();
  }

  // Data fetching methods
  Future<void> fetchWeather() async {
    if (!isLoggedIn) return;

    isLoadingWeather = true;
    errorMessage = null;
    notifyListeners();

    try {
      weatherData = await _apiService.fetchWeather(
        farmConfig?['latitude'] ?? 37.7749,
        farmConfig?['longitude'] ?? -122.4194,
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingWeather = false;
      notifyListeners();
    }
  }

  Future<void> fetchCropSuggestions() async {
    if (!isLoggedIn) return;

    isLoadingCrops = true;
    errorMessage = null;
    notifyListeners();

    try {
      cropSuggestions = await _apiService.fetchCropSuggestions();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingCrops = false;
      notifyListeners();
    }
  }

  Future<void> fetchCropSuggestionsWithParams() async {
    if (!isLoggedIn || farmConfig == null) return;

    isLoadingCrops = true;
    errorMessage = null;
    notifyListeners();

    try {
      cropSuggestions = await _apiService.fetchCropSuggestionsWithParams(
        farmConfig!,
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingCrops = false;
      notifyListeners();
    }
  }

  Future<void> fetchCurrentCrops() async {
    if (!isLoggedIn) return;

    try {
      _currentCrops = await _apiService.fetchCurrentCrops();
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<bool> addCrop(Map<String, dynamic> cropData) async {
    if (!isLoggedIn) return false;

    try {
      await _apiService.addCrop(cropData);
      await fetchCurrentCrops(); // Refresh the list
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCropStatus(String cropId, String status) async {
    if (!isLoggedIn) return false;

    try {
      await _apiService.updateCropStatus(cropId, status);
      await fetchCurrentCrops(); // Refresh the list
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeCrop(String cropId) async {
    if (!isLoggedIn) return false;

    try {
      await _apiService.removeCrop(cropId);
      await fetchCurrentCrops(); // Refresh the list
      return true;
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchMarketPrices() async {
    if (!isLoggedIn) return;

    isLoadingPrices = true;
    errorMessage = null;
    notifyListeners();

    try {
      marketPrices = await _apiService.fetchMarketPrices();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingPrices = false;
      notifyListeners();
    }
  }

  Future<void> fetchIrrigationStatus() async {
    if (!isLoggedIn) return;

    isLoadingIrrigation = true;
    errorMessage = null;
    notifyListeners();

    try {
      irrigationStatus = await _apiService.fetchIrrigationStatus();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoadingIrrigation = false;
      notifyListeners();
    }
  }

  Future<void> fetchFarmConfig() async {
    if (!isLoggedIn) return;

    try {
      farmConfig = await _apiService.fetchFarmConfig();
      farmName = farmConfig?['name'] ?? farmName;
      location = farmConfig?['location'] ?? location;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateFarmConfig(Map<String, dynamic> config) async {
    if (!isLoggedIn) return;

    try {
      farmConfig = await _apiService.updateFarmConfig(config);
      farmName = farmConfig?['name'] ?? farmName;
      location = farmConfig?['location'] ?? location;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchProfile() async {
    if (!isLoggedIn) return;

    try {
      final profile = await _apiService.fetchProfile();
      userName = profile['name'] ?? userName;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profile) async {
    if (!isLoggedIn) return;

    try {
      final updatedProfile = await _apiService.updateProfile(profile);
      userName = updatedProfile['name'] ?? userName;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Language methods
  void setLocale(Locale locale) {
    _locale = locale;
    _saveLocaleToPrefs(locale);
    notifyListeners();
  }

  Future<void> _saveLocaleToPrefs(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  Future<void> loadLocaleFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? 'en';
    _locale = Locale(localeCode);
  }

  // Initialize app data
  Future<void> initializeApp() async {
    await loadLocaleFromPrefs();
    // Check if user is logged in
    // For now, assume not logged in, but in real app check stored token
    if (isLoggedIn) {
      await Future.wait([
        fetchWeather(),
        fetchCropSuggestions(),
        fetchCurrentCrops(),
        fetchMarketPrices(),
        fetchIrrigationStatus(),
        fetchFarmConfig(),
        fetchProfile(),
      ]);
    }
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
