import 'package:clean_arch/features/domain/repositories/number_trivie_repository.dart';
import 'package:clean_arch/features/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_arch/features/domain/usecases/get_random_number_trivia.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/utils/input_converter.dart';
import 'features/data/datasources/nuber_trivia_local_datasource.dart';
import 'features/data/datasources/number_trivia_remote_data_source.dart';
import 'features/data/repositories/number_trivia_repository_impl.dart';
import 'features/presentation/bloc/bloc/number_trivia_bloc.dart';
final sl = GetIt.instance;

Future<void>? init() async {
  //! Feature - Number Trivia
  //* Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      getRandomNumberTrivia: sl(),
      getConcreteNumberTrivia: sl(),
      inputConverter: sl(),
    ),
  );

  //* usecase
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNuberTrivia(sl()));

  //* repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      numberTriviaRemoteDatasource: sl(),
      numberTriviaLocalDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  //* data sources
  sl.registerLazySingleton<NumberTriviaRemoteDatasource>(
    () => NumberTriviaRemoteDatasourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  //! core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
