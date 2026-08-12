# CampusConnect Mobile

Flutter mobile client for the SWE 404 Module 8 CampusConnect project.

## Features

- Fetch campus events from the shared CampusConnect API.
- Register attendance from the mobile application.
- Refresh event data.

## Setup

```bash
flutter pub get
flutter run
```

The Android emulator uses `10.0.2.2` to reach the host computer running the API. For a physical phone, update `baseUrl` in `lib/main.dart` to the development machine's LAN IP.

## API dependency

The mobile app consumes the API exposed by `campusconnect-web` on port 5000.

## Licence

This mobile component is distributed as part of the MIT-licensed CampusConnect Project A.
