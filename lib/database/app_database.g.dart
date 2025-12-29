// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _passwordMeta =
      const VerificationMeta('password');
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
      'password', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameMeta =
      const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
      'full_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _profilePhotePathMeta =
      const VerificationMeta('profilePhotePath');
  @override
  late final GeneratedColumn<String> profilePhotePath = GeneratedColumn<String>(
      'profile_phote_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _jenisHunianMeta =
      const VerificationMeta('jenisHunian');
  @override
  late final GeneratedColumn<String> jenisHunian = GeneratedColumn<String>(
      'jenis_hunian', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _jumlahPenghuniMeta =
      const VerificationMeta('jumlahPenghuni');
  @override
  late final GeneratedColumn<int> jumlahPenghuni = GeneratedColumn<int>(
      'jumlah_penghuni', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _dayaListrikMeta =
      const VerificationMeta('dayaListrik');
  @override
  late final GeneratedColumn<int> dayaListrik = GeneratedColumn<int>(
      'daya_listrik', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _golonganTarifMeta =
      const VerificationMeta('golonganTarif');
  @override
  late final GeneratedColumn<String> golonganTarif = GeneratedColumn<String>(
      'golongan_tarif', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _tarifPerKwhMeta =
      const VerificationMeta('tarifPerKwh');
  @override
  late final GeneratedColumn<double> tarifPerKwh = GeneratedColumn<double>(
      'tarif_per_kwh', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
      'notifications_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("notifications_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        email,
        password,
        fullName,
        profilePhotePath,
        jenisHunian,
        jumlahPenghuni,
        dayaListrik,
        golonganTarif,
        tarifPerKwh,
        notificationsEnabled
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    }
    if (data.containsKey('profile_phote_path')) {
      context.handle(
          _profilePhotePathMeta,
          profilePhotePath.isAcceptableOrUnknown(
              data['profile_phote_path']!, _profilePhotePathMeta));
    }
    if (data.containsKey('jenis_hunian')) {
      context.handle(
          _jenisHunianMeta,
          jenisHunian.isAcceptableOrUnknown(
              data['jenis_hunian']!, _jenisHunianMeta));
    }
    if (data.containsKey('jumlah_penghuni')) {
      context.handle(
          _jumlahPenghuniMeta,
          jumlahPenghuni.isAcceptableOrUnknown(
              data['jumlah_penghuni']!, _jumlahPenghuniMeta));
    }
    if (data.containsKey('daya_listrik')) {
      context.handle(
          _dayaListrikMeta,
          dayaListrik.isAcceptableOrUnknown(
              data['daya_listrik']!, _dayaListrikMeta));
    }
    if (data.containsKey('golongan_tarif')) {
      context.handle(
          _golonganTarifMeta,
          golonganTarif.isAcceptableOrUnknown(
              data['golongan_tarif']!, _golonganTarifMeta));
    }
    if (data.containsKey('tarif_per_kwh')) {
      context.handle(
          _tarifPerKwhMeta,
          tarifPerKwh.isAcceptableOrUnknown(
              data['tarif_per_kwh']!, _tarifPerKwhMeta));
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
          _notificationsEnabledMeta,
          notificationsEnabled.isAcceptableOrUnknown(
              data['notifications_enabled']!, _notificationsEnabledMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email'])!,
      password: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}password'])!,
      fullName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name']),
      profilePhotePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}profile_phote_path']),
      jenisHunian: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}jenis_hunian']),
      jumlahPenghuni: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}jumlah_penghuni']),
      dayaListrik: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}daya_listrik']),
      golonganTarif: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}golongan_tarif']),
      tarifPerKwh: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tarif_per_kwh']),
      notificationsEnabled: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}notifications_enabled'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String email;
  final String password;
  final String? fullName;
  final String? profilePhotePath;
  final String? jenisHunian;
  final int? jumlahPenghuni;
  final int? dayaListrik;
  final String? golonganTarif;
  final double? tarifPerKwh;
  final bool notificationsEnabled;
  const User(
      {required this.id,
      required this.email,
      required this.password,
      this.fullName,
      this.profilePhotePath,
      this.jenisHunian,
      this.jumlahPenghuni,
      this.dayaListrik,
      this.golonganTarif,
      this.tarifPerKwh,
      required this.notificationsEnabled});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || fullName != null) {
      map['full_name'] = Variable<String>(fullName);
    }
    if (!nullToAbsent || profilePhotePath != null) {
      map['profile_phote_path'] = Variable<String>(profilePhotePath);
    }
    if (!nullToAbsent || jenisHunian != null) {
      map['jenis_hunian'] = Variable<String>(jenisHunian);
    }
    if (!nullToAbsent || jumlahPenghuni != null) {
      map['jumlah_penghuni'] = Variable<int>(jumlahPenghuni);
    }
    if (!nullToAbsent || dayaListrik != null) {
      map['daya_listrik'] = Variable<int>(dayaListrik);
    }
    if (!nullToAbsent || golonganTarif != null) {
      map['golongan_tarif'] = Variable<String>(golonganTarif);
    }
    if (!nullToAbsent || tarifPerKwh != null) {
      map['tarif_per_kwh'] = Variable<double>(tarifPerKwh);
    }
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      password: Value(password),
      fullName: fullName == null && nullToAbsent
          ? const Value.absent()
          : Value(fullName),
      profilePhotePath: profilePhotePath == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePhotePath),
      jenisHunian: jenisHunian == null && nullToAbsent
          ? const Value.absent()
          : Value(jenisHunian),
      jumlahPenghuni: jumlahPenghuni == null && nullToAbsent
          ? const Value.absent()
          : Value(jumlahPenghuni),
      dayaListrik: dayaListrik == null && nullToAbsent
          ? const Value.absent()
          : Value(dayaListrik),
      golonganTarif: golonganTarif == null && nullToAbsent
          ? const Value.absent()
          : Value(golonganTarif),
      tarifPerKwh: tarifPerKwh == null && nullToAbsent
          ? const Value.absent()
          : Value(tarifPerKwh),
      notificationsEnabled: Value(notificationsEnabled),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      profilePhotePath: serializer.fromJson<String?>(json['profilePhotePath']),
      jenisHunian: serializer.fromJson<String?>(json['jenisHunian']),
      jumlahPenghuni: serializer.fromJson<int?>(json['jumlahPenghuni']),
      dayaListrik: serializer.fromJson<int?>(json['dayaListrik']),
      golonganTarif: serializer.fromJson<String?>(json['golonganTarif']),
      tarifPerKwh: serializer.fromJson<double?>(json['tarifPerKwh']),
      notificationsEnabled:
          serializer.fromJson<bool>(json['notificationsEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'fullName': serializer.toJson<String?>(fullName),
      'profilePhotePath': serializer.toJson<String?>(profilePhotePath),
      'jenisHunian': serializer.toJson<String?>(jenisHunian),
      'jumlahPenghuni': serializer.toJson<int?>(jumlahPenghuni),
      'dayaListrik': serializer.toJson<int?>(dayaListrik),
      'golonganTarif': serializer.toJson<String?>(golonganTarif),
      'tarifPerKwh': serializer.toJson<double?>(tarifPerKwh),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
    };
  }

  User copyWith(
          {int? id,
          String? email,
          String? password,
          Value<String?> fullName = const Value.absent(),
          Value<String?> profilePhotePath = const Value.absent(),
          Value<String?> jenisHunian = const Value.absent(),
          Value<int?> jumlahPenghuni = const Value.absent(),
          Value<int?> dayaListrik = const Value.absent(),
          Value<String?> golonganTarif = const Value.absent(),
          Value<double?> tarifPerKwh = const Value.absent(),
          bool? notificationsEnabled}) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        fullName: fullName.present ? fullName.value : this.fullName,
        profilePhotePath: profilePhotePath.present
            ? profilePhotePath.value
            : this.profilePhotePath,
        jenisHunian: jenisHunian.present ? jenisHunian.value : this.jenisHunian,
        jumlahPenghuni:
            jumlahPenghuni.present ? jumlahPenghuni.value : this.jumlahPenghuni,
        dayaListrik: dayaListrik.present ? dayaListrik.value : this.dayaListrik,
        golonganTarif:
            golonganTarif.present ? golonganTarif.value : this.golonganTarif,
        tarifPerKwh: tarifPerKwh.present ? tarifPerKwh.value : this.tarifPerKwh,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      profilePhotePath: data.profilePhotePath.present
          ? data.profilePhotePath.value
          : this.profilePhotePath,
      jenisHunian:
          data.jenisHunian.present ? data.jenisHunian.value : this.jenisHunian,
      jumlahPenghuni: data.jumlahPenghuni.present
          ? data.jumlahPenghuni.value
          : this.jumlahPenghuni,
      dayaListrik:
          data.dayaListrik.present ? data.dayaListrik.value : this.dayaListrik,
      golonganTarif: data.golonganTarif.present
          ? data.golonganTarif.value
          : this.golonganTarif,
      tarifPerKwh:
          data.tarifPerKwh.present ? data.tarifPerKwh.value : this.tarifPerKwh,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('fullName: $fullName, ')
          ..write('profilePhotePath: $profilePhotePath, ')
          ..write('jenisHunian: $jenisHunian, ')
          ..write('jumlahPenghuni: $jumlahPenghuni, ')
          ..write('dayaListrik: $dayaListrik, ')
          ..write('golonganTarif: $golonganTarif, ')
          ..write('tarifPerKwh: $tarifPerKwh, ')
          ..write('notificationsEnabled: $notificationsEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      email,
      password,
      fullName,
      profilePhotePath,
      jenisHunian,
      jumlahPenghuni,
      dayaListrik,
      golonganTarif,
      tarifPerKwh,
      notificationsEnabled);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.password == this.password &&
          other.fullName == this.fullName &&
          other.profilePhotePath == this.profilePhotePath &&
          other.jenisHunian == this.jenisHunian &&
          other.jumlahPenghuni == this.jumlahPenghuni &&
          other.dayaListrik == this.dayaListrik &&
          other.golonganTarif == this.golonganTarif &&
          other.tarifPerKwh == this.tarifPerKwh &&
          other.notificationsEnabled == this.notificationsEnabled);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> email;
  final Value<String> password;
  final Value<String?> fullName;
  final Value<String?> profilePhotePath;
  final Value<String?> jenisHunian;
  final Value<int?> jumlahPenghuni;
  final Value<int?> dayaListrik;
  final Value<String?> golonganTarif;
  final Value<double?> tarifPerKwh;
  final Value<bool> notificationsEnabled;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.fullName = const Value.absent(),
    this.profilePhotePath = const Value.absent(),
    this.jenisHunian = const Value.absent(),
    this.jumlahPenghuni = const Value.absent(),
    this.dayaListrik = const Value.absent(),
    this.golonganTarif = const Value.absent(),
    this.tarifPerKwh = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required String password,
    this.fullName = const Value.absent(),
    this.profilePhotePath = const Value.absent(),
    this.jenisHunian = const Value.absent(),
    this.jumlahPenghuni = const Value.absent(),
    this.dayaListrik = const Value.absent(),
    this.golonganTarif = const Value.absent(),
    this.tarifPerKwh = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
  })  : email = Value(email),
        password = Value(password);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? fullName,
    Expression<String>? profilePhotePath,
    Expression<String>? jenisHunian,
    Expression<int>? jumlahPenghuni,
    Expression<int>? dayaListrik,
    Expression<String>? golonganTarif,
    Expression<double>? tarifPerKwh,
    Expression<bool>? notificationsEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (fullName != null) 'full_name': fullName,
      if (profilePhotePath != null) 'profile_phote_path': profilePhotePath,
      if (jenisHunian != null) 'jenis_hunian': jenisHunian,
      if (jumlahPenghuni != null) 'jumlah_penghuni': jumlahPenghuni,
      if (dayaListrik != null) 'daya_listrik': dayaListrik,
      if (golonganTarif != null) 'golongan_tarif': golonganTarif,
      if (tarifPerKwh != null) 'tarif_per_kwh': tarifPerKwh,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
    });
  }

  UsersCompanion copyWith(
      {Value<int>? id,
      Value<String>? email,
      Value<String>? password,
      Value<String?>? fullName,
      Value<String?>? profilePhotePath,
      Value<String?>? jenisHunian,
      Value<int?>? jumlahPenghuni,
      Value<int?>? dayaListrik,
      Value<String?>? golonganTarif,
      Value<double?>? tarifPerKwh,
      Value<bool>? notificationsEnabled}) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      profilePhotePath: profilePhotePath ?? this.profilePhotePath,
      jenisHunian: jenisHunian ?? this.jenisHunian,
      jumlahPenghuni: jumlahPenghuni ?? this.jumlahPenghuni,
      dayaListrik: dayaListrik ?? this.dayaListrik,
      golonganTarif: golonganTarif ?? this.golonganTarif,
      tarifPerKwh: tarifPerKwh ?? this.tarifPerKwh,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (profilePhotePath.present) {
      map['profile_phote_path'] = Variable<String>(profilePhotePath.value);
    }
    if (jenisHunian.present) {
      map['jenis_hunian'] = Variable<String>(jenisHunian.value);
    }
    if (jumlahPenghuni.present) {
      map['jumlah_penghuni'] = Variable<int>(jumlahPenghuni.value);
    }
    if (dayaListrik.present) {
      map['daya_listrik'] = Variable<int>(dayaListrik.value);
    }
    if (golonganTarif.present) {
      map['golongan_tarif'] = Variable<String>(golonganTarif.value);
    }
    if (tarifPerKwh.present) {
      map['tarif_per_kwh'] = Variable<double>(tarifPerKwh.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('fullName: $fullName, ')
          ..write('profilePhotePath: $profilePhotePath, ')
          ..write('jenisHunian: $jenisHunian, ')
          ..write('jumlahPenghuni: $jumlahPenghuni, ')
          ..write('dayaListrik: $dayaListrik, ')
          ..write('golonganTarif: $golonganTarif, ')
          ..write('tarifPerKwh: $tarifPerKwh, ')
          ..write('notificationsEnabled: $notificationsEnabled')
          ..write(')'))
        .toString();
  }
}

class $DevicesTable extends Devices with TableInfo<$DevicesTable, Device> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _wattMeta = const VerificationMeta('watt');
  @override
  late final GeneratedColumn<int> watt = GeneratedColumn<int>(
      'watt', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hoursPerDayMeta =
      const VerificationMeta('hoursPerDay');
  @override
  late final GeneratedColumn<double> hoursPerDay = GeneratedColumn<double>(
      'hours_per_day', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, category, watt, hoursPerDay, userId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(Insertable<Device> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('watt')) {
      context.handle(
          _wattMeta, watt.isAcceptableOrUnknown(data['watt']!, _wattMeta));
    } else if (isInserting) {
      context.missing(_wattMeta);
    }
    if (data.containsKey('hours_per_day')) {
      context.handle(
          _hoursPerDayMeta,
          hoursPerDay.isAcceptableOrUnknown(
              data['hours_per_day']!, _hoursPerDayMeta));
    } else if (isInserting) {
      context.missing(_hoursPerDayMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Device map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Device(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      watt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}watt'])!,
      hoursPerDay: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}hours_per_day'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
    );
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }
}

class Device extends DataClass implements Insertable<Device> {
  final int id;
  final String name;
  final String category;
  final int watt;
  final double hoursPerDay;
  final int userId;
  const Device(
      {required this.id,
      required this.name,
      required this.category,
      required this.watt,
      required this.hoursPerDay,
      required this.userId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['watt'] = Variable<int>(watt);
    map['hours_per_day'] = Variable<double>(hoursPerDay);
    map['user_id'] = Variable<int>(userId);
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      watt: Value(watt),
      hoursPerDay: Value(hoursPerDay),
      userId: Value(userId),
    );
  }

  factory Device.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Device(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      watt: serializer.fromJson<int>(json['watt']),
      hoursPerDay: serializer.fromJson<double>(json['hoursPerDay']),
      userId: serializer.fromJson<int>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'watt': serializer.toJson<int>(watt),
      'hoursPerDay': serializer.toJson<double>(hoursPerDay),
      'userId': serializer.toJson<int>(userId),
    };
  }

  Device copyWith(
          {int? id,
          String? name,
          String? category,
          int? watt,
          double? hoursPerDay,
          int? userId}) =>
      Device(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        watt: watt ?? this.watt,
        hoursPerDay: hoursPerDay ?? this.hoursPerDay,
        userId: userId ?? this.userId,
      );
  Device copyWithCompanion(DevicesCompanion data) {
    return Device(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      watt: data.watt.present ? data.watt.value : this.watt,
      hoursPerDay:
          data.hoursPerDay.present ? data.hoursPerDay.value : this.hoursPerDay,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Device(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('watt: $watt, ')
          ..write('hoursPerDay: $hoursPerDay, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, category, watt, hoursPerDay, userId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.watt == this.watt &&
          other.hoursPerDay == this.hoursPerDay &&
          other.userId == this.userId);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int> watt;
  final Value<double> hoursPerDay;
  final Value<int> userId;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.watt = const Value.absent(),
    this.hoursPerDay = const Value.absent(),
    this.userId = const Value.absent(),
  });
  DevicesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    required int watt,
    required double hoursPerDay,
    required int userId,
  })  : name = Value(name),
        category = Value(category),
        watt = Value(watt),
        hoursPerDay = Value(hoursPerDay),
        userId = Value(userId);
  static Insertable<Device> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? watt,
    Expression<double>? hoursPerDay,
    Expression<int>? userId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (watt != null) 'watt': watt,
      if (hoursPerDay != null) 'hours_per_day': hoursPerDay,
      if (userId != null) 'user_id': userId,
    });
  }

  DevicesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? category,
      Value<int>? watt,
      Value<double>? hoursPerDay,
      Value<int>? userId}) {
    return DevicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      watt: watt ?? this.watt,
      hoursPerDay: hoursPerDay ?? this.hoursPerDay,
      userId: userId ?? this.userId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (watt.present) {
      map['watt'] = Variable<int>(watt.value);
    }
    if (hoursPerDay.present) {
      map['hours_per_day'] = Variable<double>(hoursPerDay.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('watt: $watt, ')
          ..write('hoursPerDay: $hoursPerDay, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

class $UsageHistoryTable extends UsageHistory
    with TableInfo<$UsageHistoryTable, UsageHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<int> deviceId = GeneratedColumn<int>(
      'device_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES devices (id)'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _kWhUsedMeta =
      const VerificationMeta('kWhUsed');
  @override
  late final GeneratedColumn<double> kWhUsed = GeneratedColumn<double>(
      'k_wh_used', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, deviceId, date, kWhUsed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_history';
  @override
  VerificationContext validateIntegrity(Insertable<UsageHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('k_wh_used')) {
      context.handle(_kWhUsedMeta,
          kWhUsed.isAcceptableOrUnknown(data['k_wh_used']!, _kWhUsedMeta));
    } else if (isInserting) {
      context.missing(_kWhUsedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UsageHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}device_id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      kWhUsed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}k_wh_used'])!,
    );
  }

  @override
  $UsageHistoryTable createAlias(String alias) {
    return $UsageHistoryTable(attachedDatabase, alias);
  }
}

class UsageHistoryData extends DataClass
    implements Insertable<UsageHistoryData> {
  final int id;
  final int deviceId;
  final DateTime date;
  final double kWhUsed;
  const UsageHistoryData(
      {required this.id,
      required this.deviceId,
      required this.date,
      required this.kWhUsed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['device_id'] = Variable<int>(deviceId);
    map['date'] = Variable<DateTime>(date);
    map['k_wh_used'] = Variable<double>(kWhUsed);
    return map;
  }

  UsageHistoryCompanion toCompanion(bool nullToAbsent) {
    return UsageHistoryCompanion(
      id: Value(id),
      deviceId: Value(deviceId),
      date: Value(date),
      kWhUsed: Value(kWhUsed),
    );
  }

  factory UsageHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageHistoryData(
      id: serializer.fromJson<int>(json['id']),
      deviceId: serializer.fromJson<int>(json['deviceId']),
      date: serializer.fromJson<DateTime>(json['date']),
      kWhUsed: serializer.fromJson<double>(json['kWhUsed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'deviceId': serializer.toJson<int>(deviceId),
      'date': serializer.toJson<DateTime>(date),
      'kWhUsed': serializer.toJson<double>(kWhUsed),
    };
  }

  UsageHistoryData copyWith(
          {int? id, int? deviceId, DateTime? date, double? kWhUsed}) =>
      UsageHistoryData(
        id: id ?? this.id,
        deviceId: deviceId ?? this.deviceId,
        date: date ?? this.date,
        kWhUsed: kWhUsed ?? this.kWhUsed,
      );
  UsageHistoryData copyWithCompanion(UsageHistoryCompanion data) {
    return UsageHistoryData(
      id: data.id.present ? data.id.value : this.id,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      date: data.date.present ? data.date.value : this.date,
      kWhUsed: data.kWhUsed.present ? data.kWhUsed.value : this.kWhUsed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageHistoryData(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('date: $date, ')
          ..write('kWhUsed: $kWhUsed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deviceId, date, kWhUsed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageHistoryData &&
          other.id == this.id &&
          other.deviceId == this.deviceId &&
          other.date == this.date &&
          other.kWhUsed == this.kWhUsed);
}

class UsageHistoryCompanion extends UpdateCompanion<UsageHistoryData> {
  final Value<int> id;
  final Value<int> deviceId;
  final Value<DateTime> date;
  final Value<double> kWhUsed;
  const UsageHistoryCompanion({
    this.id = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.date = const Value.absent(),
    this.kWhUsed = const Value.absent(),
  });
  UsageHistoryCompanion.insert({
    this.id = const Value.absent(),
    required int deviceId,
    required DateTime date,
    required double kWhUsed,
  })  : deviceId = Value(deviceId),
        date = Value(date),
        kWhUsed = Value(kWhUsed);
  static Insertable<UsageHistoryData> custom({
    Expression<int>? id,
    Expression<int>? deviceId,
    Expression<DateTime>? date,
    Expression<double>? kWhUsed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceId != null) 'device_id': deviceId,
      if (date != null) 'date': date,
      if (kWhUsed != null) 'k_wh_used': kWhUsed,
    });
  }

  UsageHistoryCompanion copyWith(
      {Value<int>? id,
      Value<int>? deviceId,
      Value<DateTime>? date,
      Value<double>? kWhUsed}) {
    return UsageHistoryCompanion(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      date: date ?? this.date,
      kWhUsed: kWhUsed ?? this.kWhUsed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<int>(deviceId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (kWhUsed.present) {
      map['k_wh_used'] = Variable<double>(kWhUsed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageHistoryCompanion(')
          ..write('id: $id, ')
          ..write('deviceId: $deviceId, ')
          ..write('date: $date, ')
          ..write('kWhUsed: $kWhUsed')
          ..write(')'))
        .toString();
  }
}

class $MonthlyBudgetsTable extends MonthlyBudgets
    with TableInfo<$MonthlyBudgetsTable, MonthlyBudget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MonthlyBudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
      'user_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<int> budget = GeneratedColumn<int>(
      'budget', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, userId, budget, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'monthly_budgets';
  @override
  VerificationContext validateIntegrity(Insertable<MonthlyBudget> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('budget')) {
      context.handle(_budgetMeta,
          budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta));
    } else if (isInserting) {
      context.missing(_budgetMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MonthlyBudget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MonthlyBudget(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_id'])!,
      budget: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}budget'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $MonthlyBudgetsTable createAlias(String alias) {
    return $MonthlyBudgetsTable(attachedDatabase, alias);
  }
}

class MonthlyBudget extends DataClass implements Insertable<MonthlyBudget> {
  final int id;
  final int userId;
  final int budget;
  final DateTime createdAt;
  const MonthlyBudget(
      {required this.id,
      required this.userId,
      required this.budget,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['budget'] = Variable<int>(budget);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MonthlyBudgetsCompanion toCompanion(bool nullToAbsent) {
    return MonthlyBudgetsCompanion(
      id: Value(id),
      userId: Value(userId),
      budget: Value(budget),
      createdAt: Value(createdAt),
    );
  }

  factory MonthlyBudget.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MonthlyBudget(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      budget: serializer.fromJson<int>(json['budget']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'budget': serializer.toJson<int>(budget),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MonthlyBudget copyWith(
          {int? id, int? userId, int? budget, DateTime? createdAt}) =>
      MonthlyBudget(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        budget: budget ?? this.budget,
        createdAt: createdAt ?? this.createdAt,
      );
  MonthlyBudget copyWithCompanion(MonthlyBudgetsCompanion data) {
    return MonthlyBudget(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      budget: data.budget.present ? data.budget.value : this.budget,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyBudget(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('budget: $budget, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, budget, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MonthlyBudget &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.budget == this.budget &&
          other.createdAt == this.createdAt);
}

class MonthlyBudgetsCompanion extends UpdateCompanion<MonthlyBudget> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> budget;
  final Value<DateTime> createdAt;
  const MonthlyBudgetsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.budget = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MonthlyBudgetsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int budget,
    required DateTime createdAt,
  })  : userId = Value(userId),
        budget = Value(budget),
        createdAt = Value(createdAt);
  static Insertable<MonthlyBudget> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? budget,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (budget != null) 'budget': budget,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MonthlyBudgetsCompanion copyWith(
      {Value<int>? id,
      Value<int>? userId,
      Value<int>? budget,
      Value<DateTime>? createdAt}) {
    return MonthlyBudgetsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      budget: budget ?? this.budget,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (budget.present) {
      map['budget'] = Variable<int>(budget.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MonthlyBudgetsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('budget: $budget, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $DevicesTable devices = $DevicesTable(this);
  late final $UsageHistoryTable usageHistory = $UsageHistoryTable(this);
  late final $MonthlyBudgetsTable monthlyBudgets = $MonthlyBudgetsTable(this);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  late final DevicesDao devicesDao = DevicesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, devices, usageHistory, monthlyBudgets];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String email,
  required String password,
  Value<String?> fullName,
  Value<String?> profilePhotePath,
  Value<String?> jenisHunian,
  Value<int?> jumlahPenghuni,
  Value<int?> dayaListrik,
  Value<String?> golonganTarif,
  Value<double?> tarifPerKwh,
  Value<bool> notificationsEnabled,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> email,
  Value<String> password,
  Value<String?> fullName,
  Value<String?> profilePhotePath,
  Value<String?> jenisHunian,
  Value<int?> jumlahPenghuni,
  Value<int?> dayaListrik,
  Value<String?> golonganTarif,
  Value<double?> tarifPerKwh,
  Value<bool> notificationsEnabled,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DevicesTable, List<Device>> _devicesRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.devices,
          aliasName: $_aliasNameGenerator(db.users.id, db.devices.userId));

  $$DevicesTableProcessedTableManager get devicesRefs {
    final manager = $$DevicesTableTableManager($_db, $_db.devices)
        .filter((f) => f.userId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_devicesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MonthlyBudgetsTable, List<MonthlyBudget>>
      _monthlyBudgetsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.monthlyBudgets,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.monthlyBudgets.userId));

  $$MonthlyBudgetsTableProcessedTableManager get monthlyBudgetsRefs {
    final manager = $$MonthlyBudgetsTableTableManager($_db, $_db.monthlyBudgets)
        .filter((f) => f.userId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_monthlyBudgetsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profilePhotePath => $composableBuilder(
      column: $table.profilePhotePath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jenisHunian => $composableBuilder(
      column: $table.jenisHunian, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get jumlahPenghuni => $composableBuilder(
      column: $table.jumlahPenghuni,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayaListrik => $composableBuilder(
      column: $table.dayaListrik, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get golonganTarif => $composableBuilder(
      column: $table.golonganTarif, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tarifPerKwh => $composableBuilder(
      column: $table.tarifPerKwh, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnFilters(column));

  Expression<bool> devicesRefs(
      Expression<bool> Function($$DevicesTableFilterComposer f) f) {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.devices,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DevicesTableFilterComposer(
              $db: $db,
              $table: $db.devices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> monthlyBudgetsRefs(
      Expression<bool> Function($$MonthlyBudgetsTableFilterComposer f) f) {
    final $$MonthlyBudgetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monthlyBudgets,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MonthlyBudgetsTableFilterComposer(
              $db: $db,
              $table: $db.monthlyBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get password => $composableBuilder(
      column: $table.password, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullName => $composableBuilder(
      column: $table.fullName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profilePhotePath => $composableBuilder(
      column: $table.profilePhotePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jenisHunian => $composableBuilder(
      column: $table.jenisHunian, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get jumlahPenghuni => $composableBuilder(
      column: $table.jumlahPenghuni,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayaListrik => $composableBuilder(
      column: $table.dayaListrik, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get golonganTarif => $composableBuilder(
      column: $table.golonganTarif,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tarifPerKwh => $composableBuilder(
      column: $table.tarifPerKwh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled,
      builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get profilePhotePath => $composableBuilder(
      column: $table.profilePhotePath, builder: (column) => column);

  GeneratedColumn<String> get jenisHunian => $composableBuilder(
      column: $table.jenisHunian, builder: (column) => column);

  GeneratedColumn<int> get jumlahPenghuni => $composableBuilder(
      column: $table.jumlahPenghuni, builder: (column) => column);

  GeneratedColumn<int> get dayaListrik => $composableBuilder(
      column: $table.dayaListrik, builder: (column) => column);

  GeneratedColumn<String> get golonganTarif => $composableBuilder(
      column: $table.golonganTarif, builder: (column) => column);

  GeneratedColumn<double> get tarifPerKwh => $composableBuilder(
      column: $table.tarifPerKwh, builder: (column) => column);

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
      column: $table.notificationsEnabled, builder: (column) => column);

  Expression<T> devicesRefs<T extends Object>(
      Expression<T> Function($$DevicesTableAnnotationComposer a) f) {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.devices,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DevicesTableAnnotationComposer(
              $db: $db,
              $table: $db.devices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> monthlyBudgetsRefs<T extends Object>(
      Expression<T> Function($$MonthlyBudgetsTableAnnotationComposer a) f) {
    final $$MonthlyBudgetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.monthlyBudgets,
        getReferencedColumn: (t) => t.userId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MonthlyBudgetsTableAnnotationComposer(
              $db: $db,
              $table: $db.monthlyBudgets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool devicesRefs, bool monthlyBudgetsRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> email = const Value.absent(),
            Value<String> password = const Value.absent(),
            Value<String?> fullName = const Value.absent(),
            Value<String?> profilePhotePath = const Value.absent(),
            Value<String?> jenisHunian = const Value.absent(),
            Value<int?> jumlahPenghuni = const Value.absent(),
            Value<int?> dayaListrik = const Value.absent(),
            Value<String?> golonganTarif = const Value.absent(),
            Value<double?> tarifPerKwh = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            email: email,
            password: password,
            fullName: fullName,
            profilePhotePath: profilePhotePath,
            jenisHunian: jenisHunian,
            jumlahPenghuni: jumlahPenghuni,
            dayaListrik: dayaListrik,
            golonganTarif: golonganTarif,
            tarifPerKwh: tarifPerKwh,
            notificationsEnabled: notificationsEnabled,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String email,
            required String password,
            Value<String?> fullName = const Value.absent(),
            Value<String?> profilePhotePath = const Value.absent(),
            Value<String?> jenisHunian = const Value.absent(),
            Value<int?> jumlahPenghuni = const Value.absent(),
            Value<int?> dayaListrik = const Value.absent(),
            Value<String?> golonganTarif = const Value.absent(),
            Value<double?> tarifPerKwh = const Value.absent(),
            Value<bool> notificationsEnabled = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            email: email,
            password: password,
            fullName: fullName,
            profilePhotePath: profilePhotePath,
            jenisHunian: jenisHunian,
            jumlahPenghuni: jumlahPenghuni,
            dayaListrik: dayaListrik,
            golonganTarif: golonganTarif,
            tarifPerKwh: tarifPerKwh,
            notificationsEnabled: notificationsEnabled,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {devicesRefs = false, monthlyBudgetsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (devicesRefs) db.devices,
                if (monthlyBudgetsRefs) db.monthlyBudgets
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (devicesRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._devicesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0).devicesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items),
                  if (monthlyBudgetsRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._monthlyBudgetsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .monthlyBudgetsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.userId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, $$UsersTableReferences),
    User,
    PrefetchHooks Function({bool devicesRefs, bool monthlyBudgetsRefs})>;
typedef $$DevicesTableCreateCompanionBuilder = DevicesCompanion Function({
  Value<int> id,
  required String name,
  required String category,
  required int watt,
  required double hoursPerDay,
  required int userId,
});
typedef $$DevicesTableUpdateCompanionBuilder = DevicesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> category,
  Value<int> watt,
  Value<double> hoursPerDay,
  Value<int> userId,
});

final class $$DevicesTableReferences
    extends BaseReferences<_$AppDatabase, $DevicesTable, Device> {
  $$DevicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.devices.userId, db.users.id));

  $$UsersTableProcessedTableManager? get userId {
    if ($_item.userId == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id($_item.userId!));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$UsageHistoryTable, List<UsageHistoryData>>
      _usageHistoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.usageHistory,
          aliasName:
              $_aliasNameGenerator(db.devices.id, db.usageHistory.deviceId));

  $$UsageHistoryTableProcessedTableManager get usageHistoryRefs {
    final manager = $$UsageHistoryTableTableManager($_db, $_db.usageHistory)
        .filter((f) => f.deviceId.id($_item.id));

    final cache = $_typedResult.readTableOrNull(_usageHistoryRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DevicesTableFilterComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get watt => $composableBuilder(
      column: $table.watt, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get hoursPerDay => $composableBuilder(
      column: $table.hoursPerDay, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> usageHistoryRefs(
      Expression<bool> Function($$UsageHistoryTableFilterComposer f) f) {
    final $$UsageHistoryTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.usageHistory,
        getReferencedColumn: (t) => t.deviceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsageHistoryTableFilterComposer(
              $db: $db,
              $table: $db.usageHistory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get watt => $composableBuilder(
      column: $table.watt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get hoursPerDay => $composableBuilder(
      column: $table.hoursPerDay, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$DevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DevicesTable> {
  $$DevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get watt =>
      $composableBuilder(column: $table.watt, builder: (column) => column);

  GeneratedColumn<double> get hoursPerDay => $composableBuilder(
      column: $table.hoursPerDay, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> usageHistoryRefs<T extends Object>(
      Expression<T> Function($$UsageHistoryTableAnnotationComposer a) f) {
    final $$UsageHistoryTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.usageHistory,
        getReferencedColumn: (t) => t.deviceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsageHistoryTableAnnotationComposer(
              $db: $db,
              $table: $db.usageHistory,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DevicesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DevicesTable,
    Device,
    $$DevicesTableFilterComposer,
    $$DevicesTableOrderingComposer,
    $$DevicesTableAnnotationComposer,
    $$DevicesTableCreateCompanionBuilder,
    $$DevicesTableUpdateCompanionBuilder,
    (Device, $$DevicesTableReferences),
    Device,
    PrefetchHooks Function({bool userId, bool usageHistoryRefs})> {
  $$DevicesTableTableManager(_$AppDatabase db, $DevicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> watt = const Value.absent(),
            Value<double> hoursPerDay = const Value.absent(),
            Value<int> userId = const Value.absent(),
          }) =>
              DevicesCompanion(
            id: id,
            name: name,
            category: category,
            watt: watt,
            hoursPerDay: hoursPerDay,
            userId: userId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String category,
            required int watt,
            required double hoursPerDay,
            required int userId,
          }) =>
              DevicesCompanion.insert(
            id: id,
            name: name,
            category: category,
            watt: watt,
            hoursPerDay: hoursPerDay,
            userId: userId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$DevicesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({userId = false, usageHistoryRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (usageHistoryRefs) db.usageHistory],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable: $$DevicesTableReferences._userIdTable(db),
                    referencedColumn:
                        $$DevicesTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (usageHistoryRefs)
                    await $_getPrefetchedData(
                        currentTable: table,
                        referencedTable:
                            $$DevicesTableReferences._usageHistoryRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DevicesTableReferences(db, table, p0)
                                .usageHistoryRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.deviceId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DevicesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DevicesTable,
    Device,
    $$DevicesTableFilterComposer,
    $$DevicesTableOrderingComposer,
    $$DevicesTableAnnotationComposer,
    $$DevicesTableCreateCompanionBuilder,
    $$DevicesTableUpdateCompanionBuilder,
    (Device, $$DevicesTableReferences),
    Device,
    PrefetchHooks Function({bool userId, bool usageHistoryRefs})>;
typedef $$UsageHistoryTableCreateCompanionBuilder = UsageHistoryCompanion
    Function({
  Value<int> id,
  required int deviceId,
  required DateTime date,
  required double kWhUsed,
});
typedef $$UsageHistoryTableUpdateCompanionBuilder = UsageHistoryCompanion
    Function({
  Value<int> id,
  Value<int> deviceId,
  Value<DateTime> date,
  Value<double> kWhUsed,
});

final class $$UsageHistoryTableReferences extends BaseReferences<_$AppDatabase,
    $UsageHistoryTable, UsageHistoryData> {
  $$UsageHistoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DevicesTable _deviceIdTable(_$AppDatabase db) =>
      db.devices.createAlias(
          $_aliasNameGenerator(db.usageHistory.deviceId, db.devices.id));

  $$DevicesTableProcessedTableManager? get deviceId {
    if ($_item.deviceId == null) return null;
    final manager = $$DevicesTableTableManager($_db, $_db.devices)
        .filter((f) => f.id($_item.deviceId!));
    final item = $_typedResult.readTableOrNull(_deviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$UsageHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $UsageHistoryTable> {
  $$UsageHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get kWhUsed => $composableBuilder(
      column: $table.kWhUsed, builder: (column) => ColumnFilters(column));

  $$DevicesTableFilterComposer get deviceId {
    final $$DevicesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviceId,
        referencedTable: $db.devices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DevicesTableFilterComposer(
              $db: $db,
              $table: $db.devices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UsageHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageHistoryTable> {
  $$UsageHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get kWhUsed => $composableBuilder(
      column: $table.kWhUsed, builder: (column) => ColumnOrderings(column));

  $$DevicesTableOrderingComposer get deviceId {
    final $$DevicesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviceId,
        referencedTable: $db.devices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DevicesTableOrderingComposer(
              $db: $db,
              $table: $db.devices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UsageHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageHistoryTable> {
  $$UsageHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get kWhUsed =>
      $composableBuilder(column: $table.kWhUsed, builder: (column) => column);

  $$DevicesTableAnnotationComposer get deviceId {
    final $$DevicesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.deviceId,
        referencedTable: $db.devices,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DevicesTableAnnotationComposer(
              $db: $db,
              $table: $db.devices,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$UsageHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsageHistoryTable,
    UsageHistoryData,
    $$UsageHistoryTableFilterComposer,
    $$UsageHistoryTableOrderingComposer,
    $$UsageHistoryTableAnnotationComposer,
    $$UsageHistoryTableCreateCompanionBuilder,
    $$UsageHistoryTableUpdateCompanionBuilder,
    (UsageHistoryData, $$UsageHistoryTableReferences),
    UsageHistoryData,
    PrefetchHooks Function({bool deviceId})> {
  $$UsageHistoryTableTableManager(_$AppDatabase db, $UsageHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsageHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsageHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> deviceId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> kWhUsed = const Value.absent(),
          }) =>
              UsageHistoryCompanion(
            id: id,
            deviceId: deviceId,
            date: date,
            kWhUsed: kWhUsed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int deviceId,
            required DateTime date,
            required double kWhUsed,
          }) =>
              UsageHistoryCompanion.insert(
            id: id,
            deviceId: deviceId,
            date: date,
            kWhUsed: kWhUsed,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$UsageHistoryTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({deviceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (deviceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.deviceId,
                    referencedTable:
                        $$UsageHistoryTableReferences._deviceIdTable(db),
                    referencedColumn:
                        $$UsageHistoryTableReferences._deviceIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$UsageHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsageHistoryTable,
    UsageHistoryData,
    $$UsageHistoryTableFilterComposer,
    $$UsageHistoryTableOrderingComposer,
    $$UsageHistoryTableAnnotationComposer,
    $$UsageHistoryTableCreateCompanionBuilder,
    $$UsageHistoryTableUpdateCompanionBuilder,
    (UsageHistoryData, $$UsageHistoryTableReferences),
    UsageHistoryData,
    PrefetchHooks Function({bool deviceId})>;
typedef $$MonthlyBudgetsTableCreateCompanionBuilder = MonthlyBudgetsCompanion
    Function({
  Value<int> id,
  required int userId,
  required int budget,
  required DateTime createdAt,
});
typedef $$MonthlyBudgetsTableUpdateCompanionBuilder = MonthlyBudgetsCompanion
    Function({
  Value<int> id,
  Value<int> userId,
  Value<int> budget,
  Value<DateTime> createdAt,
});

final class $$MonthlyBudgetsTableReferences
    extends BaseReferences<_$AppDatabase, $MonthlyBudgetsTable, MonthlyBudget> {
  $$MonthlyBudgetsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.monthlyBudgets.userId, db.users.id));

  $$UsersTableProcessedTableManager? get userId {
    if ($_item.userId == null) return null;
    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id($_item.userId!));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MonthlyBudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $MonthlyBudgetsTable> {
  $$MonthlyBudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get budget => $composableBuilder(
      column: $table.budget, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MonthlyBudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $MonthlyBudgetsTable> {
  $$MonthlyBudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get budget => $composableBuilder(
      column: $table.budget, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MonthlyBudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MonthlyBudgetsTable> {
  $$MonthlyBudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get budget =>
      $composableBuilder(column: $table.budget, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.userId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MonthlyBudgetsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MonthlyBudgetsTable,
    MonthlyBudget,
    $$MonthlyBudgetsTableFilterComposer,
    $$MonthlyBudgetsTableOrderingComposer,
    $$MonthlyBudgetsTableAnnotationComposer,
    $$MonthlyBudgetsTableCreateCompanionBuilder,
    $$MonthlyBudgetsTableUpdateCompanionBuilder,
    (MonthlyBudget, $$MonthlyBudgetsTableReferences),
    MonthlyBudget,
    PrefetchHooks Function({bool userId})> {
  $$MonthlyBudgetsTableTableManager(
      _$AppDatabase db, $MonthlyBudgetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MonthlyBudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MonthlyBudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MonthlyBudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> userId = const Value.absent(),
            Value<int> budget = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              MonthlyBudgetsCompanion(
            id: id,
            userId: userId,
            budget: budget,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int userId,
            required int budget,
            required DateTime createdAt,
          }) =>
              MonthlyBudgetsCompanion.insert(
            id: id,
            userId: userId,
            budget: budget,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MonthlyBudgetsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (userId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.userId,
                    referencedTable:
                        $$MonthlyBudgetsTableReferences._userIdTable(db),
                    referencedColumn:
                        $$MonthlyBudgetsTableReferences._userIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MonthlyBudgetsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MonthlyBudgetsTable,
    MonthlyBudget,
    $$MonthlyBudgetsTableFilterComposer,
    $$MonthlyBudgetsTableOrderingComposer,
    $$MonthlyBudgetsTableAnnotationComposer,
    $$MonthlyBudgetsTableCreateCompanionBuilder,
    $$MonthlyBudgetsTableUpdateCompanionBuilder,
    (MonthlyBudget, $$MonthlyBudgetsTableReferences),
    MonthlyBudget,
    PrefetchHooks Function({bool userId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
  $$UsageHistoryTableTableManager get usageHistory =>
      $$UsageHistoryTableTableManager(_db, _db.usageHistory);
  $$MonthlyBudgetsTableTableManager get monthlyBudgets =>
      $$MonthlyBudgetsTableTableManager(_db, _db.monthlyBudgets);
}

mixin _$UsersDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
}
mixin _$DevicesDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $DevicesTable get devices => attachedDatabase.devices;
  $UsageHistoryTable get usageHistory => attachedDatabase.usageHistory;
  $MonthlyBudgetsTable get monthlyBudgets => attachedDatabase.monthlyBudgets;
}
