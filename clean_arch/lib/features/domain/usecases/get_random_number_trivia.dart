import 'package:clean_arch/core/error/failures.dart';
import 'package:clean_arch/core/usecase/usecase.dart';
import 'package:clean_arch/features/domain/entities/number_trivia.dart';
import 'package:clean_arch/features/domain/repositories/number_trivie_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';


class GetRandomNuberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository numberTriviaRepository;
  GetRandomNuberTrivia({required this.numberTriviaRepository});

  @override
  Future<Either<Failure, NumberTrivia>?> call(NoParams params) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}


class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
