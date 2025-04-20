// lib/features/auth/presentation/blocs/auth_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:expensego/core/errors/failures.dart';
import 'package:expensego/core/services/auth_service.dart';
import 'package:expensego/features/auth/domain/usecases/get_current_user.dart';
import 'package:expensego/features/auth/domain/usecases/sign_in.dart';
import 'package:expensego/features/auth/domain/usecases/sign_out.dart';
import 'package:expensego/features/auth/domain/usecases/sign_up.dart';
import 'package:expensego/features/auth/domain/entities/user_entity.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignUp signUp;
  final SignOut signOut;
  final GetCurrentUser getCurrentUser;
  final AuthService authService;

  AuthBloc({
    required this.signIn,
    required this.signUp,
    required this.signOut,
    required this.getCurrentUser,
    required this.authService,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<RefreshUserRequested>(_onRefreshUserRequested);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  void _onRefreshUserRequested(
    RefreshUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authService.reloadCurrentUser();
      final refreshedUser = getCurrentUser();

      if (refreshedUser != null) {
        emit(Authenticated(user: refreshedUser));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Gagal menyegarkan data pengguna.'));
    }
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = getCurrentUser();
    if (user != null) {
      emit(Authenticated(user: user));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signIn(email: event.email, password: event.password);

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(Authenticated(user: user)),
    );
  }

  void _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signUp(email: event.email, password: event.password);

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(SignUpSuccess()),
    );
  }

  void _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signOut();

    result.fold(
      (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
      (user) => emit(SignOutSuccessfully()),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    final message = failure.message.toLowerCase();

    if (message.contains('auth credential is incorrect')) {
      return 'Login gagal! kredensial salah.';
    } else if (message.contains('is already in use')) {
      return 'Registrasi gagal! Email sudah digunakan.';
    } else if (message.contains(
      'We have blocked all requests from this device',
    )) {
      return 'Terlalu banyak percobaan login. Coba lagi nanti.';
    }
    // fallback
    return failure.message;
  }
}
