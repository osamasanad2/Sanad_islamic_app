import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_service.dart';
import '../../features/auth/data/models/user_model.dart';

class AuthState {
  final bool isLoggedIn;
  final UserModel? user;
  final String? error;
  final bool isLoading;

  const AuthState({
    this.isLoggedIn = false,
    this.user,
    this.error,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    UserModel? user,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final db = DatabaseService();
      final existing = await db.getUserByEmail(email);
      if (existing != null) {
        state = state.copyWith(isLoading: false, error: 'البريد الإلكتروني مستخدم مسبقاً');
        return;
      }
      final user = UserModel(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      final id = await db.insertUser(user);
      state = state.copyWith(
        isLoggedIn: true,
        user: user.copyWith(id: id),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final db = DatabaseService();
      final user = await db.login(email, password);
      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'البريد الإلكتروني أو كلمة المرور غير صحيحة',
        );
        return;
      }
      state = state.copyWith(isLoggedIn: true, user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
