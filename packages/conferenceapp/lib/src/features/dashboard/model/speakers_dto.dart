import 'package:equatable/equatable.dart';

final class SpeakersDto extends Equatable {
  final List<SpeakerDto> speakers;

  const SpeakersDto({required this.speakers});

  factory SpeakersDto.fromJson(dynamic json) => SpeakersDto(
        speakers: switch (json) {
          List list => list.map((e) => SpeakerDto.fromJson(e)).toList(),
          Map<String, dynamic> map => map.entries
              .map((entry) {
                if (entry.value is Map<String, dynamic>) {
                  return entry.value as Map<String, dynamic>;
                }
                return <String, dynamic>{};
              })
              .map(SpeakerDto.fromJson)
              .toList(),
          _ => const [],
        },
      );

  dynamic toJson() => speakers;

  @override
  List<Object?> get props => [speakers];
}

final class SpeakerDto extends Equatable {
  final String id;
  final String name;
  final String title;
  final String shortbio;
  final String bio;
  final String imageUrl;
  final int day;
  final Map<String, dynamic> links;
  final String track;
  final String sessionTitle;

  const SpeakerDto({
    required this.id,
    required this.name,
    required this.title,
    required this.shortbio,
    required this.bio,
    required this.imageUrl,
    required this.day,
    required this.links,
    required this.track,
    required this.sessionTitle,
  });

  factory SpeakerDto.fromJson(Map<String, dynamic> json) => SpeakerDto(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        title: json['title'] ?? '',
        shortbio: json['shortbio'] ?? '',
        bio: json['bio'] ?? '',
        imageUrl: json['image_url'] ?? '',
        day: json['day'] ?? 0,
        links: switch (json['links']) {
          Map map => map.map((key, value) => MapEntry(key.toString(), value)),
          _ => const {},
        },
        track: json['track'] ?? '',
        sessionTitle: json['session_title'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'shortbio': shortbio,
        'bio': bio,
        'image_url': imageUrl,
        'day': day,
        'links': links,
        'track': track,
        'session_title': sessionTitle,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        title,
        shortbio,
        bio,
        imageUrl,
        day,
        links,
        track,
        sessionTitle
      ];
}
