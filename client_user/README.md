# airport_taxi_sharing_user_client

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Local API server

The client defaults to the local server on port `3001`: Android emulator uses
`http://10.0.2.2:3001/api/`; other platforms use `http://localhost:3001/api/`.
Start the backend in `server` before running the client. Android debug builds
allow HTTP for local development.

For a physical device, use the server computer's LAN IP on the same network:

```sh
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:3001/api/
```

Replace the example IP with your computer's address. `API_BASE_URL` can also
select a different host or port; include the `/api/` path. Restart the app after
changing this setting.
