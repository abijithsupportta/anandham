import 'app_database.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider instance = DatabaseProvider._();

  AppDatabase? _database;

  AppDatabase get database {
    if (_database == null) {
      _database = AppDatabase();
      // ignore: avoid_print
      print('[DatabaseProvider] Created new AppDatabase instance');
    }
    return _database!;
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
