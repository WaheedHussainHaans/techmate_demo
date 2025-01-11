import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseDataSource firebaseDataSource;

  AuthRepositoryImpl({required this.firebaseDataSource});

  @override
  Future<Either<Failure, void>> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      await firebaseDataSource.createUserWithEmailAndPassword(
          email, password, name);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? ''));
    } on ServerException {
      return const Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await firebaseDataSource.signInWithEmailAndPassword(email, password);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? ''));
    } on ServerException {
      return const Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await firebaseDataSource.signOut();
      return const Right(null);
    } on ServerException {
      return const Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    try {
      final isSignedIn = await firebaseDataSource.isSignedIn();
      return Right(isSignedIn);
    } on ServerException {
      return const Left(AuthFailure());
    }
  }

  @override
  String? getCurrentUserEmail() {
    return firebaseDataSource.getCurrentUser()?.email;
  }

  @override
  String? getCurrentUserName() {
    return firebaseDataSource.getCurrentUser()?.displayName;
  }
}
