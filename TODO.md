# TODO List for AgriGen Flutter App Development

## 1. Update pubspec.yaml ✅
- Add provider dependency for state management.
- Ensure Flutter version is compatible (3.22+).

## 2. Create theme.dart ✅
- Define color palette: warm browns, soft beige, light cream, natural greens.
- Set typography: Poppins or Nunito.
- Define corner radius, elevation, padding constants.

## 3. Create Screen Files ✅
- splash_screen.dart: Implement SplashScreen with gradient background, icon, title, progress bar, auto-navigate after 3s.
- auth_choice_screen.dart: Implement AuthChoiceScreen with logo, banner, Login/Register buttons.
- login_page.dart: Implement LoginPage with email/phone, password fields, forgot password link, login button.
- register_page.dart: Implement RegisterPage with toggle for phone/email, fields, register button.
- otp_screen.dart: Implement OTPScreen with 6 OTP inputs, verify button, resend timer.
- home_page.dart: Implement HomePage with greeting, weather card, farm section, quick links, bottom navigation.
- crop_suggestion_screen.dart: Implement CropSuggestionScreen with info card, tabs, crop cards, FAB.
- farm_configuration_screen.dart: Implement FarmConfigurationScreen with map preview, toggles, fields, save button.

## 4. Update main.dart ✅
- Import theme and screens.
- Set up MaterialApp with custom theme.
- Define named routes for all screens.
- Set initial route to SplashScreen.

## 5. Implement Navigation Logic ✅
- Add onPressed handlers for buttons to navigate using Navigator.pushNamed.
- Handle back navigation where needed (e.g., OTP to Register).
- Implement bottom navigation in HomePage with tabs: Dashboard, My Crops, History, Help (placeholders).

## 6. Add Dummy Data and State ✅
- Use Provider for simple state (e.g., user name, farm details).
- Add static dummy data for weather, crops, etc.

## 7. Test and Refine ✅
- Run the app to check UI and navigation.
- Ensure responsiveness for mobile/tablet.
- Fix any layout issues.

## 8. Finalize ✅
- Review all screens match the design language.
- Ensure all buttons have placeholder onPressed.

## 9. Add Bottom Navigation Bar ✅
- Create lib/screens/profile_screen.dart with basic profile information.
- Update lib/main.dart to add '/profile' route.
- Modify lib/screens/home_page.dart to include BottomNavigationBar with Profile, Dashboard, Crop Details using IndexedStack.
- Format all Dart files in the project using dart format.
