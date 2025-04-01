import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/status_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), actions: [
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(context, isDarkMode),
            _buildQuickActions(context),
            _buildStatusSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? const Color.fromARGB(255, 211, 174, 9)
                : Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        // Corrected: Added 'child' parameter here
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back,',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
          Text(
            'Sam!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Last login: 2 hours ago',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
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
            Colors.blueAccent,
          ),
          _buildActionButton(
            context,
            Icons.track_changes,
            'Tracking',
            '/tracking',
            Colors.green,
          ),
          _buildActionButton(
            context,
            Icons.upload_file,
            'Upload',
            '/documents',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    String route,
    Color color,
  ) {
    return Card(
      elevation: 2,
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const StatusCard(
            icon: Icons.pending_actions,
            title: 'Pending Shipments',
            value: '3 Items',
            subText: '2 in Customs Review',
            alertLevel: 2,
          ),
          const SizedBox(height: 10),
          const StatusCard(
            icon: Icons.description,
            title: 'Recent Documents',
            value: '5 Files',
            subText: 'Last upload: 2h ago',
            alertLevel: 0,
          ),
        ],
      ),
    );
  }
}
