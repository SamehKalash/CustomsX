import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations);

  static const _localizedValues = {
    'en': {
      'settings': 'Settings',
      'appearance': 'Appearance',
      'darkMode': 'Dark Mode',
      'language': 'Language',
      'appLanguage': 'App Language',
      'account': 'Account',
      'security': 'Security',
      'paymentMethods': 'Payment Methods',
      'support': 'Support',
      'aboutUs': 'About Us',
      'termsOfService': 'Terms of Service',
      'selectLanguage': 'Select Language',
    },
    'ar': {
      'settings': 'الإعدادات',
      'appearance': 'المظهر',
      'darkMode': 'الوضع الداكن',
      'language': 'اللغة',
      'appLanguage': 'لغة التطبيق',
      'account': 'الحساب',
      'security': 'الأمان',
      'paymentMethods': 'طرق الدفع',
      'support': 'الدعم',
      'aboutUs': 'معلومات عنا',
      'termsOfService': 'شروط الخدمة',
      'selectLanguage': 'اختر اللغة',
    },
  };

  static var delegate;

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key]!;
  }

  String get settings => 'Settings';
  String get appearance => 'Appearance';
  String get darkMode => 'Dark Mode';
  String get language => 'Language';
  String get appLanguage => 'App Language';
  String get account => 'Account';
  String get security => 'Security';
  String get paymentMethods => 'Payment Methods';
  String get support => 'Support';
  String get aboutUs => 'About Us';
  String get termsOfService => 'Terms of Service';
  String get selectLanguage => 'Select Language';
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}