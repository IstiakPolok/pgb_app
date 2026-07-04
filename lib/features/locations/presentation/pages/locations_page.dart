import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pgb_app/features/locations/presentation/pages/new_location_page.dart';
import 'package:pgb_app/features/locations/presentation/pages/edit_location_page.dart';
import 'package:pgb_app/features/locations/presentation/bloc/locations_bloc.dart';
import 'package:pgb_app/features/locations/presentation/bloc/locations_event.dart';
import 'package:pgb_app/features/locations/presentation/bloc/locations_state.dart';
import '../../../../core/theme/app_theme.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  String _srchQury = '';
  final _srchCtrl = TextEditingController();

  String _formatCoords(String coords) {
    final parts = coords.split(',');
    if (parts.length < 2) return coords;
    final lat = double.tryParse(parts[0].trim());
    final lng = double.tryParse(parts[1].trim());
    if (lat == null || lng == null) return coords;
    return '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
  }

  @override
  void dispose() {
    _srchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final iconBgcolor = isdark
        ? AppTheme.darkcolorprimarylight
        : AppTheme.lightcolorprimarylight;
    final inactiveBg = isdark
        ? AppTheme.darkcolorinactivebadge
        : AppTheme.lightcolorinactivebadge;

    return BlocProvider<LocationsBloc>(
      create: (context) => LocationsBloc()..add(LoadLocations()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<LocationsBloc, LocationsState>(
            builder: (context, state) {
              if (state is LocationsLoading || state is LocationsInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is LocationsFailure) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          color: colorScheme.error,
                          size: 48.r,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          state.error,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<LocationsBloc>().add(LoadLocations());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is LocationsLoaded) {
                final fltrLoc = state.locations.where((loc) {
                  final name = (loc['name'] as String).toLowerCase();
                  return name.contains(_srchQury.toLowerCase());
                }).toList();

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Locations',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Container(
                            width: 40.r,
                            height: 40.r,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.add,
                                color: colorScheme.surface,
                                size: 20.r,
                              ),
                              onPressed: () {
                                final bloc = context.read<LocationsBloc>();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                      value: bloc,
                                      child: const NewLocationPage(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      TextFormField(
                        controller: _srchCtrl,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 15.sp,
                        ),
                        onChanged: (val) {
                          setState(() {
                            _srchQury = val;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colorScheme.primaryContainer,
                          hintText: 'Search locations',
                          prefixIcon: Icon(Icons.search, size: 22.r),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<LocationsBloc>().add(LoadLocations());
                          },
                          child: fltrLoc.isEmpty
                              ? ListView(
                                  children: [
                                    SizedBox(height: 100.h),
                                    Center(
                                      child: Text(
                                        'No locations found',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  itemCount: fltrLoc.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 16.h),
                                  itemBuilder: (context, index) {
                                    final item = fltrLoc[index];
                                    final bool isActive =
                                        item['isActive'] ?? false;

                                    return GestureDetector(
                                      onTap: () {
                                        final radiusVal =
                                            double.tryParse(
                                              item['radius'].split(' ').first,
                                            ) ??
                                            150.0;
                                        final locationsBloc = context
                                            .read<LocationsBloc>();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                BlocProvider.value(
                                                  value: locationsBloc,
                                                  child: EditLocationPage(
                                                    locId: item['id'] ?? '',
                                                    initialName: item['name'],
                                                    codi: item['coords'],
                                                    locRadius: radiusVal,
                                                    locActive: isActive,
                                                  ),
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(16.r),
                                        decoration: BoxDecoration(
                                          color: colorScheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          border: Border.all(
                                            color: colorScheme.outline,
                                            width: 1.r,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.r),
                                              decoration: BoxDecoration(
                                                color: isActive
                                                    ? iconBgcolor
                                                    : inactiveBg,
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                size: 30.r,
                                                color: isActive
                                                    ? colorScheme.primary
                                                    : colorScheme
                                                          .onSurfaceVariant,
                                              ),
                                            ),
                                            SizedBox(width: 16.w),

                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item['name'],
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          colorScheme.onSurface,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.explore_outlined,
                                                        size: 14.r,
                                                        color: colorScheme
                                                            .onSurfaceVariant,
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      Expanded(
                                                        child: Text(
                                                          _formatCoords(
                                                            item['coords'],
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 13.sp,
                                                            color: colorScheme
                                                                .onSurfaceVariant,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8.h),

                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8.w,
                                                              vertical: 4.h,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: colorScheme
                                                              .surface,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6.r,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          item['radius'],
                                                          style: TextStyle(
                                                            fontSize: 11.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: colorScheme
                                                                .onSurfaceVariant,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 8.w),

                                                      Container(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 8.w,
                                                              vertical: 4.h,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: isActive
                                                              ? colorScheme
                                                                    .primary
                                                              : colorScheme
                                                                    .surface,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6.r,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          isActive
                                                              ? 'Active'
                                                              : 'Inactive',
                                                          style: TextStyle(
                                                            fontSize: 11.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: isActive
                                                                ? colorScheme
                                                                      .surface
                                                                : colorScheme
                                                                      .onSurfaceVariant,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 14.r,
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        floatingActionButton: Builder(
          builder: (scaffoldContext) => FloatingActionButton(
            onPressed: () {
              final bloc = scaffoldContext.read<LocationsBloc>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: bloc,
                    child: const NewLocationPage(),
                  ),
                ),
              );
            },
            backgroundColor: colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(Icons.add, size: 28.r, color: colorScheme.surface),
          ),
        ),
      ),
    );
  }
}
