import 'package:coin_market_app/features/exchanges/domain/entities/exchange_asset.dart';
import 'package:equatable/equatable.dart';

abstract class ExchangeState extends Equatable {
  const ExchangeState();

  @override
  List<Object?> get props => [];
}

class ExchangeInitial extends ExchangeState {}

class ExchangeLoading extends ExchangeState {}

class ExchangeAssetsLoaded extends ExchangeState {
  final List<ExchangeAsset> assets;

  const ExchangeAssetsLoaded({required this.assets});

  @override
  List<Object?> get props => [assets];
}

class ExchangeError extends ExchangeState {
  final String message;

  const ExchangeError({required this.message});

  @override
  List<Object?> get props => [message];
}
