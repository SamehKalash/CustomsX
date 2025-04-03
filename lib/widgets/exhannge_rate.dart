import 'package:flutter/material.dart';

class ExchangeRateWidget extends StatelessWidget {
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
}