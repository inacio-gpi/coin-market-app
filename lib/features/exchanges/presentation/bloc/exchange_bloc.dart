import 'package:coin_market_app/features/exchanges/domain/usecases/get_exchange_assets.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_event.dart';
import 'package:coin_market_app/features/exchanges/presentation/bloc/exchange_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExchangeBloc extends Bloc<ExchangeEvent, ExchangeState> {
  final GetExchangeAssets getExchangeAssets;

  ExchangeBloc({required this.getExchangeAssets}) : super(ExchangeInitial()) {
    on<GetExchangeAssetsEvent>(_onGetExchangeAssets);
    on<RefreshExchangeAssetsEvent>(_onRefreshExchangeAssets);
  }

  Future<void> _onGetExchangeAssets(
    GetExchangeAssetsEvent event,
    Emitter<ExchangeState> emit,
  ) async {
    emit(ExchangeLoading());

    final result = await getExchangeAssets(event.exchangeId);

    result.fold(
      (failure) => emit(ExchangeError(message: failure.message)),
      (assets) => emit(ExchangeAssetsLoaded(assets: assets)),
    );
  }

  Future<void> _onRefreshExchangeAssets(
    RefreshExchangeAssetsEvent event,
    Emitter<ExchangeState> emit,
  ) async {
    emit(ExchangeLoading());

    final result = await getExchangeAssets(event.exchangeId);

    result.fold(
      (failure) => emit(ExchangeError(message: failure.message)),
      (assets) => emit(ExchangeAssetsLoaded(assets: assets)),
    );
  }
}
