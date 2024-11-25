part of 'profile_bloc.dart';

enum ProfileStatus { initial, success, failure }

abstract class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final ProfileResponse users;
  final bool isProfileCreated;

  const ProfileSuccess(this.users, this.isProfileCreated);
}

final class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure(this.message);
}
