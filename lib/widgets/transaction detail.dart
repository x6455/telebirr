import 'package:flutter/material.dart';
import 'transaction_history_page.dart'; // Ensure this matches your filename

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({super.key});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  bool _isLoading = false;

  void _handleTap() async {
    setState(() {
      _isLoading = true; // Show loading
    });

    // Wait for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false; // Hide loading
    });

    // Navigate to the transaction history page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TransactionHistoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: _isLoading
          ? Center(
              child: Image.asset(
                'images/loading.gif',
                width: 80,
                height: 80,
              ),
            )
          : Row(
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
                SizedBox(width: 4), // Small space between text and icon
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
