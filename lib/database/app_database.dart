import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
// No `foundation` import here; platform detection handled by conditional import
import 'package:crypto/crypto.dart';

// Use a conditional connection implementation so web builds don't compile
// native sqlite3 FFI bindings. `connection_io.dart` uses `NativeDatabase`,
// while `connection_web.dart` returns a `WebDatabase`.
import 'connection_io.dart'
    if (dart.library.html) 'connection_web.dart'
    as connection;

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Users, Devices, UsageHistory, MonthlyBudgets],
  daos: [UsersDao, DevicesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connection.openConnection());

  @override
  int get schemaVersion => 1;

  // Ambil budget bulanan terbaru untuk user
  Future<MonthlyBudget?> getLatestBudget(int userId) {
    return (select(monthlyBudgets)
          ..where((b) => b.userId.equals(userId))
          ..orderBy([
            (b) =>
                OrderingTerm(expression: b.createdAt, mode: OrderingMode.desc),
          ])
          ..limit(1))
        .getSingleOrNull();
  }
}

// Data access objects (DAOs)
@DriftAccessor(tables: [Users])
class UsersDao extends DatabaseAccessor<AppDatabase> with _$UsersDaoMixin {
  UsersDao(super.db);

  String _generateSalt([int length = 16]) {
    final rand = Random.secure();
    final bytes = List<int>.generate(length, (_) => rand.nextInt(256));
    return base64Url.encode(bytes);
  }

  String _hashWithSalt(String password, String salt) {
    final bytes = utf8.encode(salt + password);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes);
  }

  Future<int> register(String email, String password) async {
    // Check if email already exists
    final existing = await (select(
      db.users,
    )..where((u) => u.email.equals(email))).get();
    if (existing.isNotEmpty) {
      throw Exception(
        'Email sudah terdaftar. Silakan gunakan email lain atau login.',
      );
    }

    final salt = _generateSalt();
    final hashed = _hashWithSalt(password, salt);
    final passwordValue = salt + r'$' + hashed;

    return into(db.users).insert(
      UsersCompanion(email: Value(email), password: Value(passwordValue)),
    );
  }

  Future<User?> login(String email, String password) async {
    final users = await (select(
      db.users,
    )..where((u) => u.email.equals(email))).get();

    if (users.isEmpty) return null;

    final user = users.first;

    final parts = user.password.split(r'$');
    if (parts.length != 2) return null;
    final salt = parts[0];
    final hash = parts[1];
    final candidate = _hashWithSalt(password, salt);
    return candidate == hash ? user : null;
  }

  Future<User?> getUserByEmail(String email) async {
    final users = await (select(
      db.users,
    )..where((u) => u.email.equals(email))).get();
    return users.isEmpty ? null : users.first;
  }

  // get user by id (helper for session restore)
  Future<User?> getUserById(int id) {
    return (select(db.users)..where((u) => u.id.equals(id))).getSingleOrNull();
  }

  // watch user by id (for real-time updates)
  Stream<User?> watchUserById(int id) {
    return (select(
      db.users,
    )..where((u) => u.id.equals(id))).watchSingleOrNull();
  }

  // update user profile
  Future<void> updateUserProfile({
    required int userId,
    String? fullName,
    String? profilePhotePath,
    String? jenisHunian,
    int? jumlahPenghuni,
    int? dayaListrik,
    String? golonganTarif,
    double? tarifPerKwh,
  }) async {
    await (update(db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        fullName: fullName != null ? Value(fullName) : const Value.absent(),
        profilePhotePath: profilePhotePath != null
            ? Value(profilePhotePath)
            : const Value.absent(),
        jenisHunian: Value(jenisHunian),
        jumlahPenghuni: Value(jumlahPenghuni),
        dayaListrik: Value(dayaListrik),
        golonganTarif: Value(golonganTarif),
        tarifPerKwh: Value(tarifPerKwh),
      ),
    );
  }

  // update notifikasi enabled status
  Future<void> updateNotificationsEnabled(int userId, bool enabled) async {
    await (update(db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(notificationsEnabled: Value(enabled)),
    );
  }
}

@DriftAccessor(tables: [Devices, UsageHistory, MonthlyBudgets])
class DevicesDao extends DatabaseAccessor<AppDatabase> with _$DevicesDaoMixin {
  DevicesDao(super.db);

  Future<int> insertDevice({
    required int userId,
    required String name,
    required String category,
    required int watt,
    required double hoursPerDay,
  }) {
    return into(db.devices).insert(
      DevicesCompanion(
        userId: Value(userId),
        name: Value(name),
        category: Value(category),
        watt: Value(watt),
        hoursPerDay: Value(hoursPerDay),
      ),
    );
  }

  Future<List<Device>> getDevicesForUser(int userId) {
    return (select(db.devices)..where((d) => d.userId.equals(userId))).get();
  }

  Future<int> deleteDevice(int id) {
    return (delete(db.devices)..where((d) => d.id.equals(id))).go();
  }

  Future<int> updateDevice({
    required int id,
    required String name,
    required String category,
    required int watt,
    required double hoursPerDay,
  }) {
    return (update(db.devices)..where((d) => d.id.equals(id))).write(
      DevicesCompanion(
        name: Value(name),
        category: Value(category),
        watt: Value(watt),
        hoursPerDay: Value(hoursPerDay),
      ),
    );
  }

  double estimateMonthlyKWh({
    required int watt,
    required double hoursPerDay,
    int daysInMonth = 30,
  }) {
    return (watt * hoursPerDay * daysInMonth) / 1000.0;
  }

  double estimateMonthlyCost({
    required int watt,
    required double hoursPerDay,
    required double pricePerKWh,
    int daysInMonth = 30,
  }) {
    return estimateMonthlyKWh(
          watt: watt,
          hoursPerDay: hoursPerDay,
          daysInMonth: daysInMonth,
        ) *
        pricePerKWh;
  }
}

// The concrete `openConnection` implementation is provided by the
// conditional import above (either `connection_io.dart` or
// `connection_web.dart`).
