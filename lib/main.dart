import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // <-- Add this import
import 'screens/imei_checker_screen.dart';
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
import 'screens/customs_calculation_screen.dart';
import 'screens/support.dart';
import 'screens/media_screen.dart';
import 'screens/payments_screen.dart';
import 'screens/payment_method.dart';
import 'screens/declaration_screen.dart';
import 'screens/unauthorized_access_screen.dart';
import 'screens/subscription_page.dart';
import 'screens/logistics_booking_screen.dart';
import 'screens/appeal_screen.dart';
import 'providers/locale_provider.dart';

// Theme management
import 'theme/theme_provider.dart';
import 'theme/theme.dart';

import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print('Environment variables loaded successfully');
    print('API URL: ${dotenv.env['API_URL']}');
  } catch (e) {
    print('Error loading .env file: $e');
    // Set default fallback values
    dotenv.env['API_URL'] = 'http://localhost:5000';
  }

  // Configure window for Linux and Windows desktop
  if (Platform.isLinux) {
    _configureLinuxWindow();
  } else if (Platform.isWindows) {
    _configureWindowsWindow();
  }

  runApp(
    ScreenUtilInit(
      designSize: const Size(
        414,
        896,
      ), // Using iPhone 14 Pro dimensions as base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ],
          child: const GlobalClearApp(),
        );
      },
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

void _configureWindowsWindow() {
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
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Customs Clearance',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      locale: localeProvider.locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        AppLocalizations.delegate, // <-- Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/welcome',
      routes: _appRoutes(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
      '/imei-checker': (context) => const IMEICheckerScreen(),
      '/customs-fee': (context) {
        return Builder(
          builder: (context) {
            final userProvider = Provider.of<UserProvider>(context);
            if (userProvider.user == null) {
              return const UnauthorizedAccessScreen();
            }
            return const CustomsCalculatorScreen();
          },
        );
      },
      '/support': (context) => const SupportScreen(),
      '/media': (context) => const MediaScreen(),
      '/payments': (context) => const PaymentsScreen(),
      '/payment_method': (context) => PaymentMethodsScreen(),
      '/declaration': (context) => const DeclarationScreen(),
      '/subscription': (context) => const SubscriptionPage(),
      '/logistics-booking':
          (context) => const LogisticsBookingScreen(declarationId: ''),
      '/appeal': (context) => const AppealScreen(),
    };
  }
}
