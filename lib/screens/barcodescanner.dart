// Packages
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:torch_light/torch_light.dart';
import 'package:flutteruikit/urtils/helpers.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

// Exports
export 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart' show Barcode;


// Overlay
class ScannerOverlay extends ShapeBorder {
  ScannerOverlay({
    required this.cutOutRect,
    this.borderColor = Colors.red,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 40),
    this.borderRadius = 0,
    this.borderLength = 40,
  }) : assert(borderLength <= cutOutRect.width / 2 + borderWidth * 2,
            "Border can't be larger than ${cutOutRect.width / 2 + borderWidth * 2}");

  final Rect cutOutRect;
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(10);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    Path getLeftTopPath(Rect rect) {
      return Path()
        ..moveTo(rect.left, rect.bottom)
        ..lineTo(rect.left, rect.top)
        ..lineTo(rect.right, rect.top);
    }

    return getLeftTopPath(rect)
      ..lineTo(
        rect.right,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.bottom,
      )
      ..lineTo(
        rect.left,
        rect.top,
      );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final double width = rect.width;
    final double borderWidthSize = width / 2;
    final double newBorderLength =
        borderLength > cutOutRect.width / 2 + borderWidth * 2
            ? borderWidthSize / 2
            : borderLength;

    final Paint backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final Paint boxPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    canvas
      ..saveLayer(
        rect,
        backgroundPaint,
      )
      ..drawRect(
        rect,
        backgroundPaint,
      )
      // Draw top right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - newBorderLength,
          cutOutRect.top,
          cutOutRect.right,
          cutOutRect.top + newBorderLength,
          topRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw top left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.top,
          cutOutRect.left + newBorderLength,
          cutOutRect.top + newBorderLength,
          topLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom right corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.right - newBorderLength,
          cutOutRect.bottom - newBorderLength,
          cutOutRect.right,
          cutOutRect.bottom,
          bottomRight: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      // Draw bottom left corner
      ..drawRRect(
        RRect.fromLTRBAndCorners(
          cutOutRect.left,
          cutOutRect.bottom - newBorderLength,
          cutOutRect.left + newBorderLength,
          cutOutRect.bottom,
          bottomLeft: Radius.circular(borderRadius),
        ),
        borderPaint,
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          cutOutRect,
          Radius.circular(borderRadius),
        ),
        boxPaint,
      )
      ..restore();
  }

  @override
  ShapeBorder scale(double t) {
    return ScannerOverlay(
      cutOutRect: cutOutRect,
      borderColor: borderColor,
      borderWidth: borderWidth,
      overlayColor: overlayColor,
    );
  }
}

// Screen
class BarcodeScannerScreen extends StatefulWidget {
  final void Function(Barcode barcode)? onScan;
  final List<BarcodeFormat> formats;
  final bool singleScan;

  const BarcodeScannerScreen({
    super.key,
    required this.onScan, 
    this.singleScan = true, 
    this.formats = const [BarcodeFormat.all]
  });

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  late BarcodeScanner _barcodeScanner;
  List<CameraDescription>? cameras;
  CameraController? _controller;
  bool _hasFlashlight = false;
  bool _turnedOnFlash = false;
  bool _canProcess = true;
  bool _scanned = false;
  bool _isBusy = false;
  Rect? cutOutSquare;
  String? error;

  @override
  void initState() {
    _barcodeScanner = BarcodeScanner(formats: widget.formats);
    initCamera();
    initFlashlight();
    super.initState();
  }

  @override
  void dispose() {
    _canProcess = false;
    _barcodeScanner.close();
    if (_controller != null) _controller!.dispose();
    super.dispose();
  }

  void initCamera() async {
    cameras = await availableCameras();
    if (!cameras!.isNotEmpty) {
      setState(() {
        error = "Device has no camera :(";
      });
      return ;
    }
    _controller = CameraController(
      cameras![0],
      enableAudio: false,
      ResolutionPreset.veryHigh,
      imageFormatGroup: ImageFormatGroup.bgra8888
    );
    _controller!.initialize().then((_) {
      if (!mounted) return;
      _controller!.lockCaptureOrientation();
      _controller!.startImageStream(processImage);
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            setState(() {
              error = "User denied camera access";
            });
            break;
          default:
            setState(() {
              error = "An Unknown Error occured";
            });
            break;
        }
      }
    });
  }

  void initFlashlight() async {
    try {
      bool hasFlash = await TorchLight.isTorchAvailable();
      setState(() {
        _hasFlashlight = hasFlash;
      });
    } catch (e) {
      setState(() {
        _hasFlashlight = false;
      });
    }
  }

  void initCutOutSquare(BuildContext context) async {
    var squareSidesLength = MediaQuery.of(context).size.width / 1.5;
    cutOutSquare = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(const Offset(0.0, 0.0)), 
      width: squareSidesLength, 
      height: squareSidesLength
    );
  }

  Future<void> processImage(CameraImage image) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    if (cameras == null) return;
    final inputImage = Helpers.CameraImageToInputImage(image, cameras![0].sensorOrientation);
    if (inputImage == null) return;

    _isBusy = true;
    bool valid = true;
    if (cutOutSquare == null) return;
    double screenHeight = MediaQuery.of(context).size.height;
    final barcodes = await _barcodeScanner.processImage(inputImage);
    if (barcodes.isNotEmpty) {

      // scale cutOutSquare to image
      double factor = inputImage.inputImageData!.size.height / screenHeight;
      Rect cutOutSquareScaled = Rect.fromCenter(
        center: inputImage.inputImageData!.size.center(const Offset(0.0, 0.0)), 
        width: cutOutSquare!.width * factor, 
        height: cutOutSquare!.width * factor
      );

      // check if points are in cutOutSquare
      for (final point in barcodes[0].cornerPoints!) {
        if (!cutOutSquareScaled.contains(Offset(point.x.toDouble(), point.y.toDouble()))) valid = false;
      }
    }
    if (valid && widget.onScan != null && barcodes.isNotEmpty && (widget.singleScan && _scanned)) {
      _scanned = true;
      widget.onScan!(barcodes[0]);
    }
    _isBusy = false;
  }

  @override
  Widget build(BuildContext context) {
    bool cameraControllerInitialized = (_controller != null && _controller!.value.isInitialized);

    // calc square to cut out of screen
    initCutOutSquare(context);

    return Scaffold(

      // Flashlight Button
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _hasFlashlight ? FloatingActionButton(
        backgroundColor: Colors.black.withAlpha(100),
        child: _turnedOnFlash ? const Icon(Icons.flash_off, color: Colors.white) : const Icon(Icons.flash_on, color: Colors.white),
        onPressed: () async {
          if (!_turnedOnFlash) await TorchLight.enableTorch();
          if (_turnedOnFlash) await TorchLight.disableTorch();
          setState(() {
            _turnedOnFlash = !_turnedOnFlash;
          });
        }
      ) : null,

      // Body
      body: Stack(
        children: [

          // Preview
          (cameraControllerInitialized && error == null) ? Transform.scale(
            scale: (1 / (_controller!.value.aspectRatio * MediaQuery.of(context).size.aspectRatio)),
            alignment: Alignment.topCenter,
            child: CameraPreview(_controller!)
          ) : (error == null ? const Center(child: CircularProgressIndicator()) : Container()),

          // Overlay
          (cameraControllerInitialized && cutOutSquare != null && error != null) ? Container(
            decoration: ShapeDecoration(
              shape: ScannerOverlay(
                cutOutRect: cutOutSquare!,
                borderColor: Theme.of(context).primaryColor,
                overlayColor: Colors.black.withOpacity(0.8),
                borderRadius: 15,
                borderLength: 40,
                borderWidth: 10
              ),
            ),
          ) : Container(),

          // Error Text
          error != null ? Center(
            child: Text(error!),
          ) : Container(),

          // Closing Button
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  margin: const EdgeInsets.only(right: 12.0, top: 5.0),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(10.0),
                    child: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.of(context).pop()
                  )
                )
              ],
            )
          )
        ],
      )
    );
  }
}
