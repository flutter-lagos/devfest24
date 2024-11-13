import 'package:equatable/equatable.dart';

final class SignInResponseDto extends Equatable {
  final String id;
  final String emailAddress;
  final String fullName;
  final DateTime createdAt;
  final String role;
  final String token;

  const SignInResponseDto(
      {required this.id,
      required this.emailAddress,
      required this.createdAt,
      required this.fullName,
      required this.role,
      required this.token});

  
  SignInResponseDto.empty()
      : this(
            createdAt: DateTime.now(),
            id: '',
            emailAddress: '',
            fullName: '',
            role: '',
            token: '');

  factory SignInResponseDto.fromJson(dynamic json) {
    return SignInResponseDto(
        createdAt:DateTime.parse(json['created_at']) ?? DateTime.now(),
        id: json['id'] ?? '',
        fullName: json['fullname'] ?? '',
        role: json['role'] ?? '',
        token: json['token'] ?? '',
        emailAddress: json['emailAddress'] ?? '');
  }

  @override
  
  List<Object?> get props =>
      [createdAt, id, fullName, role, token, emailAddress];
}
