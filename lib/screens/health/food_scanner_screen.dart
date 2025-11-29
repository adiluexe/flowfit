import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

class FoodScannerScreen extends StatefulWidget {
  const FoodScannerScreen({super.key});

  @override
  State<FoodScannerScreen> createState() => _FoodScannerScreenState();
}

class _FoodScannerScreenState extends State<FoodScannerScreen> {
  bool _isScanning = false;

  void _simulateScan() async {
    setState(() {
      _isScanning = true;
    });

    // Simulate network/processing delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isScanning = false;
    });

    // Mock result
    _showResultDialog();
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yum! Found something!'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.apple, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Red Apple',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('95 kcal'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Try Again'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, {
                'name': 'Red Apple',
                'calories': '95 kcal',
              }); // Return result
            },
            child: const Text('Add to Log'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Food Scanner', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          // Camera Placeholder
          Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[900],
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(SolarIconsOutline.camera, size: 80, color: Colors.white54),
                  SizedBox(height: 16),
                  Text(
                    'Point at food',
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          
          // Scanner Overlay
          if (_isScanning)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFFFF9F1C)),
              ),
            ),

          // Scan Button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _simulateScan,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFF9F1C), width: 4),
                  ),
                  child: const Icon(Icons.camera_alt, size: 40, color: Color(0xFFFF9F1C)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
