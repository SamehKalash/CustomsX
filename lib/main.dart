import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard.dart';
import 'screens/tracking.dart';
import 'screens/documents.dart';
import 'theme/theme_provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const GlobalClearApp(),
  ),
);

class GlobalClearApp extends StatelessWidget {
  const GlobalClearApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'SCCF',
      theme: ThemeData.light().copyWith(
        primaryColor: const Color.fromARGB(255, 211, 174, 9),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color.fromARGB(255, 212, 173, 0),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 211, 174, 9),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color.fromARGB(255, 212, 162, 0),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      themeMode: themeProvider.themeMode,
      routes: {
        '/': (context) => const DashboardScreen(),
        '/tracking': (context) => const ShipmentTrackingScreen(),
        '/documents': (context) => const DocumentManagementScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
