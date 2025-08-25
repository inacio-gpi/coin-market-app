import 'package:equatable/equatable.dart';

abstract class ExchangeEvent extends Equatable {
  const ExchangeEvent();

  @override
  List<Object?> get props => [];
}

class GetExchangeAssetsEvent extends ExchangeEvent {
  final int exchangeId;

  const GetExchangeAssetsEvent({required this.exchangeId});

  @override
  List<Object?> get props => [exchangeId];
}

class RefreshExchangeAssetsEvent extends ExchangeEvent {
  final int exchangeId;

  const RefreshExchangeAssetsEvent({required this.exchangeId});

  @override
  List<Object?> get props => [exchangeId];
}
