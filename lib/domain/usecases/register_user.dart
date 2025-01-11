import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<Either<Failure, void>> call(
      String email, String password, String name) async {
    return await repository.createUserWithEmailAndPassword(
        email, password, name);
  }
}
