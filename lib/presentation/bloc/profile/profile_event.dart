part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {}

class AddProfile extends ProfileEvent {
  final ProfileResponse user;

  AddProfile(this.user);
}

class UpdateProfile extends ProfileEvent {
  final ProfileResponse user;

  UpdateProfile(this.user);
}

class UpdateInterests extends ProfileEvent {
  final List<String> interests;
  UpdateInterests(this.interests);
}
