import 'package:coin_market_app/core/errors/exceptions.dart';
import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/features/home/data/datasources/home_remote_datasource.dart';
import 'package:coin_market_app/features/home/domain/entities/exchange.dart';
import 'package:coin_market_app/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  const HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Exchange>>> getAllExchanges() async {
    try {
      final remoteExchanges = await remoteDataSource.getAllExchanges();
      return Right(remoteExchanges.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: 'Unexpected error: $e'));
    }
  }
}
