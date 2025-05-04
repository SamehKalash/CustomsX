import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavigationBar({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex, // Highlight active tab
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.support_agent),
          label: 'Support',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/dashboard');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/settings'); // Assuming profile is in settings
            break;
          case 2:
            Navigator.pushNamed(context, '/support');
            break;
        }
      },
      selectedItemColor: Colors.amber[800], // Custom active color
      unselectedItemColor: Colors.grey, // Custom inactive color
      showUnselectedLabels: true, // Always show labels
      type: BottomNavigationBarType.fixed, // For more than 3 items
    );
  }
}