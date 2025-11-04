class Config {
  // For Android Emulator
  static const String baseUrl = "http://10.0.2.2:8000";

  // For real device testing (replace with your PC IP)
  // static const String baseUrl = "http://192.168.x.x:8000";

  static const Duration apiTimeout = Duration(seconds: 15);

  // Authentication
  static const String loginEndpoint = "/login";
  static const String registerEndpoint = "/register";
  static const String verifyOtpEndpoint = "/verify-otp";

  // Dashboard & Data
  static const String weatherEndpoint = "/weather";
  static const String cropSuggestionsEndpoint = "/crop-suggestions";
  static const String currentCropsEndpoint = "/current-crops";
  static const String addCropEndpoint = "/add-crop";
  static const String removeCropEndpoint = "/remove-crop";
  static const String marketPricesEndpoint = "/market-prices";
  static const String irrigationStatusEndpoint = "/irrigation-status";
  static const String farmConfigEndpoint = "/farm-config";
  static const String profileEndpoint = "/profile";
}
