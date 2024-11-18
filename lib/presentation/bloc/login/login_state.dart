part of 'login_bloc.dart';

enum LoginStatus { initial, loading, success, failure }

abstract class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final String accessToken;
  final String message;

  const LoginSuccess(this.accessToken, this.message);
}

final class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);
}
