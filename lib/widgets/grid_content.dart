import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GridContent extends StatelessWidget {
  const GridContent({
    super.key,
    required this.gridIcon,
    required this.gridLabel,
  });

  final List<Widget> gridIcon;
  final List<String> gridLabel;

  /// New version of show options that takes position and size
  void _showSendMoneyOptions(BuildContext context, Offset position, Size size) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent, // Keeps the background clear
      builder: (BuildContext context) {
        const double popupWidth = 180.0;
        
        // Horizontal centering logic
        double leftPosition = position.dx + (size.width / 2) - (popupWidth / 2);

        return Stack(
          children: [
            Positioned(
              top: position.dy + size.height + 5, // Directly below the tile
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
                      // To Individual Option
                      _buildMenuAction(
                        icon: Icons.person_outline,
                        label: 'To Individual',
                        onTap: () => Navigator.pop(context),
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

  /// Clean helper for the popup rows
  Widget _buildMenuAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Left aligned for menu look
          children: [
            Icon(icon, color: const Color.fromRGBO(140, 202, 59, 1), size: 20),
            const SizedBox(width: 12),
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

        // Wrapped in Builder to find the tile's position on screen
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
      padding: const EdgeInsets.all(8.0),
      child: icon == Icons.ad_units_outlined
          ? Badge(
              label: const Text('+10%'),
              backgroundColor: Colors.amber,
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
  GridIcons(icon: Icons.wallet),
  GridIcons(icon: Icons.wallet_giftcard),
  GridIcons(icon: Icons.ad_units_outlined),
  GridIcons(icon: Icons.clean_hands_sharp),
  Image(image: AssetImage('images/dashen.png'), width: 20),
  Image(
    image: AssetImage('images/cbe.png'),
    width: 40,
  ),
  GridIcons(icon: Icons.storefront),
  GridIcons(icon: Icons.window_sharp),
];

List<Widget> bottomGridIcon = const [
  Image(image: AssetImage('images/christmas.png'), width: 70),
  Image(image: AssetImage('images/ethio-logo.png'), width: 30),
  GridIcons(icon: Icons.calendar_month_outlined),
  GridIcons(icon: FontAwesomeIcons.bank),
  GridIcons(icon: Icons.wallet_sharp),
  GridIcons(icon: Icons.payments_outlined),
  GridIcons(icon: Icons.location_on),
  GridIcons(icon: Icons.add_circle_outline_sharp),
];
