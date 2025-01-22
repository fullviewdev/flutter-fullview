import 'flutter_fullview_platform_interface.dart';
import 'flutter_fullview_state.dart';
import 'flutter_fullview_region.dart';
import 'dart:io';

class FlutterFullview {
  Future<void> attach() {
    // iOS doesn't need to do anything with attach
    if (Platform.isIOS) {
      return Future.value();
    } else {
      return FlutterFullviewPlatform.instance.attach();
    }
  }

  Future<void> register({
    required FullviewRegion region,
    required String organisationId,
    required String userId,
    required String deviceId,
    required String name,
    required String email,
  }) {
    return FlutterFullviewPlatform.instance.register(
      region: region.name,
      organisationId: organisationId,
      userId: userId,
      deviceId: deviceId,
      name: name,
      email: email,
    );
  }

  Future<void> logout() {
    return FlutterFullviewPlatform.instance.logout();
  }

  Future<void> requestCoBrowse() {
    return FlutterFullviewPlatform.instance.requestCoBrowse();
  }

  Future<void> cancelCoBrowseRequest() {
    return FlutterFullviewPlatform.instance.cancelCoBrowseRequest();
  }

  Future<int?> getPositionInCoBrowseQueue() {
    return FlutterFullviewPlatform.instance.getPositionInCoBrowseQueue();
  }

  Future<FullviewState?> getState() {
    return FlutterFullviewPlatform.instance.getState();
  }
}
