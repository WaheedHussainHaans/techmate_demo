import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/network/network_info.dart';
import 'data/datasources/firebase_data_source.dart';
import 'data/datasources/local_data_source.dart';
import 'data/models/form_data_model.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/form_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/form_repository.dart';
import 'domain/usecases/create_form_data.dart';
import 'domain/usecases/get_form_data.dart';
import 'domain/usecases/is_signed_in.dart';
import 'domain/usecases/login_user.dart';
import 'domain/usecases/logout_user.dart';
import 'domain/usecases/register_user.dart';
import 'domain/usecases/sync_form_data.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/form/form_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // Firebase
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  // Hive
  await Hive.initFlutter();
  // Register Hive Adapters
  Hive.registerAdapter(FormDataModelAdapter());

  // Data Sources
  getIt.registerLazySingleton<FirebaseDataSource>(
    () => FirebaseDataSourceImpl(
        auth: firebaseAuth, firestore: firebaseFirestore, storage: storage),
  );
  getIt.registerLazySingleton<LocalDataSource>(
    () => LocalDataSourceImpl(hive: Hive),
  );

  // Network Info
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(InternetConnectionChecker()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseDataSource: getIt()),
  );
  getIt.registerLazySingleton<FormRepository>(
    () => FormRepositoryImpl(
      firebaseDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => LoginUser(getIt()));
  getIt.registerLazySingleton(() => RegisterUser(getIt()));
  getIt.registerLazySingleton(() => LogoutUser(getIt()));
  getIt.registerLazySingleton(() => IsSignedIn(getIt()));
  getIt.registerLazySingleton(() => CreateFormData(getIt()));
  getIt.registerLazySingleton(() => GetFormData(getIt()));
  getIt.registerLazySingleton(() => SyncFormData(getIt()));

  // Blocs
  getIt.registerFactory(
    () => AuthBloc(
      loginUser: getIt(),
      registerUser: getIt(),
      logoutUser: getIt(),
      isSignedIn: getIt(),
    ),
  );
  getIt.registerFactory(
    () => FormBloc(
      createFormData: getIt(),
      getFormData: getIt(),
      syncFormData: getIt(),
    ),
  );
}
