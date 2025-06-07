import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // New import
// TODO: Import your auth repository/service later

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  // TODO: Add AuthRepository dependency

  AuthBloc({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        super(const AuthState.unknown()) {
    on<AuthAppStarted>(_onAppStarted);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthEmailPasswordSignInRequested>(_onEmailPasswordSignInRequested);
    on<AuthEmailPasswordSignUpRequested>(_onEmailPasswordSignUpRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthAnonymousSignInRequested>(_onAnonymousSignInRequested);
    // Other event handlers will be added in subsequent subtasks
  }

  Future<void> _onAppStarted(AuthAppStarted event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    // Listen to auth state changes
    await emit.forEach<User?>(
      _firebaseAuth.authStateChanges(),
      onData: (user) {
        if (user != null) {
          return AuthState.authenticated(user: user);
        } else {
          return const AuthState.unauthenticated();
        }
      },
      onError: (error, stackTrace) => AuthState.error(errorMessage: error.toString()),
    ).catchError((e) {
       emit(AuthState.error(errorMessage: e.toString()));
    });
  }

  Future<void> _onSignOutRequested(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _firebaseAuth.signOut();
      // Note: The authStateChanges listener in _onAppStarted should automatically emit unauthenticated
    } catch (e) {
      emit(AuthState.error(errorMessage: e.toString()));
    }
  }

  Future<void> _onEmailPasswordSignInRequested(AuthEmailPasswordSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      // authStateChanges listener will emit AuthState.authenticated if successful
    } on FirebaseAuthException catch (e) {
      emit(AuthState.unauthenticated(message: e.message ?? 'Sign in failed.'));
    } catch (e) {
      emit(AuthState.error(errorMessage: e.toString()));
    }
  }

  Future<void> _onEmailPasswordSignUpRequested(AuthEmailPasswordSignUpRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      if (userCredential.user != null && event.displayName.isNotEmpty) {
        await userCredential.user!.updateDisplayName(event.displayName);
        // Re-fetch the user to get updated info if needed, or rely on authStateChanges
        // For simplicity, authStateChanges will handle the authenticated state with the new user.
      }
      // authStateChanges listener will emit AuthState.authenticated if successful
    } on FirebaseAuthException catch (e) {
      emit(AuthState.unauthenticated(message: e.message ?? 'Sign up failed.'));
    } catch (e) {
      emit(AuthState.error(errorMessage: e.toString()));
    }
  }

  // Placeholder for Google Sign-In
  // Future<void> _onGoogleSignInRequested(AuthGoogleSignInRequested event, Emitter<AuthState> emit) async {}
  // Placeholder for Email/Password Sign-In
  // Future<void> _onEmailPasswordSignInRequested(AuthEmailPasswordSignInRequested event, Emitter<AuthState> emit) async {}
  // Placeholder for Email/Password Sign-Up
  // Future<void> _onEmailPasswordSignUpRequested(AuthEmailPasswordSignUpRequested event, Emitter<AuthState> emit) async {}
  // Placeholder for Anonymous Sign-In
  // Future<void> _onAnonymousSignInRequested(AuthAnonymousSignInRequested event, Emitter<AuthState> emit) async {}

  Future<void> _onGoogleSignInRequested(AuthGoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        emit(const AuthState.unauthenticated(message: 'Google sign in cancelled.'));
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      // authStateChanges listener will emit AuthState.authenticated
    } on FirebaseAuthException catch (e) {
      emit(AuthState.unauthenticated(message: e.message ?? 'Google sign in failed.'));
    } catch (e) {
      print('Google Sign In Error: $e');
      emit(AuthState.error(errorMessage: 'Google sign in failed: ${e.toString()}'));
    }
  }

  Future<void> _onAnonymousSignInRequested(AuthAnonymousSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    try {
      await _firebaseAuth.signInAnonymously();
      // authStateChanges listener will emit AuthState.authenticated
    } on FirebaseAuthException catch (e) {
      emit(AuthState.unauthenticated(message: e.message ?? 'Anonymous sign in failed.'));
    } catch (e) {
      emit(AuthState.error(errorMessage: e.toString()));
    }
  }
}
