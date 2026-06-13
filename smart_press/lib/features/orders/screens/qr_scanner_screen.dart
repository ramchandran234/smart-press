// lib/features/orders/screens/qr_scanner_screen.dart
// PPT Screen 10 — QR Code Scanner Screen
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _flashOn = false;
  String? _scannedCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Scan Garment QR'),
        actions: [
          IconButton(
            icon: Icon(
              _flashOn ? Icons.flash_on : Icons.flash_off,
              color: _flashOn ? AppColors.gold : AppColors.white,
            ),
            onPressed: () =>
                setState(() => _flashOn = !_flashOn),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Camera placeholder
          Container(color: Colors.black87),

          // Scanner frame
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Point camera at garment QR label',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 30),
                // QR Frame
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.accent, width: 3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Corner decorators
                      ..._corners(),
                      // Center icon
                      const Center(
                        child: Icon(Icons.qr_code_scanner,
                            size: 80,
                            color: Colors.white24),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Scan line animation placeholder
                Container(
                  width: 250,
                  height: 2,
                  color: AppColors.accent.withOpacity(0.7),
                ),
              ],
            ),
          ),

          // Bottom panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.darkBg,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_scannedCode != null) ...[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.green
                                .withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: AppColors.green),
                          const SizedBox(width: 10),
                          Text('Order: $_scannedCode',
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context
                          .push('/orders/$_scannedCode'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        minimumSize: const Size(
                            double.infinity, 48),
                      ),
                      child: const Text('View Order'),
                    ),
                  ] else ...[
                    const Text('Or enter code manually',
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: const TextStyle(
                                color: AppColors.white),
                            decoration: InputDecoration(
                              hintText: 'Enter Order ID',
                              hintStyle: const TextStyle(
                                  color: Colors.white38),
                              filled: true,
                              fillColor: Colors.white12,
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onSubmitted: (v) => setState(
                                () => _scannedCode = v),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => setState(
                              () => _scannedCode = 'ORD001'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            minimumSize:
                                const Size(60, 52),
                          ),
                          child: const Icon(Icons.search),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _corners() {
    const size = 24.0;
    const thick = 3.0;
    const color = AppColors.accent;
    return [
      Positioned(top: 0, left: 0,
          child: _corner(true, true, size, thick, color)),
      Positioned(top: 0, right: 0,
          child: _corner(true, false, size, thick, color)),
      Positioned(bottom: 0, left: 0,
          child: _corner(false, true, size, thick, color)),
      Positioned(bottom: 0, right: 0,
          child: _corner(false, false, size, thick, color)),
    ];
  }

  Widget _corner(bool top, bool left, double size,
      double thick, Color color) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CornerPainter(top, left, thick, color),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool top, left;
  final double thick;
  final Color color;

  _CornerPainter(this.top, this.left, this.thick, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thick
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    if (top && left) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (top && !left) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!top && left) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}