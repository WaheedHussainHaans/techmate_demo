import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:techmate_demo/core/errors/exceptions.dart';
import 'package:techmate_demo/core/errors/failures.dart';
import 'package:techmate_demo/core/network/network_info.dart';
import 'package:techmate_demo/data/datasources/firebase_data_source.dart';
import 'package:techmate_demo/data/datasources/local_data_source.dart';
import 'package:techmate_demo/data/models/form_data_model.dart';
import 'package:techmate_demo/data/repositories/form_repository_impl.dart';
import 'package:techmate_demo/domain/entities/form_data.dart';

import 'form_repository_impl_test.mocks.dart';

@GenerateMocks([FirebaseDataSource, LocalDataSource, NetworkInfo])
void main() {
  late FormRepositoryImpl repository;
  late MockFirebaseDataSource mockFirebaseDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockFirebaseDataSource = MockFirebaseDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = FormRepositoryImpl(
      firebaseDataSource: mockFirebaseDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tFormData = FormData(
    name: 'Test Name',
    email: 'test@example.com',
    picture: 'test_picture.jpg',
    description: 'Test Description',
  );

  const tFormDataModel = FormDataModel(
    name: 'Test Name',
    email: 'test@example.com',
    picture: 'test_picture.jpg',
    description: 'Test Description',
  );

  group('createFormData', () {
    test(
      'should call firebase data source when device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockFirebaseDataSource.createFormData(any))
            .thenAnswer((_) async {});
        // act
        await repository.createFormData(tFormData);
        // assert
        verify(mockFirebaseDataSource.createFormData(tFormDataModel));
        verifyNever(mockLocalDataSource.cacheFormData(any));
      },
    );

    test(
      'should call local data source when device is offline',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockLocalDataSource.cacheFormData(any)).thenAnswer((_) async {});
        // act
        await repository.createFormData(tFormData);
        // assert
        verify(mockLocalDataSource.cacheFormData(tFormDataModel));
        verifyNever(mockFirebaseDataSource.createFormData(any));
      },
    );

    test(
      'should return ServerFailure when firebase data source throws ServerException',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockFirebaseDataSource.createFormData(any))
            .thenThrow(ServerException());
        // act
        final result = await repository.createFormData(tFormData);
        // assert
        expect(result, Left(ServerFailure()));
      },
    );

    test(
      'should return CacheFailure when local data source throws CacheException',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockLocalDataSource.cacheFormData(any))
            .thenThrow(CacheException());
        // act
        final result = await repository.createFormData(tFormData);
        // assert
        expect(result, Left(CacheFailure()));
      },
    );
  });
}
