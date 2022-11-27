import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutteruikit_method_channel.dart';

abstract class FlutteruikitPlatform extends PlatformInterface {
  /// Constructs a FlutteruikitPlatform.
  FlutteruikitPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutteruikitPlatform _instance = MethodChannelFlutteruikit();

  /// The default instance of [FlutteruikitPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutteruikit].
  static FlutteruikitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutteruikitPlatform] when
  /// they register themselves.
  static set instance(FlutteruikitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
