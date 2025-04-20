// import 'package:equatable/equatable.dart';

part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {}

class ChangePasswordSuccess extends ProfileState {}

class ProfileUpdateFailure extends ProfileState {
  final String message;

  const ProfileUpdateFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class AccountDeletedSuccessfully extends ProfileState {}
