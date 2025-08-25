import 'package:coin_market_app/features/home/domain/entities/exchange.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class ExchangesLoaded extends HomeState {
  final List<Exchange> exchanges;

  const ExchangesLoaded({required this.exchanges});

  @override
  List<Object?> get props => [exchanges];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}
