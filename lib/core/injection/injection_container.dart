import 'package:coin_market_app/core/api/custom_http_client.dart';
import 'package:coin_market_app/features/exchanges/data/datasources/exchange_local_datasource.dart';
import 'package:coin_market_app/features/exchanges/data/datasources/exchange_remote_datasource.dart';
import 'package:coin_market_app/features/exchanges/data/repositories_impl/exchange_repository_impl.dart';
import 'package:coin_market_app/features/exchanges/domain/repositories/exchange_repository.dart';
import 'package:coin_market_app/features/exchanges/domain/usecases/get_exchange_assets.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerLazySingleton<CustomHttpClient>(
    () => CustomHttpClient.coinMarketCap(),
  );
  getIt.registerLazySingleton<ExchangeRemoteDataSource>(
    () => ExchangeRemoteDataSourceImpl(httpClient: getIt()),
  );
  getIt.registerLazySingleton<ExchangeLocalDataSource>(
    () => ExchangeLocalDataSourceImpl(),
  );
  final localDataSource = getIt<ExchangeLocalDataSource>();
  if (localDataSource is ExchangeLocalDataSourceImpl) {
    await localDataSource.init();
  }
  getIt.registerLazySingleton<ExchangeRepository>(
    () => ExchangeRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => GetExchangeAssets(getIt()));
  getIt.registerFactory(() => ExchangeBloc(getExchangeAssets: getIt()));
}
