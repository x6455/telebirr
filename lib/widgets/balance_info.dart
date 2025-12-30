import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BalanceInfo extends StatefulWidget {
  final String label;
  final double labelFontSize;
  final double balanceFontSize;
  final CrossAxisAlignment crossAxisAlignment;
  final bool isLabelBold; // ✅ added

  const BalanceInfo({
    super.key,
    required this.label,
    required this.labelFontSize,
    required this.balanceFontSize,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.isLabelBold = false, // ✅ default
  });

  @override
  State<BalanceInfo> createState() => _BalanceInfoState();
}

class _BalanceInfoState extends State<BalanceInfo> {
  bool showBalance = false;

  void toggleBalanceVisibility() {
    setState(() {
      showBalance = !showBalance;
    });
  }

  String get balanceValue {
    switch (widget.label) {
      case 'Balance (ETB) ':
        return '163,874.78';
      case 'Endekise (ETB) ':
        return '2,450.00';
      case 'Reward (ETB) ':
        return '350.75';
      default:
        return '0.00';
    }
  }

    @override
  Widget build(BuildContext context) {
    // 1. Define the missing variable here
    // It is true if the label is 'Balance (ETB) '
    final bool isMainBalance = widget.label == 'Balance (ETB) ';
    
    final String balance = showBalance ? balanceValue : '✱✱✱✱✱✱';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isMainBalance ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              isMainBalance ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: TextStyle(
                color: const Color.fromRGBO(247, 255, 234, 1),
                fontSize: widget.labelFontSize,
                fontWeight: widget.isLabelBold
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: toggleBalanceVisibility,
              child: Icon(
                showBalance
                    ? Icons.visibility_off
                    : Icons.remove_red_eye_sharp,
                size: 13,
                color: const Color.fromRGBO(247, 255, 234, 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 1),
        Text(
  balance,
  textAlign: isMainBalance ? TextAlign.center : TextAlign.start,
  style: GoogleFonts.roboto(
    fontSize: widget.balanceFontSize,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: -1.5, // <-- negative value brings characters closer
  ),
),

      ],
    );
  }

}
