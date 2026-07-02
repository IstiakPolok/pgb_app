import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pgb_app/core/utils/shared_prefs_helper.dart';
import 'package:pgb_app/core/constants/api_endpoints.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(AuthLoading());
      debugPrint('AuthBloc: RegisterSubmitted started');
      debugPrint('Request URL: $registerEndpoint');
      final requestBody = {
        'email': event.email,
        'password': event.password,
        'full_name': event.fullName,
      };
      debugPrint('Request Body: ${jsonEncode(requestBody)}');
      
      try {
        final response = await http.post(
          Uri.parse(registerEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );

        debugPrint('Response Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);

          final accessToken = data['access_token'];
          final refreshToken = data['refresh_token'];
          final user = data['user'];

          debugPrint('AuthBloc: Registration successful, saving auth data');
          // Save token using your SharedPreferences helper
          await SharedPrefsHelper.saveAuthData(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: user['id'],
            name: user['name'],
            email: user['email'],
          );

          emit(AuthSuccess(accessToken: accessToken));
        } else {
          final errorData = jsonDecode(response.body);
          String errorMessage = 'Registration failed';
          if (errorData is Map) {
            if (errorData['error'] is Map && errorData['error']['message'] != null) {
              errorMessage = errorData['error']['message'];
            } else if (errorData['message'] != null) {
              errorMessage = errorData['message'];
            }
          }
          debugPrint('AuthBloc: Registration failed with message: $errorMessage');
          emit(
            AuthFailure(error: errorMessage),
          );
        }
      } catch (e) {
        debugPrint('AuthBloc: Exception during registration: $e');
        emit(AuthFailure(error: e.toString()));
      }
    });

    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      debugPrint('AuthBloc: LoginSubmitted started');
      debugPrint('Request URL: $loginEndpoint');
      final requestBody = {
        'email': event.email,
        'password': event.password,
      };
      debugPrint('Request Body: ${jsonEncode(requestBody)}');
      
      try {
        final response = await http.post(
          Uri.parse(loginEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestBody),
        );

        debugPrint('Response Status Code: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);

          final accessToken = data['access_token'];
          final refreshToken = data['refresh_token'];
          final user = data['user'];

          debugPrint('AuthBloc: Login successful, saving auth data');
          await SharedPrefsHelper.saveAuthData(
            accessToken: accessToken,
            refreshToken: refreshToken,
            userId: user['id'],
            name: user['name'],
            email: user['email'],
          );

          emit(AuthSuccess(accessToken: accessToken));
        } else {
          final errorData = jsonDecode(response.body);
          String errorMessage = 'Login failed';
          if (errorData is Map) {
            if (errorData['error'] is Map && errorData['error']['message'] != null) {
              errorMessage = errorData['error']['message'];
            } else if (errorData['message'] != null) {
              errorMessage = errorData['message'];
            }
          }
          debugPrint('AuthBloc: Login failed with message: $errorMessage');
          emit(
            AuthFailure(error: errorMessage),
          );
        }
      } catch (e) {
        debugPrint('AuthBloc: Exception during login: $e');
        emit(AuthFailure(error: e.toString()));
      }
    });
  }
}
