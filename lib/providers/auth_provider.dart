import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartwatt_app/database/db_provider.dart';
import 'package:smartwatt_app/database/app_database.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _storage = const FlutterSecureStorage();
  }

  final _db = DbProvider.instance;
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
}
