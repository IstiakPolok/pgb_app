import 'package:flutter/foundation.dart';

@immutable
abstract class AuthEvent {}

class RegisterSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  RegisterSubmitted({
    required this.email,
    required this.password,
    required this.fullName,
  });
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  LoginSubmitted({
    required this.email,
    required this.password,
  });
}
