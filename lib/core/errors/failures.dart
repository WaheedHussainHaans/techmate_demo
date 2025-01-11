import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;

  const Failure({this.message});
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class AuthFailure extends Failure {
  const AuthFailure({super.message});
}

class ValidationFailure extends Failure {
  const ValidationFailure({super.message});
  @override
  List<Object?> get props => [message];
}
