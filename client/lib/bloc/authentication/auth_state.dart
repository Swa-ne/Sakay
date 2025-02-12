import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String userType;

  const AuthSuccess(this.userType);

  @override
  List<Object> get props => [userType];
}

class AuthFailure extends AuthState {}

class SignUpSuccess extends AuthState {
  final String token;

  const SignUpSuccess(this.token);

  @override
  List<Object> get props => [token];
}

class LoginSuccess extends AuthState {
  final String token;
  final String userType;

  const LoginSuccess(this.token, this.userType);

  @override
  List<Object> get props => [token, userType];
}

class VerifyEmailSuccess extends AuthState {
  final String token;

  const VerifyEmailSuccess(this.token);

  @override
  List<Object> get props => [token];
}

class ForgetPasswordSuccess extends AuthState {
  final String token;

  const ForgetPasswordSuccess(this.token);

  @override
  List<Object> get props => [token];
}

class ResendEmailCodeSuccess extends AuthState {
  final bool isSuccess;

  const ResendEmailCodeSuccess(this.isSuccess);

  @override
  List<Object> get props => [isSuccess];
}

class ChangePasswordSuccess extends AuthState {
  final bool isSuccess;

  const ChangePasswordSuccess(this.isSuccess);

  @override
  List<Object> get props => [isSuccess];
}

class EmailNotVerified extends AuthState {
  final String token;

  const EmailNotVerified(this.token);

  @override
  List<Object> get props => [token];
}

class LoginError extends AuthState {
  final String error;

  const LoginError(this.error);

  @override
  List<Object> get props => [error];
}

class LoginConnectionError extends AuthState {
  final String error;

  const LoginConnectionError(this.error);

  @override
  List<Object> get props => [error];
}

class SignUpConnectionError extends AuthState {
  final String error;

  const SignUpConnectionError(this.error);

  @override
  List<Object> get props => [error];
}

class VerificationConnectionError extends AuthState {
  final String error;

  const VerificationConnectionError(this.error);

  @override
  List<Object> get props => [error];
}

class SignUpError extends AuthState {
  final String error;

  const SignUpError(this.error);

  @override
  List<Object> get props => [error];
}

class VerificationError extends AuthState {
  final String error;

  const VerificationError(this.error);

  @override
  List<Object> get props => [error];
}

class ForgetPasswordError extends AuthState {
  final String error;

  const ForgetPasswordError(this.error);

  @override
  List<Object> get props => [error];
}

class ChangePasswordError extends AuthState {
  final String error;

  const ChangePasswordError(this.error);

  @override
  List<Object> get props => [error];
}

class LogoutSuccess extends AuthState {}

class LogoutError extends AuthState {
  final String error;

  const LogoutError(this.error);

  @override
  List<Object> get props => [error];
}

class AuthLoggedOut extends AuthState {}
