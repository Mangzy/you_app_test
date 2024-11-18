part of 'login_bloc.dart';

abstract class LoginEvent {}

class LoginRequested extends LoginEvent {
  final String email;
  final String username;
  final String password;

  LoginRequested({
    required this.email,
    required this.username,
    required this.password,
  });
}
