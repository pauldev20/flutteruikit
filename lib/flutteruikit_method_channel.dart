import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutteruikit_platform_interface.dart';

/// An implementation of [FlutteruikitPlatform] that uses method channels.
class MethodChannelFlutteruikit extends FlutteruikitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutteruikit');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
