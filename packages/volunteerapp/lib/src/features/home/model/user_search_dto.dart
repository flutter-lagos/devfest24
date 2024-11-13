import 'package:equatable/equatable.dart';

final class AttendeeSearchResponseDto extends Equatable {
  final List<AttendeeResult> attendeeList;
  const AttendeeSearchResponseDto({required this.attendeeList});

  factory AttendeeSearchResponseDto.fromJson(dynamic json) {
    return switch (json) {
      final List list? => AttendeeSearchResponseDto(
          attendeeList: list
              .map((e) => AttendeeResult.fromJson(e as Map<String, dynamic>))
              .toList()),
      _ => AttendeeSearchResponseDto(attendeeList: [])
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [attendeeList];
}

final class AttendeesResponseDto extends Equatable {
  final List<AttendeeResult> attendees;
  const AttendeesResponseDto({required this.attendees});

  factory AttendeesResponseDto.fromJson(dynamic json) {
    return switch (json) {
      final List list? => AttendeesResponseDto(
          attendees: list
              .map((e) => AttendeeResult.fromJson(e as Map<String, dynamic>))
              .toList()),
      _ => AttendeesResponseDto(attendees: [])
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [attendees];
}
final class AttendeeResult extends Equatable {
  final String id;
  final String fullname;
  final String emailAddress;
  final String role;
  final String levelOfExpertise;
  final String ticketId;
  final String createdAt;
  final List interests;
  final List sessions;
  final bool ticketUpdated;
  final dynamic gender;
  final List checkins;
  final String resumeUrl;

  const AttendeeResult({
    required this.id,
    required this.fullname,
    required this.emailAddress,
    required this.role,
    required this.levelOfExpertise,
    required this.ticketId,
    required this.createdAt,
    required this.interests,
    required this.sessions,
    required this.ticketUpdated,
    required this.gender,
    required this.checkins,
    required this.resumeUrl
  });

  AttendeeResult.empty()
      : this(
            createdAt: '',
            id: '',
            fullname: '',
            emailAddress: '',
            role: '',
            levelOfExpertise: '',
            ticketId: '',
            interests: [],
            sessions: [],
            ticketUpdated: false,
            gender: '',
            checkins: [],
            resumeUrl: ''
            );

  AttendeeResult copyWith(
      {String? id,
      String? fullname,
      String? emailAddress,
      String? role,
      String? levelOfExpertise,
      String? ticketId,
      String? createdAt,
      List? interests,
      List? sessions,
      bool? ticketUpdated,
      dynamic gender,
      List? checkins,
      String? resumeUrl,
      }) {
    return AttendeeResult(
        id: id ?? this.id,
        fullname: fullname ?? this.fullname,
        emailAddress: emailAddress ?? this.emailAddress,
        role: role ?? this.role,
        levelOfExpertise: levelOfExpertise ?? this.levelOfExpertise,
        ticketId: ticketId ?? this.ticketId,
        createdAt: createdAt ?? this.createdAt,
        interests: interests ?? this.interests,
        sessions: sessions ?? this.sessions,
        ticketUpdated: ticketUpdated ?? this.ticketUpdated,
        gender: gender ?? this.gender,
        checkins: checkins??this.checkins,
        resumeUrl: resumeUrl??this.resumeUrl
        );
  }

  factory AttendeeResult.fromJson(dynamic json) {
    return AttendeeResult(
      id: json["id"] ?? DateTime.now(),
      createdAt: json["created_at"] ?? '',
      fullname: json["fullname"] ?? '',
      emailAddress: json["email_address"] ?? '',
      role: json["role"] ?? '',
      levelOfExpertise: json["role"] ?? '',
      ticketId: json["role"] ?? '',
      interests: json["interests"] ?? [],
      sessions: json["sessions"] ?? [],
      ticketUpdated: json["ticket_updated"] ?? '',
      gender: json["role"] ?? '',
      resumeUrl:  json["resume_url"] ?? '',
      checkins:  json["checkins"]!=null?List.from(json["checkins"]):[]
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "email_address": emailAddress,
        "role": role,
        "level_of_expertise": levelOfExpertise,
        "ticket_id": ticketId,
        "created_at": createdAt,
        "interests": interests.map((x) => x).toList(),
        "sessions": sessions.map((x) => x).toList(),
        "ticket_updated": ticketUpdated,
        "gender": gender,
        "resume_url":resumeUrl,
        "checkins":checkins.map((x)=>x).toList()
      };
  @override
  List<Object?> get props => [
        id,
        createdAt,
        fullname,
        emailAddress,
        role,
        levelOfExpertise,
        ticketId,
        interests,
        sessions,
        ticketUpdated,
        gender,
        checkins,
        resumeUrl
      ];
}
