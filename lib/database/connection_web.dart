import 'package:drift/drift.dart';
import 'package:drift/web.dart';

// Reverted to WebDatabase for stability with current drift version (2.21.0).
// Wasm migration requires additional worker & sqlite wasm asset setup and newer drift.
// This keeps web functional albeit on deprecated API.
QueryExecutor openConnection() => WebDatabase('smartwatt_db');
