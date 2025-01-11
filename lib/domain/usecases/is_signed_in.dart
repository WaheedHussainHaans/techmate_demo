import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class IsSignedIn {
  final AuthRepository repository;

  IsSignedIn(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.isSignedIn();
  }
}
