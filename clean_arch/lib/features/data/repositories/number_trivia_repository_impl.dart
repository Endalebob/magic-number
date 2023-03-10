import '../../../../core/network/network_info.dart';

import '../models/number_trivia_model.dart';
import 'package:dartz/dartz.dart';

import '../../../core/error/exeptions.dart';
import '../../../core/error/failures.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivie_repository.dart';
import '../datasources/nuber_trivia_local_datasource.dart';
import '../datasources/number_trivia_remote_data_source.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTrivia> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  NumberTriviaRepositoryImpl({
    required this.numberTriviaRemoteDatasource,
    required this.numberTriviaLocalDataSource,
    required this.networkInfo,
  });

  final NetworkInfo networkInfo;
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  final NumberTriviaRemoteDatasource numberTriviaRemoteDatasource;

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int? number) async {
    return await _getTrivia(
        () => numberTriviaRemoteDatasource.getConcreteNumberTrivia(number)!);
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(
        () => numberTriviaRemoteDatasource.getRandomNumberTrivia()!);
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        numberTriviaLocalDataSource
            .cacheNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia =
            await numberTriviaLocalDataSource.getLastNumberTrivia();
        return Right(localTrivia!);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
