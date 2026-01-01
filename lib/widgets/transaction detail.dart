import 'package:flutter/material.dart';
import 'transaction_history_page.dart'; // Ensure this matches your filename

class TransactionDetails extends StatelessWidget {
  const TransactionDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // This makes the entire row clickable
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TransactionHistoryPage(),
          ),
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Transaction Details',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Color.fromRGBO(19, 132, 185, 1),
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_right_rounded,
            color: Color.fromRGBO(19, 132, 185, 1),
            size: 24, // Note: Use 'size' for visual scale; 'weight' is for variable fonts
          )
        ],
      ),
    );
  }
}
