import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  DateTime? _lastLogin;

  Map<String, dynamic>? get user => _user;
  DateTime? get lastLogin => _lastLogin;

  void setUser(Map<String, dynamic> userData) {
    _user = userData;
    _lastLogin =
        userData['lastLogin'] != null
            ? DateTime.parse(userData['lastLogin']).toLocal()
            : null;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _lastLogin = null;
    notifyListeners();
  }

  void updateProfileType(String profileType) {
    if (_user != null) {
      _user!['profileType'] = profileType;
      notifyListeners();
    }
  }
}