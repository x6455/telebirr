import 'package:flutter/material.dart';
import 'transaction_history_page.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({super.key});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // show floating loader
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.1), // light gray overlay feel
      builder: (_) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              'images/loading.gif',
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
    );

    // wait
    await Future.delayed(const Duration(seconds: 0.7));

    // close loader (only if still mounted)
    if (mounted) Navigator.of(context, rootNavigator: true).pop();

    setState(() => _isLoading = false);

    // navigate
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TransactionHistoryPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Text(
            'Transaction Details',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Color.fromRGBO(19, 132, 185, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.keyboard_arrow_right_rounded,
            color: Color.fromRGBO(19, 132, 185, 1),
            size: 24,
          ),
        ],
      ),
    );
  }
}
