import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/status_card.dart';
import './settings.dart';
import '../widgets/exhannge_rate.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(context, isDarkMode),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Quick Actions'),
            const SizedBox(height: 10),
            _buildQuickActions(context),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Status Overview'),
            const SizedBox(height: 10),
            _buildStatusSection(context),
            const SizedBox(height: 20),
            _buildSectionTitle(context, 'Compliance Updates'),
            const SizedBox(height: 10),
            _buildComplianceUpdates(context),
            const SizedBox(height: 20),
            _buildExchangeRateSection(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/help'),
        child: const Icon(Icons.help),
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
                ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
                : Theme.of(context).primaryColor,
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
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.white,
            ),
          ),
          Text(
            'Sam!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Last login: 2 hours ago',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDarkMode ? Colors.white70 : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
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
      elevation: 4,
      color: Theme.of(context).cardColor, // Adapts to dark mode
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
    return Column(
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
    );
  }

  Widget _buildComplianceUpdates(BuildContext context) {
    return Column(
      children: [
        _buildUpdateItem(
          context,
          'Egypt Customs Regulations',
          'New tariff codes effective March 2024',
          Icons.gavel,
        ),
        _buildUpdateItem(
          context,
          'Egypt Import Restrictions',
          'Updated restricted items list',
          Icons.block,
        ),
        _buildUpdateItem(
          context,
          'Global Trade News',
          'Latest international trade agreements',
          Icons.public,
        ),
      ],
    );
  }

  Widget _buildUpdateItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      color: Theme.of(context).cardColor, // Adapts to light/dark mode
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
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        onTap: () => Navigator.pushNamed(context, '/compliance'),
      ),
    );
  }

  Widget _buildExchangeRateSection(BuildContext context) {
    return const ExchangeRateWidget();
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).cardColor, // Adapts to dark mode
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
