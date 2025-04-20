// lib/features/profile/presentation/blocs/profile_bloc.dart

import 'package:expensego/features/profile/domain/usecases/delete_account.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expensego/features/profile/domain/entities/profile_entity.dart';
import 'package:expensego/features/profile/domain/usecases/change_password.dart';
import 'package:expensego/features/profile/domain/usecases/update_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfile updateProfile;
  final ChangePassword changePassword;
  final DeleteAccount deleteAccount;

  ProfileBloc({
    required this.updateProfile,
    required this.changePassword,
    required this.deleteAccount,
  }) : super(ProfileInitial()) {
    on<UpdateProfileRequested>(_onUpdateProfile);
    on<ChangePasswordRequested>(_onChangePassword);
    on<DeleteAccountRequested>(_onDeleteAccount);
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await updateProfile(event.profile);
    emit(
      result.fold(
        (failure) => ProfileError(failure.message),
        (_) => ProfileUpdateSuccess(),
      ),
    );
  }

  Future<void> _onChangePassword(
    ChangePasswordRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await changePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );
    emit(
      result.fold(
        (failure) => ProfileError(failure.message),
        (_) => ChangePasswordSuccess(),
      ),
    );
  }

  // Add handler method
  Future<void> _onDeleteAccount(
    DeleteAccountRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await deleteAccount(
      email: event.email,
      password: event.password,
    );
    emit(
      result.fold(
        (failure) => ProfileError(failure.message),
        (_) => AccountDeletedSuccessfully(),
      ),
    );
  }
}
