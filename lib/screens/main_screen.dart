import 'package:flutter/material.dart';
import 'package:telebirrbybr7/screens/home_screen.dart';
import 'package:telebirrbybr7/screens/engage_page.dart'; // Ensure the path is correct

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // 1. Removed 'const' to allow for dynamic Page injection
  final List<Widget> tabs = [
    const HomeScreen(),
    const Center(
      child: Text('Payment'),
    ),
    const Center(
      child: Text('Apps'),
    ),
    const EngagePage(), // 2. Your actual Engage file integrated here
    const Center(
      child: Text('Account'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: TelebirrBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
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
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double itemWidth = width / 5;

    // Horizontal center of the selected tab
    final double dipPosition =
        (itemWidth * currentIndex) + (itemWidth / 2);

    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          /// STATic IMAGE BACKGROUND
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'images/bottom_bar.jpg', // <-- your image
              width: width,
              height: 150,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                // Fallback if image doesn't exist - keep the original green color
                return Container(
                  color: const Color.fromRGBO(141, 199, 63, 0.85),
                  height: 70,
                );
              },
            ),
          ),

          

          ///TRANSPARENT TAP ZONES
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 60,
            child: Row(
              children: List.generate(5, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(index),
                    behavior: HitTestBehavior.opaque,
                    child: const SizedBox.expand(),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
