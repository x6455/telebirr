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

  @override
  Widget build(BuildContext context) {
    final String balance = showBalance ? '163,874.78' : '******';

    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
        const SizedBox(height: 2),
        Text(
          balance,
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: widget.balanceFontSize,
            ),
          ),
        ),
      ],
    );
  }
}
