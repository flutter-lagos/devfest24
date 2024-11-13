import 'package:equatable/equatable.dart';

final class SignInRequestDto extends Equatable {
  final String id;
  final String emailAddress;

  const SignInRequestDto({
    required this.id,
    required this.emailAddress,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email_address': emailAddress,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [id, emailAddress];
}
