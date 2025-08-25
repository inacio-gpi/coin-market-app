import 'package:coin_market_app/features/home/domain/usecases/get_all_exchanges.dart';
import 'package:coin_market_app/features/home/presentation/bloc/home_event.dart';
import 'package:coin_market_app/features/home/presentation/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetAllExchanges getAllExchanges;

  HomeBloc({required this.getAllExchanges}) : super(HomeInitial()) {
    on<GetAllExchangesEvent>(_onGetAllExchanges);
  }

  Future<void> _onGetAllExchanges(
    GetAllExchangesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    final result = await getAllExchanges(null);

    result.fold(
      (failure) => emit(HomeError(message: failure.message)),
      (exchanges) => emit(ExchangesLoaded(exchanges: exchanges)),
    );
  }
}
