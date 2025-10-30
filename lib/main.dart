import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'app_state.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_choice_screen.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/otp_screen.dart';
import 'screens/home_page.dart';
import 'screens/crop_suggestion_screen.dart';
import 'screens/crop_details_screen.dart';
import 'screens/farm_configuration_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/market_prices_screen.dart';
import 'screens/irrigation_status_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.initializeApp();
  runApp(MyApp(appState: appState));
}

class MyApp extends StatelessWidget {
  final AppState appState;

  const MyApp({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appState,
      child: MaterialApp(
        title: 'AgroGen',
        theme: AppTheme.theme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/auth_choice': (context) => const AuthChoiceScreen(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/otp': (context) => const OTPScreen(),
          '/home': (context) => const HomeContent(),
          '/crop_suggestions': (context) => const CropSuggestionScreen(),
          '/crop_details': (context) => const CropDetailsScreen(),
          '/farm_config': (context) => const FarmConfigurationScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/market_prices': (context) => const MarketPricesScreen(),
          '/irrigation_status': (context) => const IrrigationStatusScreen(),
        },
      ),
    );
  }
}
