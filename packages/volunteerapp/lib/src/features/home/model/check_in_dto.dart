import 'package:equatable/equatable.dart';

final class CheckUserInRequestDto extends Equatable {
  final String userId;
  final num day;
  final String gender;

  const CheckUserInRequestDto({
    required this.userId,
    required this.day,
    required this.gender
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'day': day,
        'gender':gender
      };

  @override
  // TODO: implement props
  List<Object?> get props => [userId, day,gender];
}

final class CheckInUserResponseDto extends Equatable {
  final String id;
  final String userId;
  final num day;
  final String checkedInBy;
  final DateTime createdAt;

  const CheckInUserResponseDto({
    required this.id,
    required this.userId,
    required this.day,
    required this.checkedInBy,
    required this.createdAt,
  });

  CheckInUserResponseDto.empty()
      : this(
          createdAt: DateTime.now(),
          id: '',
          day: 1,
          checkedInBy: '',
          userId: '',
        );
  factory CheckInUserResponseDto.fromJson(dynamic json) {
    return CheckInUserResponseDto(
      id: json["id"] ?? DateTime.now(),
      createdAt: json["created_at"] ?? DateTime.now(),
      day: json["day"] ?? 1,
      checkedInBy: json["checked_in_by"] ?? '',
      userId: json["user_id"] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, createdAt, day, checkedInBy, userId];
}
