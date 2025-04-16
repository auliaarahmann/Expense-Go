import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expensego/features/profile/domain/entities/profile_entity.dart';
import 'package:expensego/features/profile/domain/usecases/update_profile.dart';
import 'package:expensego/core/errors/failures.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfile updateProfile;

  ProfileBloc({required this.updateProfile}) : super(ProfileInitial()) {
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileUpdating());

    final result = await updateProfile(
      event.profile,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(ProfileError(_mapFailureToMessage(failure))),
      (_) => emit(ProfileUpdated()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return failure.message;
  }
}
