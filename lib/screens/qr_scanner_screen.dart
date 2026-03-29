import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController controller = MobileScannerController();
  bool isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  // Request Camera Access on launch
  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      isPermissionGranted = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isPermissionGranted) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Full Screen Camera
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                debugPrint('Barcode found! ${barcode.rawValue}');
              }
            },
          ),

          // 2. Darkened Overlay with cutout
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. UI Elements (Corners and Text)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // The Scanner Frame Corners
                SizedBox(
                  width: 260,
                  height: 260,
                  child: CustomPaint(painter: ScannerBorderPainter()),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Align QR code within frame to scan",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),

          // 4. Top Bar (Back Arrow)
          Positioned(
            top: 50,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // 5. Bottom Buttons (Light & Gallery)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBottomAction(Icons.flashlight_on_outlined, "Light", () {
                  controller.toggleTorch();
                }),
                _buildBottomAction(Icons.image_outlined, "Gallery", () {
                  // TODO: Implement Gallery Picker
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 35),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

// Custom Painter for the L-shaped corners
class ScannerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const double lineLength = 30;

    // Top Left
    canvas.drawLine(Offset.zero, const Offset(0, lineLength), paint);
    canvas.drawLine(Offset.zero, const Offset(lineLength, 0), paint);

    // Top Right
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - lineLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, lineLength), paint);

    // Bottom Left
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - lineLength), paint);
    canvas.drawLine(Offset(0, size.height), Offset(lineLength, size.height), paint);

    // Bottom Right
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - lineLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - lineLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
