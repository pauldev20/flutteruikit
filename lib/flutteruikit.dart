// Packages
import 'flutteruikit_platform_interface.dart';

// Exports
export 'widgets/icnbutton.dart';
export 'widgets/linkbutton.dart';
export 'screens/barcodescanner.dart';
export 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart' show BarcodeFormat;


class Flutteruikit {
  Future<String?> getPlatformVersion() {
    return FlutteruikitPlatform.instance.getPlatformVersion();
  }
}
