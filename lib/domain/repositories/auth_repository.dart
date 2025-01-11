import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> createUserWithEmailAndPassword(
      String email, String password, String name);
  Future<Either<Failure, void>> signInWithEmailAndPassword(
      String email, String password);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, bool>> isSignedIn();
  String? getCurrentUserEmail();
  String? getCurrentUserName();
}
