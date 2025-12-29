import 'package:flutter/material.dart';
import 'dart:async';
import 'success_page.dart';

class ProcessingPage extends StatefulWidget {
  final String amount;
  final String accountName;
  final String accountNumber;
  final String bankName;

  const ProcessingPage({
    super.key,
    required this.amount,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
  });

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  @override
  void initState() {
    super.initState();
    // Auto-navigate to SuccessPage after 2 seconds
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(
              amount: widget.amount,
              accountName: widget.accountName,
              accountNumber: widget.accountNumber,
              bankName: widget.bankName,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF8DC73F);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Dark Banner (stretched left to right)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: const Color(0xFF222222),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Transfer to Bank",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Transfer to Bank Success for -${widget.amount}.00",
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            // 2. Processing Icon and Text
            Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: primaryGreen,
                  child: const Icon(Icons.access_time, color: Colors.white, size: 35),
                ),
                const SizedBox(height: 12),
                Text(
                  "Processing",
                  style: TextStyle(color: primaryGreen, fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const SizedBox(height: 60),
            const Divider(indent: 30, endIndent: 30, color: Color(0xFFEEEEEE)),

            const Spacer(),

            // 3. Bottom Finished Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {}, // Optional: can be disabled or pop early
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Finished",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
