import 'package:flutter_test/flutter_test.dart';
import 'package:flutteruikit/flutteruikit.dart';
import 'package:flutteruikit/flutteruikit_platform_interface.dart';
import 'package:flutteruikit/flutteruikit_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutteruikitPlatform
    with MockPlatformInterfaceMixin
    implements FlutteruikitPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutteruikitPlatform initialPlatform = FlutteruikitPlatform.instance;

  test('$MethodChannelFlutteruikit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutteruikit>());
  });

  test('getPlatformVersion', () async {
    Flutteruikit flutteruikitPlugin = Flutteruikit();
    MockFlutteruikitPlatform fakePlatform = MockFlutteruikitPlatform();
    FlutteruikitPlatform.instance = fakePlatform;

    expect(await flutteruikitPlugin.getPlatformVersion(), '42');
  });
}
