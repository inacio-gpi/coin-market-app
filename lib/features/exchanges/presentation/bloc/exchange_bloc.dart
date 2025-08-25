import 'package:coin_market_app/features/exchanges/domain/entities/exchange_asset.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_info.dart';
import 'package:coin_market_app/features/exchanges/domain/usecases/get_exchange_assets.dart';
import 'package:coin_market_app/features/exchanges/domain/usecases/get_exchange_info.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_event.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangeBloc extends Bloc<ExchangeEvent, ExchangeState> {
  final GetExchangeAssets getExchangeAssets;
  final GetExchangeInfo getExchangeInfo;

  ExchangeBloc({required this.getExchangeAssets, required this.getExchangeInfo})
    : super(ExchangeInitial()) {
    on<LoadExchangeDetailsEvent>(_onLoadExchangeDetails);
    on<RefreshExchangeAssetsEvent>(_onRefreshExchangeAssets);
  }

  Future<void> _onLoadExchangeDetails(
    LoadExchangeDetailsEvent event,
    Emitter<ExchangeState> emit,
  ) async {
    emit(ExchangeLoading());

    try {
      final results = await Future.wait([
        getExchangeInfo(event.exchangeId),
        getExchangeAssets(event.exchangeId),
      ]);

      final infoResult = results[0];
      final assetsResult = results[1];

      if (infoResult.isRight() && assetsResult.isRight()) {
        final info =
            infoResult.getOrElse(() => throw Exception('Info not found'))
                as ExchangeInfo;
        final assets =
            assetsResult.getOrElse(() => throw Exception('Assets not found'))
                as List<ExchangeAsset>;

        emit(ExchangeDetailsLoaded(info: info, assets: assets));
      } else {
        final failure = infoResult.fold(
          (f) => f,
          (_) => assetsResult.fold(
            (f) => f,
            (_) => throw Exception('Unexpected error'),
          ),
        );
        emit(ExchangeError(message: failure.message));
      }
    } catch (e) {
      emit(ExchangeError(message: 'Failed to load exchange details: $e'));
    }
  }

  Future<void> _onRefreshExchangeAssets(
    RefreshExchangeAssetsEvent event,
    Emitter<ExchangeState> emit,
  ) async {
    try {
      final result = await getExchangeAssets(event.exchangeId);
      result.fold((failure) => emit(ExchangeError(message: failure.message)), (
        assets,
      ) {
        final currentState = state;
        if (currentState is ExchangeDetailsLoaded) {
          emit(ExchangeDetailsLoaded(info: currentState.info, assets: assets));
        } else {
          emit(ExchangeError(message: 'No exchange info available'));
        }
      });
    } catch (e) {
      emit(ExchangeError(message: 'Failed to refresh exchange assets: $e'));
    }
  }
}
