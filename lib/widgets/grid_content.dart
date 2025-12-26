import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'individual_transfer_page.dart';
import 'transfer_to_bank_page.dart';

class GridContent extends StatelessWidget {
  const GridContent({
    super.key,
    required this.gridIcon,
    required this.gridLabel,
  });

  final List<Widget> gridIcon;
  final List<String> gridLabel;

  void _showSendMoneyOptions(BuildContext context, Offset position, Size size) {
    showDialog(
      context: context,
      barrierDismissible: true,
      // SET TO GRAYED OUT BACKGROUND
      barrierColor: Colors.black.withOpacity(0.5), 
      builder: (BuildContext context) {
        const double popupWidth = 175.0;

        // Horizontal centering logic
        double leftPosition = position.dx + (size.width / 2) - (popupWidth / 2) + 45;

        return Stack(
          children: [
            Positioned(
              top: position.dy + size.height + 1, // Directly below the tile
              left: leftPosition,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: popupWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // To Individual Option - MODIFIED FOR NAVIGATION
                      _buildMenuAction(
                        icon: Icons.person_outline,
                        label: 'To Individual',
                        onTap: () {
                          Navigator.pop(context); // Closes the popup
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IndividualTransferPage(),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, thickness: 1, color: Colors.grey[300]),
                      // To Group Option
                      _buildMenuAction(
                        icon: Icons.group_outlined,
                        label: 'To Group',
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Clean helper for the popup rows with added left padding
  Widget _buildMenuAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Increased horizontal padding
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon, 
              color: const Color.fromRGBO(140, 202, 59, 1), 
              size: 22,
            ),
            const SizedBox(width: 14), // Gap between icon and text
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// RETAINED: Your original option item helper
  Widget _buildOptionItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[50]!,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(140, 202, 59, 0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(
                icon,
                color: const Color.fromRGBO(140, 202, 59, 1),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600]!,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(
        left: 5,   // left offset
        right: 5,  // right offset
        top: 20,    // top offset
        bottom: 5,  // optional
      ),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 19,
        crossAxisSpacing: 10,
        childAspectRatio: 0.97,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        bool isSendMoney = gridLabel[index] == 'Send Money';
        // Check for Transfer to Bank label
        bool isTransferToBank = gridLabel[index] == 'Transfer to Bank';

        return Builder(builder: (itemContext) {
          return GestureDetector(
            onTap: () {
              if (isSendMoney) {
                final RenderBox renderBox = itemContext.findRenderObject() as RenderBox;
                final offset = renderBox.localToGlobal(Offset.zero);
                final size = renderBox.size;
                _showSendMoneyOptions(context, offset, size);
              } 
              // ADDED: Navigation logic for Transfer to Bank
              else if (isTransferToBank) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransferToBankPage(),
                  ),
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  gridIcon[index],
                  const SizedBox(height: 5),
                  Text(
                    gridLabel[index],
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
} // Missing closing brace was here

// Moved outside of GridContent class
class GridIcons extends StatelessWidget {
  final IconData icon;
  
  const GridIcons({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          Image(
            image: AssetImage('images/Airtime.jpg'), 
            width: 65,
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Up to 35%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// RETAINED: All icons and images as defined in your file
List<Widget> topGridIcon = [
  const Image(image: AssetImage('images/Test.jpg'), width: 75),
  const Image(image: AssetImage('images/Cashinout.jpg'), width: 45),
Stack(
  clipBehavior: Clip.none, // Allows the badge to sit cleanly on the edge
  children: [
    const Image(
      image: AssetImage('images/Airtime.jpg'),
      width: 65,
    ),
    Positioned(
      top: -13,
      left: -6,
      // Removed 'right: 0' so the badge only grows as wide as the text
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF9B041), // Matching the exact orange color from the image
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),     // High roundness top-left
            bottomRight: Radius.circular(12), // High roundness bottom-right
            topRight: Radius.circular(2),     // Subtle roundness top-right
            bottomLeft: Radius.circular(2),   // Subtle roundness bottom-left
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8), // Increased horizontal padding
          child: Text(
            'Up to +35%', // Added the '+' sign to match the image
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500, // Medium weight looks closer to the image
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      ),
    ),
  ],
),

  const Image(image: AssetImage('images/Zemen.png'),width: 35,),
  const Image(image: AssetImage('images/dashen.png'), width: 20),
  const Image(image: AssetImage('images/cbe.png'),width: 36,),
  const Image(image: AssetImage('images/Sinqee.png'),width: 40,),
  const Image(image: AssetImage('images/Transfertobank.jpg'), width: 62),
];

List<Widget> bottomGridIcon = const [
  Image(image: AssetImage('images/Awash.png'), width: 30),
  Image(image: AssetImage('images/Paymerchant.jpg'), width: 69),
  Image(image: AssetImage('images/Devicefin.jpg'), width: 64),
  Image(image: AssetImage('images/Teleev.jpg'), width: 64),
  Image(image: AssetImage('images/Lottery.jpg'), width: 80),
  Image(image: AssetImage('images/christmas.png'), width: 45),
  Image(image: AssetImage('images/Fyda.png'), width: 40),
  Image(image: AssetImage('images/More.jpg'), width: 60),
];
