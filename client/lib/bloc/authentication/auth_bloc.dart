import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sakay_app/bloc/authentication/auth_event.dart';
import 'package:sakay_app/bloc/authentication/auth_state.dart';
import 'package:sakay_app/data/sources/authentication/auth_repo.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo _authRepo;

  AuthBloc(this._authRepo) : super(AuthLoading()) {
    on<LoginEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final result = await _authRepo.login(event.user);
          final isEmailVerified =
              await _authRepo.checkEmailVerified(result["access_token"]);
          if (isEmailVerified) {
            emit(LoginSuccess(result["access_token"], result["user_type"]));
          } else {
            emit(EmailNotVerified(result["access_token"]));
          }
        } catch (e) {
          if (e is Exception &&
              e.toString().contains("Internal Server Error")) {
            emit(const LoginConnectionError("Internet Connection Error"));
          } else {
            emit(LoginError(e.toString()));
          }
        }
      },
    );
    on<SignUpEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final access_token =
              await _authRepo.signUp(event.user, event.isThirdParty);
          emit(SignUpSuccess(access_token));
        } catch (e) {
          if (e is Exception &&
              e.toString().contains("Internal Server Error")) {
            emit(const SignUpConnectionError("Internet Connection Error"));
          } else {
            emit(SignUpError(e.toString()));
          }
        }
      },
    );
    on<ResendEmailCodeEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final isSuccess = await _authRepo.resendEmailCode(event.token);
          emit(ResendEmailCodeSuccess(isSuccess));
        } catch (e) {
          emit(const VerificationConnectionError("Internet Connection Error"));
        }
      },
    );
    on<VerifyEmailEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final access_token =
              await _authRepo.verifyEmail(event.token, event.code);
          emit(VerifyEmailSuccess(access_token));
        } catch (e) {
          if (e.toString().contains("Server connection error")) {
            emit(const VerificationError("No internet connection."));
          } else if (e.toString().contains("Incorrect Verification Code")) {
            emit(
                const VerificationError("The verification code is incorrect."));
          } else {
            emit(const VerificationError("An unexpected error occurred."));
          }
        }
      },
    );
    on<ForgotPasswordEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final access_token = await _authRepo.forgotPassword(event.email);
          emit(ForgetPasswordSuccess(access_token));
        } catch (e) {
          emit(const ForgetPasswordError("Internet Connection Error"));
        }
      },
    );
    on<PostResetPasswordEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          final access_token = await _authRepo.postResetPassword(
              event.token, event.password, event.confirmation_password);
          emit(ChangePasswordSuccess(access_token));
        } catch (e) {
          emit(const ChangePasswordError("Internet Connection Error"));
        }
      },
    );
    on<AuthenticateTokenEvent>((event, emit) async {
      try {
        emit(AuthLoading());
        final result = await _authRepo.authenticateToken();
        final isAuthenticated = result["is_authenticated"];
        if (isAuthenticated) {
          emit(AuthSuccess(result["user_type"]));
        } else {
          emit(AuthFailure());
        }
      } catch (e) {
        emit(AuthFailure());
      }
    });
    on<LogoutEvent>(
      (event, emit) async {
        try {
          emit(AuthLoading());
          await _authRepo.logout();
          emit(LogoutSuccess());
        } catch (e) {
          if (e.toString().contains('Unauthorized')) {
            emit(LogoutSuccess());
          } else {
            emit(const LogoutError("Internet Connection Error"));
          }
        }
      },
    );
    on<CheckAuthenticationEvent>((event, emit) async {
      emit(AuthLoading());
      // final accessToken = await _tokenController.getAccessToken();

      // if (accessToken.isNotEmpty) {
      //   try {
      //     final isAuthenticated = await _authRepo.authenticateToken();
      //     if (isAuthenticated) {
      //       emit(AuthSuccess());
      //     } else {
      //       emit(AuthFailure());
      //     }
      //   } catch (e) {
      //     emit(AuthFailure());
      //   }
      // } else {
      //   emit(AuthFailure());
      // }
    });
  }
}
