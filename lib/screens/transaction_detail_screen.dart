import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> txData;

  const TransactionDetailScreen({super.key, required this.txData});

  Future<void> _handleGetReceipt() async {
  final String baseUrl = "http://127.0.0.1:3000/generate-receipt";

  final Uri url = Uri.parse(baseUrl).replace(queryParameters: {
    'txID': txData['txID'] ?? "N/A",
    'time': txData['time'] ?? "",
    'amount': txData['amount_sent'].toString(),
    'bankName': txData['bankName'] ?? "Bank Transfer",
    'accountName': txData['accountName'] ?? "N/A",      // ← ADD THIS
    'accountNumber': txData['accountNumber'] ?? "N/A",  // ← ADD THIS
  });

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    debugPrint("Could not launch $url");
  }
}


  String _formatAmount(dynamic value) {
  if (value == null) return "0.00";

  final number = double.tryParse(value.toString());
  if (number == null) return "0.00";

  final formatter = NumberFormat("#,##0.00", "en_US");
  return formatter.format(number);
}


  @override
  Widget build(BuildContext context) {
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
            _buildDetailTile(
  "Transaction Amount",
  "-${_formatAmount(txData['amount_sent'])} (ETB)",
),
           _buildDetailTile("Transaction Status", "Completed"),
_buildDetailTile(
  "Service Charge",
  "${_formatAmount(txData['service_charge'] ?? 0)} (ETB)",
),

            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: _handleGetReceipt, // Click to get receipt
                  child: Column(
                    children: [
                      Image.asset(
                        'images/receipt.jpg',
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        "Get Receipt", 
                        style: TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.normal)
                      ),
                    ],
                  ),
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
                style: TextStyle(color: Colors.grey[800], fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(color: Color(0xFF0077B6), fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(height: 1, thickness: 1, color: Colors.grey[400]),
        ),
      ],
    );
  }
}
