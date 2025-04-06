import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/dashboard.dart';
import 'screens/tracking.dart';
import 'screens/documents.dart';
import 'screens/compliance.dart';
import 'screens/settings.dart';
import 'theme/theme_provider.dart';
import 'theme/theme.dart'; // Import centralized theme definitions
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
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

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const GlobalClearApp(),
    ),
  );
}

class GlobalClearApp extends StatelessWidget {
  const GlobalClearApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'SCCF App',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode, // Use theme mode from ThemeProvider
      theme: lightTheme, // Centralized light theme
      darkTheme: darkTheme, // Centralized dark theme
      home: const SplashScreen(), // Start with the Splash Screen
      routes: {
        '/splash': (context) => const SplashScreen(), // Splash Screen route
        '/login': (context) => const LoginScreen(), // Login Screen route
        '/dashboard': (context) => const DashboardScreen(), // Dashboard route
        '/tracking': (context) => const ShipmentTrackingScreen(), // Tracking route
        '/documents': (context) => const DocumentManagementScreen(), // Documents route
        '/compliance': (context) => const ComplianceGuideScreen(), // Compliance route
        '/settings': (context) => const SettingsScreen(), // Settings route
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) =>
            const Scaffold(body: Center(child: Text('Page not found'))),
      ),
    );
  }
}
