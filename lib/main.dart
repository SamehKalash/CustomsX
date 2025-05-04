import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:window_size/window_size.dart';

// Screens
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
import 'screens/support_screen.dart';
import 'screens/contact_us.dart';

// Theme
import 'theme/theme_provider.dart';
import 'theme/theme.dart';

// Providers
import 'providers/user_provider.dart'; // Add this import

// Navigation Bar
import 'screens/navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux) _configureLinuxWindow();
  await _initializeFirebase();

  runApp(
    MultiProvider(  // Changed from ChangeNotifierProvider to MultiProvider
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()), // Added UserProvider
      ],
      child: const GlobalClearApp(),
    ),
  );
}

void _configureLinuxWindow() {
  setWindowTitle('Customs Clearance App');
  setWindowFrame(const Rect.fromLTWH(0, 0, 414, 640));
  setWindowMinSize(const Size(360, 640));
  setWindowMaxSize(const Size(414, 896));
}

Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "YOUR_API_KEY",
        appId: "YOUR_APP_ID",
        messagingSenderId: "YOUR_SENDER_ID",
        projectId: "YOUR_PROJECT_ID",
        storageBucket: "YOUR_STORAGE_BUCKET",
      ),
    );
    debugPrint("Firebase initialized successfully");
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }
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
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) =>
            const Scaffold(body: Center(child: Text('Page not found'))),
      ),
    );
  }

  Map<String, WidgetBuilder> _appRoutes() {
    return {
      '/welcome': (context) => const WelcomeScreen(),
      '/login': (context) => LoginScreen(),
      '/createCompany': (context) => const CreateCompanyScreen(),
      '/createAccount': (context) => const CreateAccountScreen(),
      '/dashboard': (context) => Scaffold(
            body: const DashboardScreen(),
            bottomNavigationBar: CustomNavigationBar(),
          ),
      '/support': (context) => Scaffold(
            body: SupportScreen(),
            bottomNavigationBar: CustomNavigationBar(),
          ),
      '/contact_us': (context) => Scaffold(
            body: ContactUsScreen(),
            bottomNavigationBar: CustomNavigationBar(),
          ),
      '/tracking': (context) => const ShipmentTrackingScreen(),
      '/documents': (context) => const DocumentManagementScreen(),
      '/compliance': (context) => const ComplianceGuideScreen(),
      '/settings': (context) => const SettingsScreen(),
      '/forgot-password': (context) => const ForgotPasswordScreen(),
    };
  }
}
