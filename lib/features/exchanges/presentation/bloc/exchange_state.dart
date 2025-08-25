import 'package:coin_market_app/features/exchanges/domain/entities/exchange_asset.dart';
import 'package:coin_market_app/features/exchanges/domain/entities/exchange_info.dart';
import 'package:equatable/equatable.dart';

abstract class ExchangeState extends Equatable {
  const ExchangeState();

  @override
  List<Object?> get props => [];
}

class ExchangeInitial extends ExchangeState {}

class ExchangeLoading extends ExchangeState {}

class ExchangeDetailsLoaded extends ExchangeState {
  final ExchangeInfo info;
  final List<ExchangeAsset> assets;

  const ExchangeDetailsLoaded({required this.info, required this.assets});

  @override
  List<Object?> get props => [info, assets];
}

class ExchangeError extends ExchangeState {
  final String message;

  const ExchangeError({required this.message});

  @override
  List<Object?> get props => [message];
}
