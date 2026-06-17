import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/data/models/user_model.dart';

enum AuthStatus { uninitialized, authenticated, unauthenticated, loading }

class CloudAuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;
  final User? firebaseUser;

  const CloudAuthState({
    this.status = AuthStatus.uninitialized,
    this.user,
    this.error,
    this.firebaseUser,
  });

  CloudAuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? error,
    User? firebaseUser,
  }) {
    return CloudAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      firebaseUser: firebaseUser ?? this.firebaseUser,
    );
  }
}

class CloudAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _currentUser;
  bool get isSignedIn => _currentUser != null;

  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();
      _currentUser = _auth.currentUser;
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _currentUser = _auth.currentUser;
      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      _currentUser = null;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return Exception('البريد الإلكتروني مستخدم مسبقاً');
      case 'invalid-email':
        return Exception('البريد الإلكتروني غير صحيح');
      case 'weak-password':
        return Exception('كلمة المرور ضعيفة جداً');
      case 'user-not-found':
        return Exception('المستخدم غير موجود');
      case 'wrong-password':
        return Exception('كلمة المرور غير صحيحة');
      case 'too-many-requests':
        return Exception('طلبات كثيرة جداً، حاول لاحقاً');
      default:
        return Exception('حدث خطأ في تسجيل الدخول');
    }
  }
}

final cloudAuthServiceProvider = Provider<CloudAuthService>((ref) {
  return CloudAuthService();
});

final cloudAuthStateProvider = StreamProvider<CloudAuthState>((ref) {
  final service = ref.watch(cloudAuthServiceProvider);
  return service.authStateChanges.map((firebaseUser) {
    if (firebaseUser == null) {
      return const CloudAuthState(status: AuthStatus.unauthenticated);
    }
    return CloudAuthState(
      status: AuthStatus.authenticated,
      firebaseUser: firebaseUser,
      user: UserModel(
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
        phone: firebaseUser.phoneNumber ?? '',
        password: '',
        id: 0,
        uid: firebaseUser.uid,
      ),
    );
  });
});
