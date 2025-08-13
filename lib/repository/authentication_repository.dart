import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:sme_project_app/models/user.dart';

class AuthenticationRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final CacheClient _cache;

  static const userCacheKey = '__userCacheKey__';

  AuthenticationRepository(
      {firebase_auth.FirebaseAuth? firebaseAuth, CacheClient? cache})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _cache = cache ?? CacheClient();

  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  Future<User?> loginWithEmailPassword(
      {required String email, required String password}) async {
    return _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .asStream()
        .map((user) => user.user?.toUser)
        .single;
  }

  Future<User?> createUserWithEmailPassword(
      {required String email, required String password}) =>
      _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .asStream()
          .map((user) => user.user?.toUser)
          .single;

  // Método para fazer logout
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    _cache.write(key: userCacheKey, value: User.empty); // Limpa o cache do usuário
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}

class CacheClient {
  final Map<String, Object> _cache;

  CacheClient() : _cache = <String, Object>{};

  void write<T extends Object>({required String key, required T value}) {
    _cache[key] = value;
  }

  T? read<T extends Object>({required String key}) {
    final value = _cache[key];
    if (value is T) return value;
    return null;
  }
}
