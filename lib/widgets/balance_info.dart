import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BalanceInfo extends StatefulWidget {
  final String label;
  final double labelFontSize;
  final double balanceFontSize;
  final CrossAxisAlignment crossAxisAlignment;
  final bool isLabelBold;

  const BalanceInfo({
    super.key,
    required this.label,
    required this.labelFontSize,
    required this.balanceFontSize,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.isLabelBold = false,
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
  final bool isMainBalance = widget.label == 'Balance (ETB) ';
  final bool isReward = widget.label == 'Reward (ETB) '; // Identify Reward
  final String balance = showBalance ? balanceValue : '✱✱✱✱✱✱';

  return Transform.translate(
    // If it's Reward, shift it left by 15 pixels. Otherwise, stay at 0.
    offset: isReward ? const Offset(-15, 0) : Offset.zero,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          isMainBalance ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              isMainBalance ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Transform.scale(
              scaleX: 1.2,
              alignment: Alignment.centerLeft,
              child: Text(
                widget.label,
                style: TextStyle(
                  color: const Color.fromRGBO(247, 255, 234, 1),
                  fontSize: widget.labelFontSize,
                  fontWeight:
                      widget.isLabelBold ? FontWeight.w800 : FontWeight.normal,
                  letterSpacing: -1.5,
                ),
              ),
            ),
            const SizedBox(width: 15),
            InkWell(
              onTap: toggleBalanceVisibility,
              child: Icon(
                showBalance ? Icons.visibility : Icons.visibility_off,
                size: 13,
                color: const Color.fromRGBO(247, 255, 234, 1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 1),
        Transform.translate(
          offset: isMainBalance ? const Offset(-5, 0) : Offset.zero,
          child: Transform.scale(
            scaleX: 1.0,
            alignment: isMainBalance ? Alignment.center : Alignment.centerLeft,
            child: Text(
              balance,
              textAlign: isMainBalance ? TextAlign.center : TextAlign.start,
              style: GoogleFonts.roboto(
                fontSize: widget.balanceFontSize,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -1.5,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
}
