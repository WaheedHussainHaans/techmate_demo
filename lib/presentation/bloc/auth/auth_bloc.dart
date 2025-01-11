import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/login_user.dart';
import '../../../domain/usecases/logout_user.dart';
import '../../../domain/usecases/register_user.dart';
import '../../../domain/usecases/is_signed_in.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final IsSignedIn isSignedIn;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
    required this.isSignedIn,
  }) : super(AuthInitial()) {
    on<AuthCheckStatus>(_onAuthCheckStatus);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  void _onAuthCheckStatus(
      AuthCheckStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await isSignedIn();
    result.fold(
      (failure) =>
          emit(AuthFailureState(message: 'Failed to check auth status')),
      (isSignedIn) =>
          isSignedIn ? emit(AuthSuccess()) : emit(AuthUnauthenticated()),
    );
  }

  void _onAuthLoginRequested(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUser(event.email, event.password);
    result.fold(
      (failure) => emit(AuthFailureState(message: 'Login failed')),
      (_) => emit(AuthSuccess()),
    );
  }

  void _onAuthRegisterRequested(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUser(event.email, event.password, event.name);
    result.fold(
      (failure) => emit(
          AuthFailureState(message: failure.message ?? 'Registration failed')),
      (_) => emit(AuthSuccess()),
    );
  }

  void _onAuthLogoutRequested(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUser();
    result.fold(
      (failure) => emit(AuthFailureState(message: 'Logout failed')),
      (_) => emit(AuthUnauthenticated()),
    );
  }
}
