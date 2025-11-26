import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../tables.dart';
import '../app_database.dart';

part 'users_dao.g.dart';

@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  // hash password
  String _hash(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  // register pengguna
  Future<int> register(String email, String password) async {
    // mengecek apakah email sudah terdaftar
    final existing = await (select(
      users,
    )..where((u) => u.email.equals(email))).getSingleOrNull();

    if (existing != null) {
      throw Exception('Email sudah terdaftar');
    }

    return into(users).insert(
      UsersCompanion(email: Value(email), password: Value(_hash(password))),
    );
  }

  Future<User?> login(String email, String password) async {
    final hashed = _hash(password);

    final user =
        await (select(users)
              ..where((u) => u.email.equals(email))
              ..where((u) => u.password.equals(hashed)))
            .getSingleOrNull();

    return user;
  }

  // get user by id
  Future<User?> getUserById(int id) {
    return (select(users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }
}
