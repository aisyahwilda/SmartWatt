import 'package:flutter/foundation.dart';

/// Logger utility untuk development
/// Semua log hanya muncul di debug mode, tidak di production
class Logger {
  /// Log informasi umum
  static void info(String message, [dynamic data]) {
    if (kDebugMode) {
      print('ℹ️ INFO: $message${data != null ? ' | Data: $data' : ''}');
    }
  }

  /// Log error dengan detail
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('❌ ERROR: $message');
      if (error != null) {
        print('   Details: $error');
      }
      if (stackTrace != null) {
        print('   Stack: $stackTrace');
      }
    }
  }

  /// Log warning
  static void warning(String message, [dynamic data]) {
    if (kDebugMode) {
      print('⚠️ WARNING: $message${data != null ? ' | Data: $data' : ''}');
    }
  }

  /// Log debug untuk development
  static void debug(String message, [dynamic data]) {
    if (kDebugMode) {
      print('🔍 DEBUG: $message${data != null ? ' | Data: $data' : ''}');
    }
  }

  /// Log success
  static void success(String message, [dynamic data]) {
    if (kDebugMode) {
      print('✅ SUCCESS: $message${data != null ? ' | Data: $data' : ''}');
    }
  }

  /// Log API request
  static void apiRequest(String method, String endpoint, [dynamic data]) {
    if (kDebugMode) {
      print(
        '🌐 API $method: $endpoint${data != null ? ' | Payload: $data' : ''}',
      );
    }
  }

  /// Log API response
  static void apiResponse(String endpoint, int statusCode, [dynamic data]) {
    if (kDebugMode) {
      print(
        '📡 API Response: $endpoint | Status: $statusCode${data != null ? ' | Data: $data' : ''}',
      );
    }
  }

  /// Log database operation
  static void database(String operation, String table, [dynamic data]) {
    if (kDebugMode) {
      print('💾 DB $operation: $table${data != null ? ' | Data: $data' : ''}');
    }
  }

  /// Log navigation
  static void navigation(String from, String to) {
    if (kDebugMode) {
      print('🧭 Navigation: $from → $to');
    }
  }

  /// Log user action
  static void userAction(String action, [dynamic data]) {
    if (kDebugMode) {
      print('👤 User Action: $action${data != null ? ' | Data: $data' : ''}');
    }
  }
}
