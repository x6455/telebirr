import 'package:flutter/material.dart';

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
      height: 70,
      child: Stack(
        children: [
          /// 1️⃣ STATIC IMAGE BACKGROUND
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'images/bottom_bar.jpg', // <-- your image
              width: width,
              height: 70,
              fit: BoxFit.fill,
            ),
          ),

          /// 2️⃣ SLIDING DOT INDICATOR
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: dipPosition - 6, // centers 12px dot
            top: 4, // tweak to match dip perfectly
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(141, 199, 63, 1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1.5,
                ),
              ),
            ),
          ),

          /// 3️⃣ TRANSPARENT TAP ZONES
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