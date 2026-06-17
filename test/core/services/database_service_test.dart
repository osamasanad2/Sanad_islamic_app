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

    test('insert and retrieve user', () async {
      final user = UserModel(
        name: 'test_user',
        email: 'test@example.com',
        phone: '1234567890',
        password: 'password123',
      );

      await db.insertUser(user);
      final retrieved = await db.getUserByEmail('test@example.com');
      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'test_user');
      expect(retrieved.email, 'test@example.com');

      await db.deleteUser(retrieved.id!);
    });

    test('login with correct credentials', () async {
      final user = await db.login('test@example.com', 'password123');
      expect(user, isNotNull);
      expect(user!.email, 'test@example.com');
    });

    test('login with wrong password returns null', () async {
      final user = await db.login('test@example.com', 'wrongpassword');
      expect(user, isNull);
    });

    test('getUserByEmail returns null for non-existent email', () async {
      final user = await db.getUserByEmail('nonexistent@example.com');
      expect(user, isNull);
    });
  });
}
