import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterUser>(_onRegisterUser);
  }

  Future<void> _onRegisterUser(
      RegisterUser event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final response = await http.post(
        Uri.parse('https://techtest.youapp.ai/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': event.email,
          'username': event.username,
          'password': event.password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(RegisterSuccess());
      } else {
        final error = jsonDecode(response.body)['message'];
        emit(RegisterFailure(error));
      }
    } catch (e) {
      emit(RegisterFailure('An error occurred'));
    }
  }
}
