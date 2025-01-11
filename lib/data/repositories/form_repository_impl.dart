import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/form_data.dart';
import '../../domain/repositories/form_repository.dart';
import '../datasources/firebase_data_source.dart';
import '../datasources/local_data_source.dart';
import '../models/form_data_model.dart';

class FormRepositoryImpl implements FormRepository {
  final FirebaseDataSource firebaseDataSource;
  final LocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  FormRepositoryImpl({
    required this.firebaseDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> createFormData(FormData formData) async {
    final formDataModel = FormDataModel(
      name: formData.name,
      email: formData.email,
      picture: formData.picture,
      description: formData.description,
    );
    if (await networkInfo.isConnected) {
      try {
        await firebaseDataSource.createFormData(formDataModel);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        await localDataSource.cacheFormData(formDataModel);
        return const Right(null);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<FormData>>> getFormData() async {
    if (await networkInfo.isConnected) {
      try {
        final formDataModels = await firebaseDataSource.getFormData();
        return Right(formDataModels);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final formDataModels = await localDataSource.getCachedFormData();
        return Right(formDataModels);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> syncFormData() async {
    if (await networkInfo.isConnected) {
      try {
        final cachedFormData = await localDataSource.getCachedFormData();
        for (final formData in cachedFormData) {
          await firebaseDataSource.createFormData(formData);
        }
        await localDataSource.clearCachedFormData();
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}
