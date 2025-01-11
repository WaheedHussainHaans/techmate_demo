import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, void>> call(String email, String password) async {
    return await repository.signInWithEmailAndPassword(email, password);
  }
}
