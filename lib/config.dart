class Config {
  // Backend API Configuration
  static const String baseUrl =
      'https://your-backend-api.com/api'; // Replace with your actual backend URL

  // API Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String logoutEndpoint = '/auth/logout';
  static const String weatherEndpoint = '/weather';
  static const String cropSuggestionsEndpoint = '/crops/suggestions';
  static const String marketPricesEndpoint = '/market/prices';
  static const String irrigationStatusEndpoint = '/irrigation/status';
  static const String farmConfigEndpoint = '/farm/config';
  static const String profileEndpoint = '/user/profile';
  static const String currentCropsEndpoint = '/crops/current';
  static const String addCropEndpoint = '/crops/add';
  static const String removeCropEndpoint = '/crops/remove';

  // Timeout configurations
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration locationTimeout = Duration(seconds: 10);

  // Retry configurations
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Google Maps API Key (replace with your actual key)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  // App Configuration
  static const String appName = 'AgroGen';
  static const String appVersion = '1.0.0';

  // Default values
  static const double defaultLatitude = 37.7749;
  static const double defaultLongitude = -122.4194;
  static const String defaultFarmName = 'Green Valley Acres';
}
