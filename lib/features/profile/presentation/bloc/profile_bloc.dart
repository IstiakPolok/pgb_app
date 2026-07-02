import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pgb_app/core/network/api_client.dart';
import 'package:pgb_app/core/constants/api_endpoints.dart';
import 'package:pgb_app/core/utils/shared_prefs_helper.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      debugPrint('ProfileBloc: LoadProfile started');

      // 1. Read cached profile first to display immediately
      final cached = await SharedPrefsHelper.getCachedProfile();
      if (cached != null) {
        debugPrint('ProfileBloc: Emitting cached profile: $cached');
        emit(ProfileLoaded(
          name: cached['name'] ?? '',
          email: cached['email'] ?? '',
          role: cached['role'] ?? '',
        ));
      }

      // 2. Query endpoint to fetch fresh data
      try {
        debugPrint('ProfileBloc: Requesting $getMeEndpoint');
        final response = await ApiClient.get(getMeEndpoint);

        debugPrint('ProfileBloc Status Code: ${response.statusCode}');
        debugPrint('ProfileBloc Response Body: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          final data = jsonDecode(response.body);
          final String name = data['name'] ?? 'User';
          final String email = data['email'] ?? '';
          final String role = data['role'] ?? 'user';

          // Save new profile data to cache
          await SharedPrefsHelper.saveCachedProfile(name: name, email: email, role: role);
          emit(ProfileLoaded(name: name, email: email, role: role));
        } else {
          if (cached == null) {
            final errorData = jsonDecode(response.body);
            String errorMessage = 'Failed to load profile';
            if (errorData is Map) {
              if (errorData['error'] is Map && errorData['error']['message'] != null) {
                errorMessage = errorData['error']['message'];
              } else if (errorData['message'] != null) {
                errorMessage = errorData['message'];
              }
            }
            emit(ProfileFailure(error: errorMessage));
          }
        }
      } catch (e) {
        if (cached == null) {
          emit(ProfileFailure(error: 'Failed to load profile. You are offline.'));
        }
      }
    });
  }
}
