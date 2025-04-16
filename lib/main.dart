import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/dashboard.dart';
import 'screens/tracking.dart';
import 'screens/documents.dart';
import 'screens/compliance.dart';
import 'screens/settings.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/create_account_screen.dart';
import 'screens/create_company_screen.dart';
import 'screens/chooselang.dart';
import 'theme/theme_provider.dart';
import 'theme/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      title: 'SCCF',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: '/chooseLang',
      routes: {
        '/chooseLang': (context) => LanguageSelector(),
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/createCompany': (context) => const CreateCompanyScreen(),
        '/createAccount': (context) => const CreateAccountScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/tracking': (context) => const ShipmentTrackingScreen(),
        '/documents': (context) => const DocumentManagementScreen(),
        '/compliance': (context) => const ComplianceGuideScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
      onUnknownRoute:
          (settings) => MaterialPageRoute(
            builder:
                (context) =>
                    const Scaffold(body: Center(child: Text('Page not found'))),
          ),
    );
  }
}