import 'package:coin_market_app/features/exchanges/domain/entities/exchange_info.dart';

class ExchangeInfoModel extends ExchangeInfo {
  const ExchangeInfoModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.logo,
    required super.description,
    required super.dateLaunched,
    super.notice,
    required super.countries,
    required super.fiats,
    super.tags,
    super.type,
    required super.makerFee,
    required super.takerFee,
    required super.weeklyVisits,
    required super.spotVolumeUsd,
    required super.spotVolumeLastUpdated,
    required super.urls,
  });

  factory ExchangeInfoModel.fromJson(Map<String, dynamic> json) {
    return ExchangeInfoModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      logo: json['logo'] ?? '',
      description: json['description'] ?? '',
      dateLaunched: DateTime.parse(
        json['date_launched'] ?? DateTime.now().toIso8601String(),
      ),
      notice: json['notice'],
      countries: List<String>.from(json['countries'] ?? []),
      fiats: List<String>.from(json['fiats'] ?? []),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      type: json['type'],
      makerFee: (json['maker_fee'] as num?)?.toDouble() ?? 0.0,
      takerFee: (json['taker_fee'] as num?)?.toDouble() ?? 0.0,
      weeklyVisits: json['weekly_visits'] ?? 0,
      spotVolumeUsd: (json['spot_volume_usd'] as num?)?.toDouble() ?? 0.0,
      spotVolumeLastUpdated: DateTime.parse(
        json['spot_volume_last_updated'] ?? DateTime.now().toIso8601String(),
      ),
      urls: ExchangeUrlsModel.fromJson(json['urls'] ?? {}),
    );
  }

  ExchangeInfo toEntity() => this;
}

class ExchangeUrlsModel extends ExchangeUrls {
  const ExchangeUrlsModel({
    required super.website,
    required super.twitter,
    required super.blog,
    required super.chat,
    required super.fee,
  });

  factory ExchangeUrlsModel.fromJson(Map<String, dynamic> json) {
    return ExchangeUrlsModel(
      website: List<String>.from(json['website'] ?? []),
      twitter: List<String>.from(json['twitter'] ?? []),
      blog: List<String>.from(json['blog'] ?? []),
      chat: List<String>.from(json['chat'] ?? []),
      fee: List<String>.from(json['fee'] ?? []),
    );
  }
}
