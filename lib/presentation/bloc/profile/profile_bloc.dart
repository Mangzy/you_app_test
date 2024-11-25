import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_app_test/models/profile/profile_response.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);
    on<AddProfile>(_onAddProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateInterests>(_onUpdateInterestProfile);
  }

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _onFetchProfile(
      FetchProfile event, Emitter<ProfileState> emit) async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        emit(const ProfileFailure('Access token not found'));
        return;
      }

      final response = await http.get(
        Uri.parse('https://techtest.youapp.ai/api/getProfile'),
        headers: {
          'x-access-token': token,
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final users = ProfileResponse.fromJson(data['data']);
        emit(ProfileSuccess(users, true));
        if (data['data']['name'] == null &&
            data['data']['birthday'] == null &&
            data['data']['height'] == null &&
            data['data']['weight'] == null) {
          emit(ProfileSuccess(
              ProfileResponse(
                  name: '', birthday: '', height: 0, weight: 0, interests: []),
              false));
        }
      }
    } catch (e) {
      emit(const ProfileFailure('An error occurred'));
    }
  }

  Future<void> _onAddProfile(
      AddProfile event, Emitter<ProfileState> emit) async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        emit(const ProfileFailure('Access token not found'));
        return;
      }

      final response = await http.post(
        Uri.parse('https://techtest.youapp.ai/api/createProfile'),
        headers: {
          'x-access-token': token,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': event.user.name,
          'birthday': event.user.birthday,
          'height': event.user.height,
          'weight': event.user.weight,
          'interests': [],
        }),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final users = ProfileResponse.fromJson(data);
        emit(ProfileSuccess(users, true));
      } else {
        emit(ProfileFailure(data['message']));
      }
    } catch (e) {
      emit(const ProfileFailure('An error occurred'));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        emit(const ProfileFailure('Access token not found'));
        return;
      }

      final response = await http.put(
        Uri.parse('https://techtest.youapp.ai/api/updateProfile'),
        headers: {
          'x-access-token': token,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': event.user.name,
          'birthday': event.user.birthday,
          'height': event.user.height,
          'weight': event.user.weight,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final users = ProfileResponse.fromJson(data);
        emit(ProfileSuccess(users, true));
      } else {
        emit(ProfileFailure(data['message']));
      }
    } catch (e) {
      emit(const ProfileFailure('An error occurred'));
    }
  }

  Future<void> _onUpdateInterestProfile(
      UpdateInterests event, Emitter<ProfileState> emit) async {
    try {
      final token = await _getAccessToken();
      if (token == null) {
        emit(const ProfileFailure('Access token not found'));
        return;
      }

      final response = await http.put(
        Uri.parse('https://techtest.youapp.ai/api/updateProfile'),
        headers: {
          'x-access-token': token,
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'interests': event.interests,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final users = ProfileResponse.fromJson(data);
        emit(ProfileSuccess(users, true));
      } else {
        emit(ProfileFailure(data['message']));
      }
    } catch (e) {
      emit(const ProfileFailure('An error occurred'));
    }
  }
}
