import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pgb_app/core/utils/shared_prefs_helper.dart';

class GeofenceManager {
  static final GeofenceManager _instance = GeofenceManager._internal();
  factory GeofenceManager() => _instance;
  GeofenceManager._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<Position>? _positionSubscription;
  final Set<String> _insideLocationIds = {};

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification clicked: ${details.payload}');
      },
    );

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  Future<void> startMonitoring() async {
    // 1. Cancel previous stream subscription if active
    await stopMonitoring();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('GeofenceManager: Location permission denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('GeofenceManager: Location permission permanently denied.');
      return;
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _checkGeofences(position);
          },
          onError: (e) {
            debugPrint('GeofenceManager error: $e');
          },
        );
  }

  Future<void> stopMonitoring() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _insideLocationIds.clear();
  }

  Future<void> _checkGeofences(Position position) async {
    final locations = await SharedPrefsHelper.getLocations();
    if (locations.isEmpty) return;

    for (final loc in locations) {
      final String id = loc['id'] ?? '';
      final String name = loc['name'] ?? '';
      final String coords = loc['coords'] ?? '';
      final bool isActive = loc['isActive'] ?? false;

      if (id.isEmpty || !isActive || coords.isEmpty) continue;

      // Extract coordinates
      final parts = coords.split(',');
      if (parts.length < 2) continue;
      final double? lat = double.tryParse(parts[0].trim());
      final double? lng = double.tryParse(parts[1].trim());

      if (lat == null || lng == null) continue;

      // Extract radius (format: "150 m radius" or just double value)
      final String radiusStr = loc['radius'] ?? '';
      double radius = 150.0;
      if (radiusStr.isNotEmpty) {
        final matches = RegExp(r'\d+').firstMatch(radiusStr);
        if (matches != null) {
          radius = double.tryParse(matches.group(0)!) ?? 150.0;
        }
      }

      // Calculate distance
      final double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        lat,
        lng,
      );

      final bool isInside = distance <= radius;
      final bool wasInside = _insideLocationIds.contains(id);

      if (isInside && !wasInside) {
        _insideLocationIds.add(id);
        await _showNotification(id, name);
      } else if (!isInside && wasInside) {
        _insideLocationIds.remove(id);
      }
    }
  }

  Future<void> _showNotification(String id, String locationName) async {
    const androidDetails = AndroidNotificationDetails(
      'geofence_channel',
      'Geofence alerts',
      channelDescription:
          'Notifications triggered when entering location radius',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id: id.hashCode,
      title: 'Geofence Entry Detected',
      body: 'You entered $locationName',
      notificationDetails: details,
      payload: id,
    );
  }
}
