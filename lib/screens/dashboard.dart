import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../widgets/status_card.dart';
import './settings.dart'; 
//import '../widgets/exhannge_rate.dart';

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
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
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
            _buildExchangeRateSection(context), // Add the exchange rate section here
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
        color: isDarkMode
            ? const Color.fromARGB(255, 211, 174, 9)
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
                  color: Colors.white70,
                ),
          ),
          Text(
            'Sam!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'Last login: 2 hours ago',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
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
  Widget _buildExchangeRateSection(BuildContext context) {
    final List<Map<String, String>> exchangeRates = [
      {'currency': 'USD', 'rate': '50.65', 'country': 'United States'},
      {'currency': 'GBP', 'rate': '65.51', 'country': 'United Kingdom'},
      {'currency': 'CAD', 'rate': '35.44', 'country': 'Canada'},
      {'currency': 'DKK', 'rate': '7.32', 'country': 'Denmark'},
      {'currency': 'NOK', 'rate': '4.81', 'country': 'Norway'},
      {'currency': 'SEK', 'rate': '5.05', 'country': 'Sweden'},
      {'currency': 'CHF', 'rate': '57.28', 'country': 'Switzerland'},
      {'currency': 'JPY', 'rate': '0.34', 'country': 'Japan'},
      {'currency': 'EUR', 'rate': '54.62', 'country': 'European Union'},
      {'currency': 'EGP', 'rate': '1.00', 'country': 'Egypt'},
    ];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exchange Rates',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: exchangeRates.length,
              itemBuilder: (context, index) {
                final rate = exchangeRates[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(rate['currency']!),
                  ),
                  title: Text(rate['country']!),
                  subtitle: Text('Rate: ${rate['rate']}'),
                );
              },
            ),
          ],
        ),
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
      elevation: 4,
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
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
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
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        onTap: () => Navigator.pushNamed(context, '/compliance'),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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