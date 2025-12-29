import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../database/app_database.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._db) {
    _storage = const FlutterSecureStorage();
  }

  final AppDatabase _db;
  late final FlutterSecureStorage _storage;

  bool _loading = false;
  bool get loading => _loading;

  // current user (from generated drift User class)
  User? _user;
  User? get user => _user;

  Future<void> restoreSession() async {
    _loading = true;
    notifyListeners();
    final idString = await _storage.read(key: 'userId');
    if (idString != null) {
      final id = int.tryParse(idString);
      if (id != null) {
        final u = await _db.usersDao.getUserById(id);
        _user = u;
      }
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> register(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final id = await _db.usersDao.register(email, password);
      await _storage.write(key: 'userId', value: id.toString());
      _user = await _db.usersDao.getUserById(id);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<User?> login(String email, String password) async {
    _loading = true;
    notifyListeners();
    try {
      final u = await _db.usersDao.login(email, password);
      if (u != null) {
        await _storage.write(key: 'userId', value: u.id.toString());
      }
      _user = u;
      _loading = false;
      notifyListeners();
      return u;
    } catch (e) {
      _loading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'userId');
    _user = null;
    notifyListeners();
  }

  // Update user data in memory and notify listeners
  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  // Refresh user data from database
  Future<void> refreshUser() async {
    if (_user != null) {
      final updated = await _db.usersDao.getUserById(_user!.id);
      if (updated != null) {
        _user = updated;
        notifyListeners();
      }
    }
  }
}
