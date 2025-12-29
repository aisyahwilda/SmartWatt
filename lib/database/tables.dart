import 'package:drift/drift.dart';

// tabel pengguna
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().unique()();
  TextColumn get password => text()();
  TextColumn get fullName => text().nullable()();
  TextColumn get profilePhotePath => text().nullable()(); // Path ke foto profil
  TextColumn get jenisHunian => text().nullable()(); // Rumah, Apartemen, Kos
  IntColumn get jumlahPenghuni => integer().nullable()();
  IntColumn get dayaListrik => integer().nullable()(); // VA
  TextColumn get golonganTarif => text().nullable()(); // R1, R2, R3, dll
  RealColumn get tarifPerKwh => real().nullable()();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
}

// tabel perangkat
class Devices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  IntColumn get watt => integer()();
  RealColumn get hoursPerDay => real()();
  IntColumn get userId => integer().references(Users, #id)();
}

// tabel panggunaan energi
class UsageHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get deviceId => integer().references(Devices, #id)();
  DateTimeColumn get date => dateTime()();
  RealColumn get kWhUsed => real()();
}

// budget bulanan
class MonthlyBudgets extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get budget => integer()();
  DateTimeColumn get createdAt => dateTime()();
}
