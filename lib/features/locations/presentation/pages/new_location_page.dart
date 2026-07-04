import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pgb_app/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:pgb_app/features/locations/presentation/bloc/locations_event.dart';
import 'package:pgb_app/features/locations/presentation/bloc/locations_state.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NewLocationPage extends StatefulWidget {
  const NewLocationPage({super.key});

  @override
  State<NewLocationPage> createState() => _NewLocationPageState();
}

class _NewLocationPageState extends State<NewLocationPage> {
  double _radius = 150.0;
  bool _isActive = true;

  GoogleMapController? _mapCtrl;
  late final TextEditingController _latCtrl;
  late final TextEditingController _lngCtrl;
  late final TextEditingController _nameCtrl;
  LatLng _center = const LatLng(23.82049184570468, 90.35792993058868);
  bool _isUpdatingFromMap = false;
  bool _isOffline = false;
  late StreamSubscription<List<ConnectivityResult>> _connectSubs;

  @override
  void initState() {
    super.initState();
    _latCtrl = TextEditingController(text: _center.latitude.toStringAsFixed(6));
    _lngCtrl = TextEditingController(
      text: _center.longitude.toStringAsFixed(6),
    );
    _nameCtrl = TextEditingController();
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
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _nameCtrl.dispose();
    _connectSubs.cancel();
    super.dispose();
  }

  void _Gmap(GoogleMapController controller) {
    _mapCtrl = controller;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<LocationsBloc, LocationsState>(
      listener: (context, state) {
        if (state is LocationAddSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location saved successfully')),
          );
          context.read<LocationsBloc>().add(LoadLocations());
          Navigator.pop(context);
        } else if (state is LocationAddFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
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
                          'New location',
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
                              onMapCreated: _Gmap,
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
                                  _isUpdatingFromMap = true;
                                  _latCtrl.text = position.target.latitude
                                      .toStringAsFixed(6);
                                  _lngCtrl.text = position.target.longitude
                                      .toStringAsFixed(6);
                                  _isUpdatingFromMap = false;
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
                        onTap: () {},
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
                      decoration: const InputDecoration(
                        hintText: 'Downtown Branch',
                      ),
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
                                  if (_isUpdatingFromMap) return;
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
                        // Longitude
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
                                  if (_isUpdatingFromMap) return;
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

                    // Geofence radius slider
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

                    // Active Toggle
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
                    SizedBox(height: 40.h),

                    // Save location Button
                    ElevatedButton(
                      onPressed: (state is LocationAddLoading || _isOffline)
                          ? null
                          : () {
                              if (_nameCtrl.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter a location name',
                                    ),
                                  ),
                                );
                                return;
                              }
                              final lat = double.tryParse(_latCtrl.text);
                              final lng = double.tryParse(_lngCtrl.text);
                              if (lat == null || lng == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please enter valid coordinates',
                                    ),
                                  ),
                                );
                                return;
                              }

                              context.read<LocationsBloc>().add(
                                AddLocation(
                                  name: _nameCtrl.text.trim(),
                                  latitude: lat,
                                  longitude: lng,
                                  radiusM: _radius,
                                  isActive: _isActive,
                                ),
                              );
                            },
                      child: state is LocationAddLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Save location',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
