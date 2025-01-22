import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_fullview/flutter_fullview.dart';
import 'package:flutter_fullview/flutter_fullview_platform_interface.dart';
import 'package:flutter_fullview/flutter_fullview_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterFullviewPlatform
    with MockPlatformInterfaceMixin
    implements FlutterFullviewPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterFullviewPlatform initialPlatform = FlutterFullviewPlatform.instance;

  test('$MethodChannelFlutterFullview is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterFullview>());
  });

  test('getPlatformVersion', () async {
    FlutterFullview flutterFullviewPlugin = FlutterFullview();
    MockFlutterFullviewPlatform fakePlatform = MockFlutterFullviewPlatform();
    FlutterFullviewPlatform.instance = fakePlatform;

    expect(await flutterFullviewPlugin.getPlatformVersion(), '42');
  });
}
