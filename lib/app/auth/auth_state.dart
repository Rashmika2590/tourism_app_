part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user; // Firebase User
  final String? errorMessage;

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
  });

  const AuthState.unknown() : this._();
  const AuthState.loading() : this._(status: AuthStatus.loading);
  const AuthState.authenticated({required User user}) : this._(status: AuthStatus.authenticated, user: user);
  const AuthState.unauthenticated({String? message}) : this._(status: AuthStatus.unauthenticated, errorMessage: message);
  const AuthState.error({required String errorMessage}) : this._(status: AuthStatus.error, errorMessage: errorMessage);

  @override
  List<Object?> get props => [status, user, errorMessage];
}
