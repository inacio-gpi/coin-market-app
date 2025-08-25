import 'package:equatable/equatable.dart';

class ExchangeInfo extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String logo;
  final String description;
  final DateTime dateLaunched;
  final String? notice;
  final List<String> countries;
  final List<String> fiats;
  final List<String>? tags;
  final String? type;
  final double makerFee;
  final double takerFee;
  final int weeklyVisits;
  final double spotVolumeUsd;
  final DateTime spotVolumeLastUpdated;
  final ExchangeUrls urls;

  const ExchangeInfo({
    required this.id,
    required this.name,
    required this.slug,
    required this.logo,
    required this.description,
    required this.dateLaunched,
    this.notice,
    required this.countries,
    required this.fiats,
    this.tags,
    this.type,
    required this.makerFee,
    required this.takerFee,
    required this.weeklyVisits,
    required this.spotVolumeUsd,
    required this.spotVolumeLastUpdated,
    required this.urls,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    logo,
    description,
    dateLaunched,
    notice,
    countries,
    fiats,
    tags,
    type,
    makerFee,
    takerFee,
    weeklyVisits,
    spotVolumeUsd,
    spotVolumeLastUpdated,
    urls,
  ];
}

class ExchangeUrls extends Equatable {
  final List<String> website;
  final List<String> twitter;
  final List<String> blog;
  final List<String> chat;
  final List<String> fee;

  const ExchangeUrls({
    required this.website,
    required this.twitter,
    required this.blog,
    required this.chat,
    required this.fee,
  });

  @override
  List<Object?> get props => [website, twitter, blog, chat, fee];
}
