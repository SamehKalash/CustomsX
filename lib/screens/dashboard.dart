import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/status_card.dart';
import './profile_screen.dart'; // Import Profile Screen
import './exchange_rate_screen.dart'; // Import Exchange Rate Screen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(), // Home Screen
    const ProfileScreen(), // Profile Screen
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    // Define the yellowish color for branding consistency
    const Color yellowishColor = Color(0xFFE3B505);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : yellowishColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(context, isDarkMode, yellowishColor),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Quick Actions', isDarkMode),
            const SizedBox(height: 10),
            _buildQuickActions(context, yellowishColor, isDarkMode),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Status Overview', isDarkMode),
            const SizedBox(height: 10),
            _buildStatusSection(context, isDarkMode),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Compliance Updates', isDarkMode),
            const SizedBox(height: 10),
            _buildComplianceUpdates(context, isDarkMode),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Exchange Rates', isDarkMode),
            const SizedBox(height: 10),
            _buildExchangeRateSection(context, isDarkMode),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floating Action Button Pressed')),
          );
        },
        backgroundColor: yellowishColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 75, // Adjusted height to avoid overflow
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
            selectedItemColor: yellowishColor,
            unselectedItemColor: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context, bool isDarkMode, Color yellowishColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : yellowishColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back,',
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? Colors.white70 : Colors.white,
            ),
          ),
          Text(
            'Sam!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: isDarkMode ? Colors.white : Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Last login: 2 hours ago',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.white70 : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, Color yellowishColor, bool isDarkMode) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.8,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        _buildActionButton(
          context,
          Icons.calculate,
          'Calculator',
          '/calculator',
          yellowishColor,
          isDarkMode,
        ),
        _buildActionButton(
          context,
          Icons.track_changes,
          'Tracking',
          '/tracking',
          Colors.green,
          isDarkMode,
        ),
        _buildActionButton(
          context,
          Icons.upload_file,
          'Upload',
          '/documents',
          Colors.orange,
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    String route,
    Color color,
    bool isDarkMode,
  ) {
    return Card(
      elevation: 4,
      color: isDarkMode ? Colors.grey[700] : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        StatusCard(
          icon: Icons.pending_actions,
          title: 'Pending Shipments',
          value: '3 Items',
          subText: '2 in Customs Review',
          alertLevel: 2,
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 10),
        StatusCard(
          icon: Icons.description,
          title: 'Recent Documents',
          value: '5 Files',
          subText: 'Last upload: 2h ago',
          alertLevel: 0,
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildComplianceUpdates(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        _buildUpdateItem(
          context,
          'Egypt Customs Regulations',
          'New tariff codes effective March 2024',
          Icons.gavel,
          isDarkMode,
        ),
        _buildUpdateItem(
          context,
          'Egypt Import Restrictions',
          'Updated restricted items list',
          Icons.block,
          isDarkMode,
        ),
        _buildUpdateItem(
          context,
          'Global Trade News',
          'Latest international trade agreements',
          Icons.public,
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildUpdateItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool isDarkMode,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      color: isDarkMode ? Colors.grey[700] : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        onTap: () => Navigator.pushNamed(context, '/compliance'),
      ),
    );
  }

  Widget _buildExchangeRateSection(BuildContext context, bool isDarkMode) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: isDarkMode ? Colors.grey[700] : Theme.of(context).cardColor,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFE3B505).withOpacity(0.2), // Yellowish background
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.currency_exchange, color: Color(0xFFE3B505)),
        ),
        title: Text(
          'Exchange Rates',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          'View current exchange rates',
          style: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ExchangeRateScreen(),
            ),
          );
        },
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: const Text('Notifications'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: const [
              ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Document Approved'),
                subtitle: Text('Invoice_123.pdf has been cleared'),
              ),
              ListTile(
                leading: Icon(Icons.warning, color: Colors.orange),
                title: Text('Customs Hold'),
                subtitle: Text('Shipment #456 requires additional docs'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Dismiss All'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}