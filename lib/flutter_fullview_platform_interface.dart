import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_fullview_method_channel.dart';
import 'flutter_fullview_state.dart';

abstract class FlutterFullviewPlatform extends PlatformInterface {
  /// Constructs a FlutterFullviewPlatform.
  FlutterFullviewPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFullviewPlatform _instance = MethodChannelFlutterFullview();

  /// The default instance of [FlutterFullviewPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFullview].
  static FlutterFullviewPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFullviewPlatform] when
  /// they register themselves.
  static set instance(FlutterFullviewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> attach() {
    throw UnimplementedError('attach(...) has not been implemented.');
  }

  Future<void> register({
    required String region,
    required String organisationId,
    required String userId,
    required String deviceId,
    required String name,
    required String email,
  }) {
    throw UnimplementedError('register(...) has not been implemented.');
  }

  Future<void> logout(){
    throw UnimplementedError('logout() has not been implemented.');
  }

  Future<void> requestCoBrowse() {
    throw UnimplementedError('requestCoBrowse() has not been implemented.');
  }

  Future<void> cancelCoBrowseRequest() {
    throw UnimplementedError('cancelCoBrowseRequest() has not been implemented.');
  }

  Future<int?> getPositionInCoBrowseQueue() {
     throw UnimplementedError('getPositionInCoBrowseQueue() has not been implemented.');
  }

  Future<FullviewState?> getState() {
    throw UnimplementedError('getState() has not been implemented.');
  }
}
