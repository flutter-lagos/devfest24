import 'package:equatable/equatable.dart';

final class SponsorsDto extends Equatable {
  final List<SponsorDto> sponsors;

  const SponsorsDto({required this.sponsors});

  factory SponsorsDto.fromJson(dynamic json) => SponsorsDto(
        sponsors: switch (json) {
          List list => list.map((e) => SponsorDto.fromJson(e)).toList(),
          _ => const [],
        },
      );

  dynamic toJson() => sponsors;

  @override
  List<Object?> get props => [sponsors];
}

final class SponsorDto extends Equatable {
  final String name;
  final String level;
  final String logo;
  final String link;

  const SponsorDto({
    required this.name,
    required this.level,
    required this.logo,
    required this.link,
  });

  factory SponsorDto.fromJson(Map<String, dynamic> json) => SponsorDto(
        name: json['name'] ?? '',
        level: json['level'] ?? '',
        logo: json['logo'] ?? '',
        link: json['link'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'level': level,
        'logo': logo,
        'link': link,
      };

  @override
  List<Object?> get props => [name, level, logo, link];
}
