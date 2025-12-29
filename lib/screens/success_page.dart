
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class SuccessPage extends StatefulWidget {
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

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  int _currentIndex = 0;
  late final String _transactionID; // Fixed transaction ID
  late final String _txTime; // Fixed timestamp

  final List<String> sliderImages = [
    'images/Banner1.jpg',
    'images/Banner2.jpg',
    'images/Banner3.jpg',
    'images/Banner4.jpg',
    'images/Banner5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    // Generate fixed values once
    _transactionID = _generateTransactionID();
    _txTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
  }

  String _generateTransactionID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const nums = '0123456789';
    math.Random rnd = math.Random();

    String letters = String.fromCharCodes(
        Iterable.generate(4, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    String digits = String.fromCharCodes(
        Iterable.generate(4, (_) => nums.codeUnitAt(rnd.nextInt(nums.length))));

    return "CL$letters$digits";
  }

  String _formatNumber(String number) {
    try {
      // Remove any existing formatting
      String cleanNumber = number.replaceAll(',', '');
      
      // Parse to int for formatting
      int value = int.parse(cleanNumber);
      
      // Format with commas
      return NumberFormat('#,##0', 'en_US').format(value);
    } catch (e) {
      // If parsing fails, return original
      return number;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Success Icon
            CircleAvatar(
              radius: 30,
              backgroundColor: primaryGreen,
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 10),
            Text("Successful", style: TextStyle(color: primaryGreen, fontSize: 18)),
            const SizedBox(height: 40),

            // Amount (Formatted with commas)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  "-${_formatNumber(widget.amount)}.00",
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(width: 5),
                const Text("(ETB)", style: TextStyle(fontSize: 16, color: Colors.black)),
              ],
            ),

            const SizedBox(height: 40),
            const Divider(indent: 20, endIndent: 20),

            // Details List (Using fixed values)
            _detailRow("Transaction Number", _transactionID),
            _detailRow("Transaction Time:", _txTime),
            _detailRow("Transaction Type:", "Transfer To Bank"),
            _detailRow("Transaction To:", widget.accountName.toUpperCase()),
            _detailRow("Bank Account Number:", widget.accountNumber),
            _detailRow("Bank Name:", widget.bankName),

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

            const SizedBox(height: 25),

            // Carousel Section
            Column(
              children: [
                const SizedBox(height: 10),
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 3.5,
                    viewportFraction: 0.92,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  items: sliderImages.map((imagePath) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                // Dots Indicator
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: DotsIndicator(
                    dotsCount: sliderImages.length,
                    position: _currentIndex,
                    decorator: DotsDecorator(
                      // Active Dot (The "Dot inside a hole")
                      activeColor: const Color.fromRGBO(141, 199, 63, 1),
                      activeSize: const Size(9.0, 9.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1.7,
                        ),
                      ),

                      // Inactive Dots (The "Hole")
                      size: const Size(9.0, 9.0),
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: const BorderSide(
                          color: Color.fromRGBO(141, 199, 63, 0.4),
                          width: 2.0,
                        ),
                      ),
                      spacing: const EdgeInsets.symmetric(horizontal: 4.0),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Finished Button
                // Finished Button
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
  child: SizedBox(
    width: 100,  // ← Changed from double.infinity to 100
    height: 35,  // ← Already 50
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
                const SizedBox(height: 30),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14))),
          Expanded(child: Text(value, textAlign: TextAlign.right, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}