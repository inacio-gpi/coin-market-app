import 'package:coin_market_app/core/errors/exceptions.dart';
import 'package:coin_market_app/core/errors/failures.dart';
import 'package:coin_market_app/features/exchanges/data/datasources/exchange_local_datasource.dart';
import 'package:coin_market_app/features/exchanges/data/datasources/exchange_remote_datasource.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_asset.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_info.dart';
import 'package:coin_market_app/features/exchanges/domain/repositories/exchange_repository.dart';
import 'package:dartz/dartz.dart';

/// Implementation of ExchangeRepository
class ExchangeRepositoryImpl implements ExchangeRepository {
  final ExchangeRemoteDataSource remoteDataSource;
  final ExchangeLocalDataSource localDataSource;

  const ExchangeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<ExchangeAsset>>> getExchangeAssets(
    int exchangeId,
  ) async {
    try {
      // final cachedAssets = await localDataSource.getCachedExchangeAssets(
      //   exchangeId,
      // );
      // if (cachedAssets != null) {
      //   return Right(cachedAssets.map((model) => model.toEntity()).toList());
      // }

      final remoteAssets = await remoteDataSource.getExchangeAssets(exchangeId);
      await localDataSource.cacheExchangeAssets(exchangeId, remoteAssets);

      return Right(remoteAssets.map((model) => model.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, ExchangeInfo>> getExchangeInfo(int exchangeId) async {
    try {
      final remoteInfo = await remoteDataSource.getExchangeInfo(exchangeId);
      return Right(remoteInfo.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: 'Unexpected error: $e'));
    }
  }
}
