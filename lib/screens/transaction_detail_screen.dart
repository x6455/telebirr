import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> txData;

  const TransactionDetailScreen({super.key, required this.txData});

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF0077B6);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Transaction Detail",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Row(
              children: [
                Icon(Icons.more_horiz, color: Colors.black, size: 20),
                SizedBox(width: 8),
                VerticalDivider(width: 1, indent: 5, endIndent: 5),
                SizedBox(width: 8),
                Icon(Icons.cancel_outlined, color: Colors.black, size: 20),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildDetailTile("Transaction Time", txData['time'] ?? ""),
            _buildDetailTile("Transaction No", txData['txID'] ?? ""),
            _buildDetailTile("Transaction Type", "Transfer to Bank"),
            _buildDetailTile("Transaction To", txData['bankName'] ?? ""),
            _buildDetailTile("Transaction Amount", "-${txData['amount_sent']}.00 (ETB)"),
            _buildDetailTile("Transaction Status", "Completed"),
            _buildDetailTile("Service Charge", "0.00 (ETB)"), // Assuming 0 or calculate if needed

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    Image.asset(
                      'images/receipt.jpg', // Receipt icon
                      width: 40,
                      height: 40,
                     
                    ),
                    const SizedBox(height: 5),
                    const Text("Get Receipt", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
  return Column(
    children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600], 
                fontSize: 16,
                fontWeight: FontWeight.w100,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF0077B6),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      // Divider with same left offset
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20), // Same offset as the text
        child: Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[200],
        ),
      ),
    ],
  );
}

}
