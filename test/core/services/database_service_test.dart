import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sanad_app/core/services/database_service.dart';
import 'package:sanad_app/features/auth/data/models/user_model.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseService', () {
    late DatabaseService db;

    setUp(() {
      db = DatabaseService();
    });

    test('is singleton', () {
      final instance1 = DatabaseService();
      final instance2 = DatabaseService();
      expect(identical(instance1, instance2), isTrue);
    });

    test('database getter returns database', () async {
      final database = await db.database;
      expect(database, isNotNull);
    });

    test('insert, retrieve, login, and delete user lifecycle', () async {
      final email = 'lifecycle_test@example.com';
      final user = UserModel(
        name: 'Lifecycle User',
        email: email,
        phone: '1234567890',
        password: 'password123',
      );

      await db.insertUser(user);

      final retrieved = await db.getUserByEmail(email);
      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Lifecycle User');
      expect(retrieved.email, email);

      final loginSuccess = await db.login(email, 'password123');
      expect(loginSuccess, isNotNull);
      expect(loginSuccess!.email, email);

      final loginFail = await db.login(email, 'wrongpassword');
      expect(loginFail, isNull);

      await db.deleteUser(retrieved.id!);

      final deleted = await db.getUserByEmail(email);
      expect(deleted, isNull);
    });

    test('getUserByEmail returns null for non-existent email', () async {
      final user = await db.getUserByEmail('nonexistent@example.com');
      expect(user, isNull);
    });
  });
}
