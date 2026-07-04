import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pgb_app/core/network/api_client.dart';
import 'package:pgb_app/core/constants/api_endpoints.dart';
import 'package:pgb_app/core/utils/shared_prefs_helper.dart';
import 'locations_event.dart';
import 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  LocationsBloc() : super(LocationsInitial()) {
    on<LoadLocations>((event, emit) async {
      emit(LocationsLoading());
      debugPrint('LocationsBloc: LoadLocations started');

      // 1. save location show
      final cached = await SharedPrefsHelper.getLocations();
      final deactivated = await SharedPrefsHelper.getDeactiLoc();
      final combinedCached = [...cached];
      for (final loc in deactivated) {
        if (!combinedCached.any((element) => element['id'] == loc['id'])) {
          combinedCached.add(loc);
        }
      }

      if (combinedCached.isNotEmpty) {
        debugPrint(
          'LocationsBloc: Emitting ${combinedCached.length} cached locations',
        );
        emit(LocationsLoaded(locations: combinedCached));
      }

      // lco show from api
      try {
        final rspns = await ApiClient.get(locationsURL);

        debugPrint('LocationsBloc Status Code: ${rspns.statusCode}');
        debugPrint('LocationsBloc rspns Body: ${rspns.body}');

        if (rspns.statusCode == 200 || rspns.statusCode == 201) {
          final decoded = jsonDecode(rspns.body);
          final List<dynamic> dataList = decoded['data'] ?? [];

          final List<Map<String, dynamic>> mappedLocations = dataList.map((
            item,
          ) {
            final double lat = (item['latitude'] as num?)?.toDouble() ?? 0.0;
            final double lng = (item['longitude'] as num?)?.toDouble() ?? 0.0;
            final double radiusM =
                (item['radius_m'] as num?)?.toDouble() ?? 0.0;

            return {
              'id': item['id'] ?? '',
              'name': item['location_name'] ?? '',
              'coords': '$lat, $lng',
              'radius': '${radiusM.round()} m radius',
              'isActive': item['is_active'] ?? false,
            };
          }).toList();

          // Save to shrprf
          await SharedPrefsHelper.saveLocations(mappedLocations);

          final freshDeactivated = await SharedPrefsHelper.getDeactiLoc();
          final combinedList = [...mappedLocations];
          for (final loc in freshDeactivated) {
            if (!combinedList.any((element) => element['id'] == loc['id'])) {
              combinedList.add(loc);
            }
          }

          emit(LocationsLoaded(locations: combinedList));
        } else {
          if (cached.isEmpty) {
            final errorData = jsonDecode(rspns.body);
            String errorMessage = 'Failed to load locations';
            if (errorData is Map) {
              if (errorData['error'] is Map &&
                  errorData['error']['message'] != null) {
                errorMessage = errorData['error']['message'];
              } else if (errorData['message'] != null) {
                errorMessage = errorData['message'];
              }
            }
            emit(LocationsFailure(error: errorMessage));
          }
        }
      } catch (e) {
        if (cached.isEmpty) {
          emit(
            LocationsFailure(
              error: 'Failed to load locations. You are offline.',
            ),
          );
        }
      }
    });

    on<UpdateLocation>((event, emit) async {
      emit(LocationUpdateLoading());
      debugPrint('LocationsBloc: UpdateLocation start');
      try {
        final url = '$locationsURL/${event.locId}';
        final requestBody = {
          'location_name': event.name,
          'latitude': event.latitude,
          'longitude': event.longitude,
          'radius_m': event.radiusM.toInt(),
          'is_active': event.isActive,
        };
        final rspns = await ApiClient.put(url, body: jsonEncode(requestBody));

        debugPrint('PUT rspns status code: ${rspns.statusCode}');
        debugPrint('PUT rspns body: ${rspns.body}');

        if (rspns.statusCode == 200 || rspns.statusCode == 201) {
          if (event.isActive) {
            // Activated again, remove from local deactivated cache
            await SharedPrefsHelper.rmvDeactiLoc(event.locId);
          } else {
            // Deactivated, add to local deactivated cache
            final locMap = {
              'id': event.locId,
              'name': event.name,
              'coords': '${event.latitude}, ${event.longitude}',
              'radius': '${event.radiusM.round()} m radius',
              'isActive': false,
            };
            await SharedPrefsHelper.addDeactiLoc(locMap);
          }
          emit(LocationUpdateSuccess());
        } else {
          final errorData = jsonDecode(rspns.body);
          String errorMessage = 'Failed to update location';
          if (errorData is Map) {
            if (errorData['error'] is Map &&
                errorData['error']['message'] != null) {
              errorMessage = errorData['error']['message'];
            } else if (errorData['message'] != null) {
              errorMessage = errorData['message'];
            }
          }
          emit(LocationUpdateFailure(error: errorMessage));
        }
      } catch (e) {
        debugPrint('Exception in UpdateLocation: $e');
        emit(LocationUpdateFailure(error: e.toString()));
      }
    });

    on<AddLocation>((event, emit) async {
      emit(LocationAddLoading());
      debugPrint('LocationsBloc: AddLocation started');
      try {
        final requestBody = {
          'location_name': event.name,
          'latitude': event.latitude,
          'longitude': event.longitude,
          'radius_m': event.radiusM.toInt(),
          'is_active': event.isActive,
        };
        final rspns = await ApiClient.post(
          locationsURL,
          body: jsonEncode(requestBody),
        );

        debugPrint('POST rspns status code: ${rspns.statusCode}');
        debugPrint('POST rspns body: ${rspns.body}');

        if (rspns.statusCode == 200 || rspns.statusCode == 201) {
          if (!event.isActive) {
            try {
              final decoded = jsonDecode(rspns.body);
              final newId = decoded['data']?['id'] ?? '';
              if (newId.isNotEmpty) {
                final locMap = {
                  'id': newId,
                  'name': event.name,
                  'coords': '${event.latitude}, ${event.longitude}',
                  'radius': '${event.radiusM.round()} m radius',
                  'isActive': false,
                };
                await SharedPrefsHelper.addDeactiLoc(locMap);
              }
            } catch (e) {
              debugPrint('Failed to parse new location ID: $e');
            }
          }
          emit(LocationAddSuccess());
        } else {
          final errorData = jsonDecode(rspns.body);
          String errorMessage = 'Failed to add location';
          if (errorData is Map) {
            if (errorData['error'] is Map &&
                errorData['error']['message'] != null) {
              errorMessage = errorData['error']['message'];
            } else if (errorData['message'] != null) {
              errorMessage = errorData['message'];
            }
          }
          emit(LocationAddFailure(error: errorMessage));
        }
      } catch (e) {
        debugPrint('Exception in AddLocation: $e');
        emit(LocationAddFailure(error: e.toString()));
      }
    });

    on<DeleteLocation>((event, emit) async {
      emit(LocationDeleteLoading());
      debugPrint('LocationsBloc: Delete Location start');
      try {
        final url = '$locationsURL/${event.locId}';
        final rspns = await ApiClient.delete(url);

        debugPrint('dlt rspns status code: ${rspns.statusCode}');
        debugPrint('dlt rspns body: ${rspns.body}');

        if (rspns.statusCode == 200 || rspns.statusCode == 201) {
          await SharedPrefsHelper.rmvDeactiLoc(event.locId);
          emit(LocationDeleteSuccess());
        } else {
          final errorData = jsonDecode(rspns.body);
          String errorMessage = 'Failed to delete location';
          if (errorData is Map) {
            if (errorData['error'] is Map &&
                errorData['error']['message'] != null) {
              errorMessage = errorData['error']['message'];
            } else if (errorData['message'] != null) {
              errorMessage = errorData['message'];
            }
          }
          emit(LocationDeleteFailure(error: errorMessage));
        }
      } catch (e) {
        debugPrint('Exception in DeleteLocation: $e');
        emit(LocationDeleteFailure(error: e.toString()));
      }
    });
  }
}
