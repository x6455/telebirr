import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

class SuccessPage extends StatelessWidget {
  final String amount;
  final String accountName;
  final String accountNumber;
  final String bankName;

  const SuccessPage({
    super.key,
    required this.amount,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
  });

  String _generateTransactionID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const nums = '0123456789';
    math.Random rnd = math.Random();
    
    String letters = String.fromCharCodes(Iterable.generate(4, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    String digits = String.fromCharCodes(Iterable.generate(4, (_) => nums.codeUnitAt(rnd.nextInt(nums.length))));
    
    return "CL$letters$digits";
  }

  @override
  Widget build(BuildContext context) {
    String txTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
    final Color primaryGreen = const Color(0xFF8DC73F);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.file_download_outlined, color: primaryGreen, size: 20),
            const SizedBox(width: 4),
            Text("Download", style: TextStyle(color: primaryGreen, fontSize: 14)),
            const Spacer(),
            Icon(Icons.share_outlined, color: primaryGreen, size: 20),
            const SizedBox(width: 4),
            Text("Share", style: TextStyle(color: primaryGreen, fontSize: 14)),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Success Icon
          CircleAvatar(
            radius: 30,
            backgroundColor: primaryGreen,
            child: const Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 10),
          Text("Successful", style: TextStyle(color: primaryGreen, fontSize: 18, fontWeight: FontWeight.w500)),
          const SizedBox(height: 40),
          
          // Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text("-$amount.00", style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              const SizedBox(width: 5),
              const Text("(ETB)", style: TextStyle(fontSize: 16, color: Colors.black)),
            ],
          ),
          
          const SizedBox(height: 40),
          const Divider(indent: 20, endIndent: 20),

          // Details List
          _detailRow("Transaction Number", _generateTransactionID()),
          _detailRow("Transaction Time:", txTime),
          _detailRow("Transaction Type:", "Transfer To Bank"),
          _detailRow("Transaction To:", accountName.toUpperCase()),
          _detailRow("Bank Account Number:", accountNumber),
          _detailRow("Bank Name:", bankName),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.qr_code_2, color: primaryGreen, size: 20),
              Text(" QR Code ", style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_forward_ios, color: primaryGreen, size: 14),
              const SizedBox(width: 20),
            ],
          ),

          const Spacer(),
          // Ad Banner Placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset('images/promo_banner.png', height: 120, width: double.infinity, fit: BoxFit.cover, 
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.green[100], height: 120)),
            ),
          ),
          const SizedBox(height: 40),

          // Finished Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Finished", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14))),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
