import 'dart:ui'; // Required for ImageFilter
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'individual_transfer_page.dart';

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
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        bool isSendMoney = gridLabel[index] == 'Send Money';

        return Builder(builder: (itemContext) {
          return GestureDetector(
            onTap: () {
              if (isSendMoney) {
                final RenderBox renderBox = itemContext.findRenderObject() as RenderBox;
                final offset = renderBox.localToGlobal(Offset.zero);
                final size = renderBox.size;
                _showSendMoneyOptions(context, offset, size);
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
}

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
      child: icon == Icons.ad_units_outlined
          ? Badge(
              label: const Text('Up to +35%'),
              backgroundColor: Colors.amber,
              alignment: Alignment.topRight,
              child: Icon(
                icon,
                color: const Color.fromRGBO(140, 197, 68, 0.85),
                size: 30,
              ),
            )
          : Icon(
              icon,
              color: const Color.fromRGBO(140, 197, 68, 0.85),
              size: 30,
            ),
    );
  }
}

// RETAINED: All icons and images as defined in your file
List<Widget> topGridIcon = const [
  Image(image: AssetImage('images/Test.jpg'), width: 20),
  GridIcons(icon: Icons.wallet_giftcard),
  GridIcons(icon: Icons.ad_units_outlined),
  Image(
    image: AssetImage('images/Zemen.png'),
    width: 45,
  ),
  Image(image: AssetImage('images/dashen.png'), width: 20),
  Image(
    image: AssetImage('images/cbe.png'),
    width: 40,
  ),
  Image(
    image: AssetImage('images/Sinqee.png'),
    width: 40,
  ),
  GridIcons(icon: FontAwesomeIcons.bank),
];

List<Widget> bottomGridIcon = const [
  Image(image: AssetImage('images/Awash.png'), width: 36),
  Image(image: AssetImage('images/ethio-logo.png'), width: 30),
  GridIcons(icon: Icons.calendar_month_outlined),
  GridIcons(icon: FontAwesomeIcons.bank),
  GridIcons(icon: Icons.wallet_sharp),
  GridIcons(icon: Icons.payments_outlined),
    Image(image: AssetImage('images/Fyda.png'), width: 40),
  GridIcons(icon: Icons.add_circle_outline_sharp),
];
