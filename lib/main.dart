import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_size/window_size.dart';

// Screen imports
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/create_company_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/dashboard.dart';
import 'screens/tracking.dart';
import 'screens/documents.dart';
import 'screens/compliance.dart';
import 'screens/settings.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/profile_edit_screen.dart';

// Theme management
import 'theme/theme_provider.dart';
import 'theme/theme.dart';

import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables with error handling
  try {
    await dotenv.load(fileName: ".env");
    print('Environment variables loaded successfully');
    print('API URL: ${dotenv.env['API_URL']}');
  } catch (e) {
    print('Error loading .env file: $e');
    // Set default fallback values
    dotenv.env['API_URL'] = 'http://localhost:5000';
  }

  // Configure window for Linux desktop
  if (Platform.isLinux) {
    _configureLinuxWindow();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const GlobalClearApp(),
    ),
  );
}

void _configureLinuxWindow() {
  setWindowTitle('Customs Clearance App');
  setWindowFrame(
    const Rect.fromLTWH(
      0,
      0,
      414, // iPhone 14 Pro width
      896, // iPhone 14 Pro height
    ),
  );
  setWindowMinSize(const Size(360, 640));
  setWindowMaxSize(const Size(414, 896));
}

class GlobalClearApp extends StatelessWidget {
  const GlobalClearApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Customs Clearance',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/welcome',
      routes: _appRoutes(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0, // Disable system text scaling
          ),
          child: child!,
        );
      },
    );
  }

  Map<String, WidgetBuilder> _appRoutes() {
    return {
      '/welcome': (context) => const WelcomeScreen(),
      '/login': (context) => LoginScreen(),
      '/createCompany': (context) => const CreateCompanyScreen(),
      '/createAccount': (context) => const CreateAccountScreen(),
      '/dashboard': (context) => const DashboardScreen(),
      '/tracking': (context) => const ShipmentTrackingScreen(),
      '/documents': (context) => const DocumentManagementScreen(),
      '/compliance': (context) => const ComplianceGuideScreen(),
      '/settings': (context) => const SettingsScreen(),
      '/forgot-password': (context) => const ForgotPasswordScreen(),
    };
  }
}
