// Packages
import 'flutteruikit_platform_interface.dart';

// Exports
export 'widgets/icnbutton.dart';
export 'widgets/linkbutton.dart';
export 'screens/barcodescanner.dart';


class Flutteruikit {
  Future<String?> getPlatformVersion() {
    return FlutteruikitPlatform.instance.getPlatformVersion();
  }
}
