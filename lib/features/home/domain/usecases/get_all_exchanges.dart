import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/core/usecase/usecase.dart';
import 'package:coin_market_app/features/home/domain/entities/exchange.dart';
import 'package:coin_market_app/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllExchanges implements UseCase<List<Exchange>, void> {
  final HomeRepository repository;

  const GetAllExchanges(this.repository);

  @override
  Future<Either<Failure, List<Exchange>>> call(void params) async {
    return await repository.getAllExchanges();
  }
}
