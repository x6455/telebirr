import 'package:flutter/material.dart';
import 'package:telebirrbybr7/screens/home_screen.dart';
import 'package:telebirrbybr7/screens/engage_page.dart';
import 'dart:math' as math;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> tabs = [
    const HomeScreen(),
    const Center(child: Text('Payment')),
    const Center(child: Text('Apps')),
    const EngagePage(),
    const Center(child: Text('Account')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Extend body behind the nav bar to prevent a white gap
      extendBody: true, 
      body: tabs[_currentIndex],
      bottomNavigationBar: TelebirrBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class TelebirrBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TelebirrBottomBar({
    super.key, 
    required this.currentIndex, 
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double itemWidth = width / 5;
    
    // Calculates the horizontal center of the selected tab
    double dipPosition = (itemWidth * currentIndex) + (itemWidth / 2);

    return SizedBox(
      height: 75, // Height to accommodate the dip and dot
      child: Stack(
        children: [
          // 1. THE DYNAMIC GREEN BACKGROUND (The Bend)
          CustomPaint(
            size: Size(width, 75),
            painter: BNBCustomPainter(dipPosition: dipPosition),
          ),

          // 2. THE SLIDING CIRCLE (Floating Dot)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: dipPosition - 5, // Center the 10px dot
            top: 2, // Positions dot inside the "dip"
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(141, 199, 63, 1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // 3. THE INTERACTIVE BUTTONS
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, 'Home'),
                _buildNavItem(1, Icons.payment_outlined, 'Payment'),
                _buildNavItem(2, Icons.apps_rounded, 'Apps'),
                _buildNavItem(3, Icons.chat_bubble_outline_rounded, 'Engage'),
                _buildNavItem(4, Icons.person_2_outlined, 'Account'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7), 
              size: 24
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// THIS PAINTER DRAWS THE GREEN BAR WITH THE "BEND" TOP EDGE
class BNBCustomPainter extends CustomPainter {
  final double dipPosition;
  BNBCustomPainter({required this.dipPosition});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color.fromRGBO(141, 199, 63, 1) // Telebirr Green
      ..style = PaintingStyle.fill;

    Path path = Path();
    double curveHeight = 15.0; // Where the flat top edge sits

    path.moveTo(0, curveHeight);
    
    // Draw flat edge until just before the "dip"
    path.lineTo(dipPosition - 35, curveHeight);
    
    // Create the smooth bend/dip using Beziers
    path.quadraticBezierTo(dipPosition - 20, curveHeight, dipPosition - 15, curveHeight + 8);
    path.arcToPoint(
      Offset(dipPosition + 15, curveHeight + 8),
      radius: const Radius.circular(15),
      clockwise: false,
    );
    path.quadraticBezierTo(dipPosition + 20, curveHeight, dipPosition + 35, curveHeight);

    // Complete the box
    path.lineTo(size.width, curveHeight);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BNBCustomPainter oldDelegate) {
    return oldDelegate.dipPosition != dipPosition;
  }
}
