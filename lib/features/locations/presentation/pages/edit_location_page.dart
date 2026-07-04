import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pgb_app/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:pgb_app/features/locations/presentation/bloc/locations_event.dart';
import 'package:pgb_app/features/locations/presentation/bloc/locations_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';

class EditLocationPage extends StatefulWidget {
  final String locId;
  final String initialName;
  final String codi;
  final double locRadius;
  final bool locActive;

  const EditLocationPage({
    super.key,
    required this.locId,
    required this.initialName,
    required this.codi,
    required this.locRadius,
    required this.locActive,
  });

  @override
  State<EditLocationPage> createState() => _EditLocationPageState();
}

class _EditLocationPageState extends State<EditLocationPage> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _latCtrl;
  late final TextEditingController _lngCtrl;
  late double _radius;
  late bool _isActive;

  GoogleMapController? _mapCtrl;
  late LatLng _center;
  bool _isUpMap = false;
  bool _isOffline = false;
  late StreamSubscription<List<ConnectivityResult>> _connectSubs;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);

    final parts = widget.codi.split(',');
    final double lat = double.tryParse(parts.first.trim()) ?? 23.820492;
    final double lng =
        (parts.length > 1 ? double.tryParse(parts[1].trim()) : null) ??
        90.357930;
    _center = LatLng(lat, lng);

    _latCtrl = TextEditingController(text: _center.latitude.toStringAsFixed(6));
    _lngCtrl = TextEditingController(
      text: _center.longitude.toStringAsFixed(6),
    );

    _radius = widget.locRadius.clamp(50.0, 500.0);
    _isActive = widget.locActive;

    _checkConnectivity();
    _connectSubs = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      setState(() {
        _isOffline = results.contains(ConnectivityResult.none);
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final results = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = results.contains(ConnectivityResult.none);
    });
  }

  @override
  void dispose() {
    _mapCtrl?.dispose();
    _nameCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _connectSubs.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapCtrl = controller;
  }

  Future<void> _getCurrentLocation() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fetching current location...'),
          duration: Duration(seconds: 2),
        ),
      );

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied.';
      }

      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
        _latCtrl.text = position.latitude.toStringAsFixed(6);
        _lngCtrl.text = position.longitude.toStringAsFixed(6);
      });

      _mapCtrl?.animateCamera(CameraUpdate.newLatLng(_center));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location updated to current position')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LocationsBloc, LocationsState>(
          listener: (context, state) {
            if (state is LocationUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location updated successfully')),
              );
              context.read<LocationsBloc>().add(LoadLocations());
              Navigator.pop(context);
            } else if (state is LocationUpdateFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            } else if (state is LocationDeleteSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location deleted successfully')),
              );
              context.read<LocationsBloc>().add(LoadLocations());
              Navigator.pop(context);
            } else if (state is LocationDeleteFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: colorScheme.outline,
                              width: 1.r,
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.chevron_left_rounded,
                              color: colorScheme.onSurface,
                              size: 24.r,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          'Edit location',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: SizedBox(
                        height: 180.h,
                        child: Stack(
                          children: [
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: _center,
                                zoom: 15,
                              ),
                              onMapCreated: _onMapCreated,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              mapType: MapType.normal,
                              circles: {
                                Circle(
                                  circleId: const CircleId('geofence'),
                                  center: _center,
                                  radius: _radius,
                                  fillColor: colorScheme.primary.withAlpha(30),
                                  strokeColor: colorScheme.primary.withAlpha(
                                    120,
                                  ),
                                  strokeWidth: 2,
                                ),
                              },
                              gestureRecognizers:
                                  <Factory<OneSequenceGestureRecognizer>>{
                                    Factory<OneSequenceGestureRecognizer>(
                                      () => EagerGestureRecognizer(),
                                    ),
                                  },
                              onCameraMove: (position) {
                                setState(() {
                                  _center = position.target;
                                  _isUpMap = true;
                                  _latCtrl.text = position.target.latitude
                                      .toStringAsFixed(6);
                                  _lngCtrl.text = position.target.longitude
                                      .toStringAsFixed(6);
                                  _isUpMap = false;
                                });
                              },
                            ),
                            IgnorePointer(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: Icon(
                                    Icons.location_on_rounded,
                                    size: 32.r,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    DottedBorder(
                      options: RoundedRectDottedBorderOptions(
                        color: colorScheme.primary,
                        strokeWidth: 1.r,
                        dashPattern: const [6, 4],
                        radius: Radius.circular(12.r),
                        padding: EdgeInsets.zero,
                      ),
                      child: InkWell(
                        onTap: _getCurrentLocation,
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          width: double.infinity,
                          height: 50.h,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.explore_outlined,
                                size: 20.r,
                                color: colorScheme.primary,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Use my current location',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    Text(
                      'Location name',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _nameCtrl,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 15.sp,
                      ),
                      decoration: InputDecoration(hintText: 'Downtown Branch'),
                    ),
                    SizedBox(height: 20.h),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Latitude',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _latCtrl,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 15.sp,
                                ),
                                decoration: const InputDecoration(
                                  hintText: '25.2048',
                                ),
                                onChanged: (val) {
                                  if (_isUpMap) return;
                                  final lat = double.tryParse(val);
                                  if (lat != null) {
                                    setState(() {
                                      _center = LatLng(lat, _center.longitude);
                                      _mapCtrl?.animateCamera(
                                        CameraUpdate.newLatLng(_center),
                                      );
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Longitude',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade700,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextFormField(
                                controller: _lngCtrl,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 15.sp,
                                ),
                                decoration: const InputDecoration(
                                  hintText: '55.2708',
                                ),
                                onChanged: (val) {
                                  if (_isUpMap) return;
                                  final lng = double.tryParse(val);
                                  if (lng != null) {
                                    setState(() {
                                      _center = LatLng(_center.latitude, lng);
                                      _mapCtrl?.animateCamera(
                                        CameraUpdate.newLatLng(_center),
                                      );
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Geofence radius',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          '${_radius.round()} m',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4.h,
                        activeTrackColor: colorScheme.primary,
                        inactiveTrackColor: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                        thumbColor: colorScheme.primary,
                        overlayColor: colorScheme.primary.withAlpha(30),
                      ),
                      child: Slider(
                        value: _radius,
                        min: 50.0,
                        max: 500.0,
                        onChanged: (value) {
                          setState(() {
                            _radius = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Active',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Workers can check in here',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Switch.adaptive(
                          value: _isActive,
                          activeTrackColor: colorScheme.primary,
                          inactiveTrackColor: colorScheme.onSurfaceVariant,
                          onChanged: (value) {
                            setState(() {
                              _isActive = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),

                    ElevatedButton(
                      onPressed: (state is LocationUpdateLoading || _isOffline)
                          ? null
                          : () {
                              context.read<LocationsBloc>().add(
                                UpdateLocation(
                                  locId: widget.locId,
                                  name: _nameCtrl.text,
                                  latitude: _center.latitude,
                                  longitude: _center.longitude,
                                  radiusM: _radius,
                                  isActive: _isActive,
                                ),
                              );
                            },
                      child: state is LocationUpdateLoading
                          ? SizedBox(
                              width: 20.r,
                              height: 20.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              'Update location',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    SizedBox(height: 16.h),

                    OutlinedButton(
                      onPressed: (state is LocationDeleteLoading || _isOffline)
                          ? null
                          : () {
                              context.read<LocationsBloc>().add(
                                DeleteLocation(locId: widget.locId),
                              );
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(
                          color: colorScheme.error.withAlpha(128),
                          width: 1.5.w,
                        ),
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: state is LocationDeleteLoading
                          ? SizedBox(
                              width: 20.r,
                              height: 20.r,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.error,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_outline_rounded,
                                  size: 20.r,
                                  color: colorScheme.error,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Delete location',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.error,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
