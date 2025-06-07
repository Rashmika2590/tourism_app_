part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthAppStarted extends AuthEvent {}
class AuthGoogleSignInRequested extends AuthEvent {}
class AuthEmailPasswordSignInRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthEmailPasswordSignInRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}
class AuthEmailPasswordSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName; // Optional: if you collect it at sign up
  const AuthEmailPasswordSignUpRequested({required this.email, required this.password, this.displayName = ''});
  @override
  List<Object> get props => [email, password, displayName];
}
class AuthAnonymousSignInRequested extends AuthEvent {}
class AuthSignOutRequested extends AuthEvent {}
