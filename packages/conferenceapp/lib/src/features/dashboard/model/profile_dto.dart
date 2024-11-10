import 'package:equatable/equatable.dart';

final class ProfileResponseDto extends Equatable {
  final String id;
  final String fullName;
  final String emailAddress;
  final String role;
  final String levelOfExpertise;
  final String shirtSize;
  final String resumeUrl;
  final Map<String, dynamic> ticket;

  const ProfileResponseDto({
    required this.id,
    required this.fullName,
    required this.emailAddress,
    required this.role,
    required this.levelOfExpertise,
    required this.shirtSize,
    required this.resumeUrl,
    required this.ticket,
  });

  const ProfileResponseDto.empty()
      : this(
          id: '',
          fullName: '',
          emailAddress: '',
          role: '',
          levelOfExpertise: '',
          shirtSize: '',
          resumeUrl: '',
          ticket: const {},
        );

  factory ProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      ProfileResponseDto(
        id: json['id'] ?? '',
        fullName: json['fullname'] ?? '',
        emailAddress: json['email_address'] ?? '',
        role: json['role'] ?? '',
        levelOfExpertise: json['level_of_expertise'] ?? '',
        shirtSize: json['shirt_size'] ?? '',
        resumeUrl: json['resume_url'] ?? '',
        ticket: switch (json['ticket']) {
          Map map => map.map((key, value) => MapEntry(key.toString(), value)),
          _ => const {},
        },
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullname': fullName,
        'email_address': emailAddress,
        'role': role,
        'level_of_expertise': levelOfExpertise,
        'shirt_size': shirtSize,
        'ticket': ticket,
      };

  ProfileResponseDto copyWith({
    String? id,
    String? fullName,
    String? emailAddress,
    String? role,
    String? levelOfExpertise,
    String? shirtSize,
    String? resumeUrl,
    Map<String, dynamic>? ticket,
  }) {
    return ProfileResponseDto(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      emailAddress: emailAddress ?? this.emailAddress,
      role: role ?? this.role,
      levelOfExpertise: levelOfExpertise ?? this.levelOfExpertise,
      shirtSize: shirtSize ?? this.shirtSize,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      ticket: ticket ?? this.ticket,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        emailAddress,
        role,
        levelOfExpertise,
        shirtSize,
        ticket,
      ];
}
