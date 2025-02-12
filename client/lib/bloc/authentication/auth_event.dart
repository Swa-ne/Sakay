import 'package:equatable/equatable.dart';
import 'package:sakay_app/data/models/login.dart';
import 'package:sakay_app/data/models/sign_up.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final SignUpUserModel user;
  final bool isThirdParty;

  const SignUpEvent(this.user, this.isThirdParty);

  @override
  List<Object> get props => [user, isThirdParty];
}

class LoginEvent extends AuthEvent {
  final LoginUserModel user;

  const LoginEvent(this.user);

  @override
  List<Object> get props => [user];
}

class VerifyEmailEvent extends AuthEvent {
  final String token;
  final String code;

  const VerifyEmailEvent(this.token, this.code);

  @override
  List<Object> get props => [token, code];
}

class ResendEmailCodeEvent extends AuthEvent {
  final String token;

  const ResendEmailCodeEvent(this.token);

  @override
  List<Object> get props => [token];
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent(this.email);

  @override
  List<Object> get props => [email];
}

class PostResetPasswordEvent extends AuthEvent {
  final String token;
  final String password;
  final String confirmation_password;

  const PostResetPasswordEvent(
      this.token, this.password, this.confirmation_password);

  @override
  List<Object> get props => [token, password, confirmation_password];
}

class AuthenticateTokenEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class CheckAuthenticationEvent extends AuthEvent {}
