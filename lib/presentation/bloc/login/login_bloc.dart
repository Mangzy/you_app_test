import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:you_app_test/models/login/login_response.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      final response = await http.post(
        Uri.parse('https://techtest.youapp.ai/api/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': event.username,
          'email': event.email,
          'password': event.password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final loginResponse = LoginResponse.fromJson(data);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', loginResponse.token);
        await prefs.setString('username', event.username);
        await prefs.setString('email', event.email);

        emit(LoginSuccess(data['access_token'], data['message']));
      } else {
        emit(LoginFailure(data['message']));
      }
    } catch (e) {
      emit(const LoginFailure('An error occurred'));
    }
  }
}
