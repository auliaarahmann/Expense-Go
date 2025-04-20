// import 'package:expensego/features/profile/domain/entities/profile_entity.dart';
// import 'package:equatable/equatable.dart';

part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileRequested extends ProfileEvent {
  final ProfileEntity profile;

  const UpdateProfileRequested(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ChangePasswordRequested extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object> get props => [currentPassword, newPassword];
}

class DeleteAccountRequested extends ProfileEvent {
  final String email;
  final String password;
  const DeleteAccountRequested({required this.email,  required this.password});
}
