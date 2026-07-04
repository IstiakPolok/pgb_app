# FieldTrack (PGB App) - Flutter Technical Assessment

A Flutter application built as a technical assessment for Progressive Byte Ltd. It implements secure authentication, interactive location management, geofencing with local notifications, and an offline-first Todo checklist with automatic background synchronization on network restoration.

---

## Project Setup Steps

1. **Prerequisites**:
   * Flutter SDK installed (v3.12.2 or higher is recommended).
   * Android Studio or VS Code with Dart & Flutter extension plugins configured.
   * An Android device or emulator running API level 26 (Android 8.0) or higher.

2. **Retrieve the Project**:
   * Clone the project repository to your local workspace.

3. **Install Dependencies**:
   * Navigate to the project root directory and run:
     ```bash
     flutter pub get
     ```

---

## How to Run the App

1. **Running in Debug Mode**:
   * Connect your physical Android device (with USB debugging enabled) or start an emulator.
   * Run the following command in the project root:
     ```bash
     flutter run
     ```

2. **Compiling the Production Release APK**:
   * Run the build command to generate a release APK:
     ```bash
     flutter build apk
     ```
   * The generated release binary will be located at:
     `build/app/outputs/flutter-apk/app-release.apk`

---

## Environment & Configuration Notes

- **API Base URL Configuration**: 
  * The application communicates with the backend API. The endpoint URLs are centralized inside the project at [api_endpoints.dart](lib/core/constants/api_endpoints.dart).
  - Modify the `baseUrl` variable there if you need to redirect the application to a different environment or a local hosting server.
- **Local Persistence Configuration**:
  * SharedPreferences is used to store access/refresh tokens, cached tasks, active geofence locations, and pending sync operations.

---

## Folder Structure Overview

The application follows the principles of **Clean Architecture**, separating components into presentation, domain, and data/core layers:

```text
lib/
├── core/
│   ├── constants/       # Centralized API endpoints (api_endpoints.dart)
│   ├── network/         # ApiClient (automated token refresh wrappers)
│   ├── router/          # AppRouter config (GoRouter configuration)
│   ├── services/        # Singleton managers: GeofenceManager, SyncManager
│   ├── theme/           # App spacer definitions, theme templates, asset paths
│   └── utils/           # SharedPrefsHelper (local storage management)
└── features/
    ├── auth/            # Auth BLoC state, Login and Registration pages
    ├── locations/       # Locations BLoC logic, List, Add, Edit, Delete pages
    ├── main/            # Main Navigation Scaffold and SplashPage
    ├── profile/         # Profile details and Sign Out page
    ├── sync/            # Manual Sync triggers & action log list
    └── tasks/           # Todo Checklist BLoC state and Tasks checklist page
```

---

## Explanation of the Offline Sync Approach

The offline sync architecture is built on top of a global connectivity listener class (`SyncManager`):

1. **Local Action Caching**: When the device is offline, updating a checklist item updates the UI immediately. `TasksBloc` catches the failure and logs the change to SharedPreferences as a pending action (retaining task ID, status, and update timestamp).
2. **Connectivity Change Detection**: The `SyncManager` listens to connectivity transitions via `connectivity_plus`. When a restoration to an active network is detected, it automatically initiates the synchronization process.
3. **Background Sync Action**: The manager aggregates all queued local changes and submits a single `POST` request containing all modifications to the `/api/v1/todos/sync` endpoint.
4. **Conflict Mitigation**: Upon a successful sync request, the synced item IDs are cleared from local pending storage. The `TasksBloc` subscribes to the `SyncManager` status stream and automatically reloads the checklist from the server once background synchronization is done.

---

## Explanation of the Geofence and Notification Approach

Geofencing is managed dynamically via `GeofenceManager`:

1. **Location Tracking**: Uses `Geolocator.getPositionStream` to continuously track coordinates using high accuracy parameters and a 10-meter change filter.
2. **Proximity Checks**: Loops through the stored geofences in SharedPreferences and computes the device distance using `Geolocator.distanceBetween()`.
3. **Deduplicated Local Alerts**: Utilizes an in-memory set (`_insideLocationIds`) to verify state transitions. A local notification is fired via `flutter_local_notifications` only when the user transitions from outside the radius to inside it (avoiding repetitive alert triggers). Exiting the radius cleanses the location ID from the set.

---

## Any Assumptions or Known Limitations

- **Background Execution Limits**: Due to background execution restrictions in newer Android versions, location updates might suspend when the app is minimized unless a Foreground Service (with the corresponding notification and runtime permissions) is fully declared.
- **Geofence Radius Calibration**: Distance calculation relies strictly on GPS coordinate accuracy, which can vary depending on device hardware and environmental obstructions.
