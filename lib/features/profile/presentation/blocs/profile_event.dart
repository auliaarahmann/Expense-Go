part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends ProfileEvent {
  final ProfileEntity profile;
  final String? currentPassword;
  final String? newPassword;

  const UpdateProfileRequested(
    this.profile, {
    this.currentPassword,
    this.newPassword,
  });

  @override
  List<Object?> get props => [profile, currentPassword, newPassword];
}
