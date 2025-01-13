# Flutter Developer Documentation

**Current version:** 0.9.7

Flutter SDK supports following platforms:

- Flutter
  - Android
  - iOS

Other platforms supported:

  - Android
  - iOS
  - React Native

Soon-supported platforms:

  - Ionic
  - Cordova

## Installation

### Add the plugin to pubspec.yaml file

- Open your Flutter project's *pubspec.yaml* file.
- Under the *dependencies* section, add `flutter_fullview`:

```yaml
dependencies:
  flutter_fullview: ^latest_version
```

- Save the file and run: `flutter pub get`

## Configuration

### iOS Requirements
- Add the following permissions in your *app's xcodeproject Info.plist*, if you don't already have them:
	- **NSMicrophoneUsageDescription**
	- **NSCameraUsageDescription**
	- **UIBackgroundModes** **voip**


## Usage

Add `import 'package:flutter_fullview/flutter_fullview.dart';` and then use the different functions in ** FullviewSDK** to configure and start the SDK.

A minimal implementation looks like the following:

```dart
import 'package:flutter_fullview/flutter_fullview.dart';

// ...

final _flutterFullviewPlugin = FlutterFullview();

try {
  await _flutterFullviewPlugin.attach(); // Ideally this should be run as soon as the app starts.
} catch (e, stackTrace) {
  log("An error occurred", error: e, stackTrace: stackTrace, name: "Example");
}

try {
  await _flutterFullviewPlugin.register(
    organisationId: '<organisation_id>', 
    userId: '<user_id>', 
    deviceId: '<device_id>', 
    name: '<name>', 
    email: '<email>'
  );
} catch (e) {
  log("An error occurred while starting SDK", error: e, name: "Example");
}
```

*Note*: `device_id` must be a correct unique UUID. 

And use `_flutterFullviewPlugin.logout()` to disconnect and disable the SDK.
 
## Additional features usage
- [Data Redaction](data_redaction.md)
- [Screen Sharing](screen_share.md) (additional configuration required for iOS)


## Fullview SDK API

- `Future<void> attach()`

   Attaches fullview SDK to the host app. Should be called as soon as the app starts.

- `Future<void> register({
    required String organisationId,
    required String userId,
    required String deviceId,
    required String name,
    required String email,
  })`

	Registers user to be available in Fullview.

- `Future<void> logout()`

	Logs out the current user from Fullview.

- `Future<void> requestCoBrowse()`

	Puts the user into a waiting queue requesting help from agents.

- `Future<void> cancelCoBrowseRequest()`

	Remove the user from the waiting queue.

- `Future<int> getPositionInCoBrowseQueue()`

	Position in the request cobrowse queue. 0 if there's no request/queue.

- `Future<FullviewState> getState()`

	Current state of the SDK. Used to update the UI if necessary.
