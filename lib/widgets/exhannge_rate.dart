import 'package:flutter/material.dart';

class ExchangeRateWidget extends StatelessWidget {
  final List<Map<String, String>> exchangeRates = [
    {
      'currency': 'USD',
      'rate': '50.65',
      'country': 'United States',
      'symbol': '\$',
      'currencyName': 'US Dollar',
    },
    {
      'currency': 'GBP',
      'rate': '65.51',
      'country': 'United Kingdom',
      'symbol': '£',
      'currencyName': 'British Pound',
    },
    {
      'currency': 'CAD',
      'rate': '35.44',
      'country': 'Canada',
      'symbol': '\$',
      'currencyName': 'Canadian Dollar',
    },
    {
      'currency': 'DKK',
      'rate': '7.32',
      'country': 'Denmark',
      'symbol': 'kr',
      'currencyName': 'Danish Krone',
    },
    {
      'currency': 'NOK',
      'rate': '4.81',
      'country': 'Norway',
      'symbol': 'kr',
      'currencyName': 'Norwegian Krone',
    },
    {
      'currency': 'SEK',
      'rate': '5.05',
      'country': 'Sweden',
      'symbol': 'kr',
      'currencyName': 'Swedish Krona',
    },
    {
      'currency': 'CHF',
      'rate': '57.28',
      'country': 'Switzerland',
      'symbol': 'CHF',
      'currencyName': 'Swiss Franc',
    },
    {
      'currency': 'JPY',
      'rate': '0.34',
      'country': 'Japan',
      'symbol': '¥',
      'currencyName': 'Japanese Yen',
    },
    {
      'currency': 'EUR',
      'rate': '54.62',
      'country': 'European Union',
      'symbol': '€',
      'currencyName': 'Euro',
    },
    {
      'currency': 'EGP',
      'rate': '1.00',
      'country': 'Egypt',
      'symbol': 'E£',
      'currencyName': 'Egyptian Pound',
    },
  ];

  ExchangeRateWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                    child: Text(
                      rate['currency']!,
                      style: const TextStyle(
                        fontSize: 12,
                      ), // Adjust font size for better fit
                    ),
                  ),
                  title: Text(
                    rate['country']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ), // Make country name bold
                  ),
                  subtitle: Text(
                    '${rate['currencyName']} - Rate: ${rate['symbol']}${rate['rate']}', // Combine currency name and rate
                    style: const TextStyle(
                      color: Colors.grey,
                    ), // Add styling for visibility
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
