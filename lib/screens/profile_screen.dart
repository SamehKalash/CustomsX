import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import './dashboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 1; // Set to Profile as the default selected tab

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFE3B505), // Yellowish color
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : const Color(0xFFE3B505),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile_picture.png'), // Replace with your image
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Sameh',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '+00000000',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'sam@gmail.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Options Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, 'Account Options', isDarkMode),
                    const SizedBox(height: 10),
                    _buildOption(
                      context,
                      icon: Icons.person,
                      label: 'Profile details',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile details tapped')),
                        );
                      },
                      isDarkMode: isDarkMode,
                    ),
                    const Divider(),
                    _buildOption(
                      context,
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: () {
                        Navigator.pushNamed(context, '/settings'); // Navigate to SettingsScreen
                      },
                      isDarkMode: isDarkMode,
                    ),
                    const Divider(),
                    _buildOption(
                      context,
                      icon: Icons.logout,
                      label: 'Log out',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logged out')),
                        );
                      },
                      isDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floating Action Button Pressed')),
          );
        },
        backgroundColor: const Color(0xFFE3B505), // Yellowish color
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardScreen()),
              );
            } else if (index == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: const Color(0xFFE3B505), // Yellowish color
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black54),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}