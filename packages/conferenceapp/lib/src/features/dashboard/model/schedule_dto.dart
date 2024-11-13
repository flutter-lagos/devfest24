import 'package:equatable/equatable.dart';

enum Day {
  day1('day-1'),
  day2('day-2');

  const Day(this.json);

  final String json;

  static Day fromJson(String json) {
    return Day.values.firstWhere((e) => e.json == json, orElse: () => Day.day1);
  }
}

final class ScheduleDto extends Equatable {
  final Map<Day, DayScheduleDto> schedule;

  const ScheduleDto({required this.schedule});

  const ScheduleDto.empty() : this(schedule: const {});

  factory ScheduleDto.fromJson(Map<String, dynamic> json) => ScheduleDto(
        schedule:
            json.entries.fold<Map<Day, DayScheduleDto>>({}, (prev, entry) {
          final day = Day.fromJson(entry.key);
          final schedule = DayScheduleDto.fromJson(entry.value);
          return {...prev, day: schedule};
        }),
      );

  Map<String, dynamic> toJson() =>
      schedule.map((key, value) => MapEntry(key.json, value.toJson()));

  @override
  List<Object?> get props => [schedule];
}

final class DayScheduleDto extends Equatable {
  final List<GeneralSessionDto> general;
  final List<BreakoutSessionDto> breakouts;
  final List<PostBreakoutSessionDto> postBreakout;

  const DayScheduleDto({
    required this.general,
    required this.breakouts,
    required this.postBreakout,
  });

  const DayScheduleDto.empty()
      : this(
          general: const [],
          breakouts: const [],
          postBreakout: const [],
        );

  factory DayScheduleDto.fromJson(Map<String, dynamic> json) => DayScheduleDto(
        general: switch (json['general']) {
          List list => list.map((e) => GeneralSessionDto.fromJson(e)).toList(),
          _ => const [],
        },
        breakouts: switch (json['breakouts']) {
          List list => list.map((e) => BreakoutSessionDto.fromJson(e)).toList(),
          _ => const [],
        },
        postBreakout: switch (json['post_breakout']) {
          List list =>
            list.map((e) => PostBreakoutSessionDto.fromJson(e)).toList(),
          _ => const [],
        },
      );

  Map<String, dynamic> toJson() => {
        'general': general.map((e) => e.toJson()).toList(),
        'breakouts': breakouts.map((e) => e.toJson()).toList(),
        'post_breakout': postBreakout.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [general, breakouts, postBreakout];
}

final class PostBreakoutSessionDto extends Equatable {
  final int duration;
  final String startTime;
  final String endTime;
  final List<GeneralEventDto> events;

  const PostBreakoutSessionDto({
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.events,
  });

  const PostBreakoutSessionDto.empty()
      : this(duration: 0, startTime: '', endTime: '', events: const []);

  factory PostBreakoutSessionDto.fromJson(Map<String, dynamic> json) =>
      PostBreakoutSessionDto(
        duration: json['duration'] ?? 0,
        startTime: json['start_time'] ?? '',
        endTime: json['end_time'] ?? '',
        events: switch (json['events']) {
          List list => list.map((e) => GeneralEventDto.fromJson(e)).toList(),
          _ => const [],
        },
      );

  Map<String, dynamic> toJson() => {
        'duration': duration,
        'start_time': startTime,
        'end_time': endTime,
        'events': events.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [duration, startTime, endTime, events];
}

final class BreakoutSessionDto extends Equatable {
  final VenueDto venue;
  final int duration;
  final String category;
  final List<BreakoutEventDto> events;

  const BreakoutSessionDto({
    required this.venue,
    required this.duration,
    required this.category,
    required this.events,
  });

  const BreakoutSessionDto.empty()
      : this(
          venue: const VenueDto(name: '', size: 0),
          duration: 0,
          category: '',
          events: const [],
        );

  factory BreakoutSessionDto.fromJson(Map<String, dynamic> json) =>
      BreakoutSessionDto(
        venue: VenueDto.fromJson(json['venue'] ?? {}),
        duration: json['duration'] ?? 0,
        category: json['category'] ?? '',
        events: switch (json['events']) {
          List list => list.map((e) => BreakoutEventDto.fromJson(e)).toList(),
          _ => const [],
        },
      );

  Map<String, dynamic> toJson() => {
        'venue': venue.toJson(),
        'duration': duration,
        'category': category,
        'events': events.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [venue, duration, category, events];
}

final class GeneralSessionDto extends Equatable {
  final int duration;
  final String startTime;
  final String endTime;
  final List<GeneralEventDto> events;

  const GeneralSessionDto({
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.events,
  });

  const GeneralSessionDto.empty()
      : this(duration: 0, startTime: '', endTime: '', events: const []);

  factory GeneralSessionDto.fromJson(Map<String, dynamic> json) =>
      GeneralSessionDto(
        duration: json['duration'] ?? 0,
        startTime: json['start_time'] ?? '',
        endTime: json['end_time'] ?? '',
        events: switch (json['events']) {
          List list => list.map((e) => GeneralEventDto.fromJson(e)).toList(),
          _ => const [],
        },
      );

  Map<String, dynamic> toJson() => {
        'duration': duration,
        'start_time': startTime,
        'end_time': endTime,
        'events': events.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [duration, startTime, endTime, events];
}

final class BreakoutEventDto extends Equatable {
  final int sessionId;
  final int duration;
  final String startTime;
  final String endTime;
  final String title;
  final String facilitator;

  const BreakoutEventDto({
    required this.sessionId,
    required this.duration,
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.facilitator,
  });

  const BreakoutEventDto.empty()
      : this(
          sessionId: 0,
          duration: 0,
          startTime: '',
          endTime: '',
          title: '',
          facilitator: '',
        );

  factory BreakoutEventDto.fromJson(Map<String, dynamic> json) =>
      BreakoutEventDto(
        sessionId: json['session_id'] ?? 0,
        duration: json['duration'] ?? 0,
        startTime: json['start_time'] ?? '',
        endTime: json['end_time'] ?? '',
        title: json['title'] ?? '',
        facilitator: json['facilitator'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'duration': duration,
        'start_time': startTime,
        'end_time': endTime,
        'title': title,
        'facilitator': facilitator,
      };

  @override
  List<Object?> get props =>
      [sessionId, duration, startTime, endTime, title, facilitator];
}

final class GeneralEventDto extends Equatable {
  final String title;
  final String facilitator;
  final VenueDto venue;
  final List<String> panelists;

  const GeneralEventDto({
    required this.title,
    required this.facilitator,
    required this.venue,
    required this.panelists,
  });

  GeneralEventDto.empty()
      : this(
          title: '',
          facilitator: '',
          venue: VenueDto(name: '', size: 0),
          panelists: const [],
        );

  factory GeneralEventDto.fromJson(Map<String, dynamic> json) =>
      GeneralEventDto(
        title: json['title'] ?? '',
        facilitator: json['facilitator'] ?? '',
        venue: VenueDto.fromJson(json['venue'] ?? {}),
        panelists: switch (json['panelists']) {
          List list => list.map((e) => e.toString()).toList(),
          _ => const [],
        },
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'facilitator': facilitator,
        'venue': venue.toJson(),
        'panelists': panelists,
      };

  @override
  List<Object?> get props => [title, facilitator, venue, panelists];
}

final class VenueDto extends Equatable {
  final String name;
  final int size;

  const VenueDto({required this.name, required this.size});

  factory VenueDto.fromJson(Map<String, dynamic> json) => VenueDto(
        name: json['name'] ?? '',
        size: switch (json['size']) {
          List<num> list =>
            list.fold<num>(0, (prev, next) => prev + next).toInt(),
          int size => size,
          _ => 0,
        },
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'size': size,
      };

  @override
  List<Object?> get props => [name, size];
}
