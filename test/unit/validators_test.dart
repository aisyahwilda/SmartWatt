import 'package:flutter_test/flutter_test.dart';

// Validators class definition inline for testing
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email tidak boleh kosong';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Format email tidak valid';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  static String? validateBudget(String? value) {
    if (value == null || value.isEmpty) return 'Budget tidak boleh kosong';
    final budget = int.tryParse(value);
    if (budget == null || budget < 10000) return 'Budget minimal Rp 10.000';
    if (budget > 10000000) return 'Budget maksimal Rp 10.000.000';
    return null;
  }

  static String? validateDeviceWatt(String? value) {
    if (value == null || value.isEmpty) return 'Watt tidak boleh kosong';
    final watt = int.tryParse(value);
    if (watt == null || watt < 1 || watt > 10000)
      return 'Watt harus antara 1 dan 10.000';
    return null;
  }

  static String? validateHoursPerDay(String? value) {
    if (value == null || value.isEmpty)
      return 'Jam per hari tidak boleh kosong';
    final hours = double.tryParse(value);
    if (hours == null || hours < 0.1 || hours > 24.0)
      return 'Jam per hari harus antara 0.1 dan 24.0';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Nama tidak boleh kosong';
    if (value.length < 2) return 'Nama minimal 2 karakter';
    if (value.length > 50) return 'Nama maksimal 50 karakter';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value))
      return 'Nama hanya boleh mengandung huruf dan spasi';
    return null;
  }
}

void main() {
  group('Email Validation', () {
    test('Valid email should return null', () {
      expect(Validators.validateEmail('test@example.com'), null);
      expect(Validators.validateEmail('user.name@domain.co.id'), null);
      expect(Validators.validateEmail('test123@gmail.com'), null);
    });

    test('Empty email should return error', () {
      expect(Validators.validateEmail(''), isNotNull);
      expect(Validators.validateEmail(null), isNotNull);
    });

    test('Invalid email format should return error', () {
      expect(Validators.validateEmail('invalid'), isNotNull);
      expect(Validators.validateEmail('test@'), isNotNull);
      expect(Validators.validateEmail('@example.com'), isNotNull);
      expect(Validators.validateEmail('test @example.com'), isNotNull);
    });
  });

  group('Password Validation', () {
    test('Valid password should return null', () {
      expect(Validators.validatePassword('123456'), null);
      expect(Validators.validatePassword('password123'), null);
      expect(Validators.validatePassword('P@ssw0rd!'), null);
    });

    test('Empty password should return error', () {
      expect(Validators.validatePassword(''), isNotNull);
      expect(Validators.validatePassword(null), isNotNull);
    });

    test('Short password should return error', () {
      expect(Validators.validatePassword('12345'), isNotNull);
      expect(Validators.validatePassword('abc'), isNotNull);
    });
  });

  group('Budget Validation', () {
    test('Valid budget should return null', () {
      expect(Validators.validateBudget('10000'), null);
      expect(Validators.validateBudget('500000'), null);
      expect(Validators.validateBudget('10000000'), null);
    });

    test('Empty budget should return error', () {
      expect(Validators.validateBudget(''), isNotNull);
      expect(Validators.validateBudget(null), isNotNull);
    });

    test('Budget below minimum should return error', () {
      expect(Validators.validateBudget('9999'), isNotNull);
      expect(Validators.validateBudget('5000'), isNotNull);
    });

    test('Budget above maximum should return error', () {
      expect(Validators.validateBudget('10000001'), isNotNull);
      expect(Validators.validateBudget('99999999'), isNotNull);
    });

    test('Non-numeric budget should return error', () {
      expect(Validators.validateBudget('abc'), isNotNull);
      expect(Validators.validateBudget('10.5'), isNotNull);
    });
  });

  group('Device Watt Validation', () {
    test('Valid watt should return null', () {
      expect(Validators.validateDeviceWatt('100'), null);
      expect(Validators.validateDeviceWatt('1500'), null);
      expect(Validators.validateDeviceWatt('10000'), null);
    });

    test('Empty watt should return error', () {
      expect(Validators.validateDeviceWatt(''), isNotNull);
      expect(Validators.validateDeviceWatt(null), isNotNull);
    });

    test('Watt below minimum should return error', () {
      expect(Validators.validateDeviceWatt('0'), isNotNull);
      expect(Validators.validateDeviceWatt('-10'), isNotNull);
    });

    test('Watt above maximum should return error', () {
      expect(Validators.validateDeviceWatt('10001'), isNotNull);
      expect(Validators.validateDeviceWatt('50000'), isNotNull);
    });

    test('Non-numeric watt should return error', () {
      expect(Validators.validateDeviceWatt('abc'), isNotNull);
      expect(Validators.validateDeviceWatt('100.5'), isNotNull);
    });
  });

  group('Hours Per Day Validation', () {
    test('Valid hours should return null', () {
      expect(Validators.validateHoursPerDay('0.5'), null);
      expect(Validators.validateHoursPerDay('8'), null);
      expect(Validators.validateHoursPerDay('24'), null);
      expect(Validators.validateHoursPerDay('12.5'), null);
    });

    test('Empty hours should return error', () {
      expect(Validators.validateHoursPerDay(''), isNotNull);
      expect(Validators.validateHoursPerDay(null), isNotNull);
    });

    test('Hours below minimum should return error', () {
      expect(Validators.validateHoursPerDay('0'), isNotNull);
      expect(Validators.validateHoursPerDay('0.05'), isNotNull);
    });

    test('Hours above maximum should return error', () {
      expect(Validators.validateHoursPerDay('24.1'), isNotNull);
      expect(Validators.validateHoursPerDay('50'), isNotNull);
    });

    test('Non-numeric hours should return error', () {
      expect(Validators.validateHoursPerDay('abc'), isNotNull);
      expect(Validators.validateHoursPerDay('12,5'), isNotNull);
    });
  });

  group('Name Validation', () {
    test('Valid name should return null', () {
      expect(Validators.validateName('John Doe'), null);
      expect(Validators.validateName('Aisyah Manda'), null);
      expect(Validators.validateName('Muhammad Ali'), null);
    });

    test('Empty name should return error', () {
      expect(Validators.validateName(''), isNotNull);
      expect(Validators.validateName(null), isNotNull);
    });

    test('Short name should return error', () {
      expect(Validators.validateName('A'), isNotNull);
    });

    test('Long name should return error', () {
      expect(Validators.validateName('A' * 51), isNotNull);
    });

    test('Name with numbers should return error', () {
      expect(Validators.validateName('John123'), isNotNull);
      expect(Validators.validateName('User 123'), isNotNull);
    });

    test('Name with special characters should return error', () {
      expect(Validators.validateName('John@Doe'), isNotNull);
      expect(Validators.validateName('User_Name'), isNotNull);
      expect(Validators.validateName('User-Name'), isNotNull);
    });
  });
}
