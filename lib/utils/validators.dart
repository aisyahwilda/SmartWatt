class Validators {
  /// Validasi format email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validasi password minimal 6 karakter
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  /// Validasi konfirmasi password harus sama
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != password) {
      return 'Password tidak sama';
    }
    return null;
  }

  /// Validasi budget minimal Rp 10.000
  static String? validateBudget(String? value) {
    if (value == null || value.isEmpty) {
      return 'Budget tidak boleh kosong';
    }
    final budget = int.tryParse(value);
    if (budget == null) {
      return 'Budget harus berupa angka';
    }
    if (budget < 10000) {
      return 'Budget minimal Rp 10.000';
    }
    if (budget > 100000000) {
      return 'Budget terlalu besar (max Rp 100.000.000)';
    }
    return null;
  }

  /// Validasi watt perangkat
  static String? validateDeviceWatt(String? value) {
    if (value == null || value.isEmpty) {
      return 'Watt tidak boleh kosong';
    }
    final watt = int.tryParse(value);
    if (watt == null) {
      return 'Watt harus berupa angka';
    }
    if (watt <= 0) {
      return 'Watt harus lebih dari 0';
    }
    if (watt > 10000) {
      return 'Watt terlalu besar (max 10.000W)';
    }
    return null;
  }

  /// Validasi jam penggunaan per hari
  static String? validateHoursPerDay(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jam penggunaan tidak boleh kosong';
    }
    final hours = int.tryParse(value);
    if (hours == null) {
      return 'Jam harus berupa angka';
    }
    if (hours <= 0) {
      return 'Jam harus lebih dari 0';
    }
    if (hours > 24) {
      return 'Jam tidak boleh lebih dari 24';
    }
    return null;
  }

  /// Validasi nama perangkat
  static String? validateDeviceName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama perangkat tidak boleh kosong';
    }
    if (value.length < 2) {
      return 'Nama perangkat minimal 2 karakter';
    }
    if (value.length > 50) {
      return 'Nama perangkat maksimal 50 karakter';
    }
    return null;
  }

  /// Validasi nama lengkap
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    if (value.length < 2) {
      return 'Nama minimal 2 karakter';
    }
    if (value.length > 100) {
      return 'Nama maksimal 100 karakter';
    }
    return null;
  }

  /// Validasi jumlah penghuni
  static String? validateJumlahPenghuni(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final jumlah = int.tryParse(value);
    if (jumlah == null) {
      return 'Jumlah penghuni harus berupa angka';
    }
    if (jumlah <= 0) {
      return 'Jumlah penghuni harus lebih dari 0';
    }
    if (jumlah > 50) {
      return 'Jumlah penghuni terlalu banyak';
    }
    return null;
  }

  /// Validasi daya listrik (VA)
  static String? validateDayaListrik(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final daya = int.tryParse(value);
    if (daya == null) {
      return 'Daya listrik harus berupa angka';
    }
    if (daya <= 0) {
      return 'Daya listrik harus lebih dari 0';
    }
    final validDaya = [450, 900, 1300, 2200, 3500, 4400, 5500, 6600, 7700];
    if (!validDaya.contains(daya)) {
      return 'Daya listrik tidak valid (contoh: 1300, 2200, 3500)';
    }
    return null;
  }

  /// Validasi tarif per kWh
  static String? validateTarifPerKwh(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }
    final tarif = double.tryParse(value);
    if (tarif == null) {
      return 'Tarif harus berupa angka';
    }
    if (tarif <= 0) {
      return 'Tarif harus lebih dari 0';
    }
    if (tarif > 10000) {
      return 'Tarif terlalu besar';
    }
    return null;
  }
}
