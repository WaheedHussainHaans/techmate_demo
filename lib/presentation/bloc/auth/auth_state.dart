part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthFailureState extends AuthState {
  final String message;

  AuthFailureState({required this.message});

  @override
  List<Object?> get props => [message];
}
