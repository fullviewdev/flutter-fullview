import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_fullview_platform_interface.dart';
import 'flutter_fullview_state.dart';
import 'data_redaction_widget.dart';

/// An implementation of [FlutterFullviewPlatform] that uses method channels.
class MethodChannelFlutterFullview extends FlutterFullviewPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_fullview');

  @override
  Future<void> attach() async {
    try {
      await methodChannel.invokeMethod('attach', {});
    } on PlatformException catch (e) {
      throw Exception('Failed to register: ${e.message}');
    }
  }

  @override
  Future<void> register({
    required String region,
    required String organisationId,
    required String userId,
    required String deviceId,
    required String name,
    required String email,
  }) async {
    methodChannel.setMethodCallHandler(_swiftHandler);
    try {
      await methodChannel.invokeMethod('register', {
        'region': region,
        'organisationId': organisationId,
        'userId': userId,
        'deviceId': deviceId,
        'name': name,
        'email': email,
      });
    } on PlatformException catch (e) {
      throw Exception('Failed to register: ${e.message}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await methodChannel.invokeMethod('logout');
    } on PlatformException catch (e) {
      throw Exception('Failed to logout: ${e.message}');
    }
  }

  @override
  Future<void> requestCoBrowse() async {
    try {
      await methodChannel.invokeMethod('requestCoBrowse');
    } on PlatformException catch (e) {
      throw Exception('Failed to requestCoBrowse: ${e.message}');
    }
  }

  @override
  Future<void> cancelCoBrowseRequest() async {
     try {
      await methodChannel.invokeMethod('cancelCoBrowseRequest');
    } on PlatformException catch (e) {
      throw Exception('Failed to cancelCoBrowseRequest: ${e.message}');
    }
  }
  @override
  Future<int?> getPositionInCoBrowseQueue() async {
    try {
      final position = methodChannel.invokeMethod<int>('getPositionInCoBrowseQueue');
      return position;
    } on PlatformException catch (e) {
      throw Exception('Failed to getPositionInCoBrowseQueue: ${e.message}');
    }
  }

  @override
  Future<FullviewState?> getState() async {
    try {
      final state = await methodChannel.invokeMethod<String>('getState');
      switch(state) {
        case "CO_BROWSE_REQUESTED": { return FullviewState.coBrowseRequested; }
        case "CO_BROWSE_ACTIVE": { return FullviewState.active; }
        case "CO_BROWSE_INVITATION": { return FullviewState.invitation; }
        case "IDLE": { return FullviewState.idle; }
        default: { return null; }
      }
    } on PlatformException catch (e) {
      throw Exception('Failed to getState: ${e.message}');
    }
  }


  Future<void> _swiftHandler(MethodCall call) async {
    switch (call.method) {
      case 'handleScreenshotRequest':
        final Map arguments = call.arguments;
        final String arg1 = arguments['fullSnapshot'];
        final data = await DataRedactionWidget.getAllCoordinatesAndSizes();
        await methodChannel.invokeMethod('takeScreenshot', {
          'fullSnapshot': arg1,
          'data': data,
        });
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'Method ${call.method} not implemented',
        );
    }
  }
}
