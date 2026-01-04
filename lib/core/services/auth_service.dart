import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth? _auth;
  User? _user;
  bool _isMockMode = false;

  User? get user => _user;
  bool get isAuthenticated => _user != null || (_isMockMode && _user != null);

  AuthService() {
    _init();
  }

  void _init() {
    try {
      if (Firebase.apps.isNotEmpty) {
        _auth = FirebaseAuth.instance;
        _auth?.authStateChanges().listen((User? user) {
          _user = user;
          notifyListeners();
        });
      } else {
        _isMockMode = true;
        debugPrint("AUTH: Firebase not initialized. Running in Offline/Mock mode.");
      }
    } catch (e) {
      _isMockMode = true;
      debugPrint("AUTH: Error initializing FirebaseAuth: $e");
    }
  }

  // Sign in with Email & Password
  Future<String?> signInWithEmail(String email, String password) async {
    if (_isMockMode) {
      _user = MockUser(email: email);
      notifyListeners();
      return null;
    }
    if (_auth == null) return "Firebase not initialized";
    try {
      await _auth!.signInWithEmailAndPassword(email: email, password: password);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unknown error occurred";
    }
  }

  // Sign up with Email & Password
  Future<String?> signUpWithEmail(String email, String password) async {
    if (_isMockMode) {
      _user = MockUser(email: email);
      notifyListeners();
      return null;
    }
    if (_auth == null) return "Firebase not initialized";
    try {
      await _auth!.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unknown error occurred";
    }
  }

  // Guest Login (Anonymous)
  Future<String?> signInAnonymously() async {
     if (_isMockMode || _auth == null) {
       _user = MockUser(isAnonymous: true);
       notifyListeners();
       return null; 
     }
    try {
      await _auth!.signInAnonymously();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unknown error occurred";
    }
  }

  // Sign Out
  Future<void> signOut() async {
    if (_isMockMode) {
      _user = null;
      notifyListeners();
      return;
    }
    await _auth?.signOut();
    _user = null;
    notifyListeners();
  }

  // Password Reset
  Future<String?> resetPassword(String email) async {
    if (_isMockMode) return null;
    if (_auth == null) return "Firebase not initialized";
    try {
      await _auth!.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }
}

// Simple Mock User to satisfy basic checks
class MockUser implements User {
  final String? email;
  final bool isAnonymous;
  
  MockUser({this.email, this.isAnonymous = false});

  @override
  String get uid => "mock_uid_12345";

  @override
  String? get displayName => isAnonymous ? "Guest" : email?.split('@')[0];

  @override
  String? get photoURL => null;

  @override
  bool get emailVerified => true;
  
  @override
  List<UserInfo> get providerData => [];

  @override
  Future<void> delete() async {}

  @override
  Future<String> getIdToken([bool forceRefresh = false]) async => "mock_token";

  @override
  Future<IdTokenResult> getIdTokenResult([bool forceRefresh = false]) async => throw UnimplementedError();

  @override
  UserMetadata get metadata => throw UnimplementedError();

  @override
  String? get phoneNumber => null;

  @override
  Future<void> reload() async {}

  @override
  Future<void> sendEmailVerification([ActionCodeSettings? actionCodeSettings]) async {}

  @override
  String get tenantId => throw UnimplementedError();

  @override
  Future<User> unlink(String providerId) async {
    return this;
  }

  @override
  Future<void> updateDisplayName(String? displayName) async {}

  @override
  Future<void> updateEmail(String newEmail) async {}

  @override
  Future<void> updatePassword(String newPassword) async {}

  @override
  Future<void> updatePhoneNumber(PhoneAuthCredential credential) async {}

  @override
  Future<void> updatePhotoURL(String? photoURL) async {}

  @override
  Future<void> verifyBeforeUpdateEmail(String newEmail, [ActionCodeSettings? actionCodeSettings]) async {}
  
  // Implement other necessary overrides with dummies if needed by app logic
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
