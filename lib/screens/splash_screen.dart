import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the Login Screen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define the yellowish color to match the dashboard theme
    const Color yellowishColor = Color(0xFFE3B505);

    return Scaffold(
      backgroundColor: yellowishColor, // Set the background color to yellowish
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.local_shipping,
              size: 100,
              color: Colors.white, // Keep the icon color white for contrast
            ),
            SizedBox(height: 20),
            Text(
              'SCCF App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Keep the text color white for contrast
              ),
            ),
          ],
        ),
      ),
    );
  }
}