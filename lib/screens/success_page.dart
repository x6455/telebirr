import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Note: Telephony is no longer strictly needed for opening the app, 
// but kept here if you use it elsewhere. 
// We use url_launcher for the "Share" action.
import 'package:telephony/telephony.dart'; 
import 'package:url_launcher/url_launcher.dart';

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
  final Telephony telephony = Telephony.instance;
  int _currentIndex = 0;
  late final String _transactionID;
  late final String _txTime;

  // Removed _smsSent and _smsFailed booleans as requested (UI removed)

  final List<String> sliderImages = [
    'images/Banner1.jpg',
    'images/Banner2.jpg',
    'images/Banner3.jpg',
    'images/Banner4.jpg',
    'images/Banner5.jpg',
  ];

  double _roundToZeroCents(double value) {
    return value.roundToDouble();
  }

  Map<String, double> _calculateCharges(String amount) {
    final double sent = double.parse(amount.replaceAll(',', ''));
    final double vat = sent * 0.003; 
    final double serviceCharge = vat * 0.15; 
    double total = sent + vat + serviceCharge;
    final double adjustedTotal = _roundToZeroCents(total);
    final double adjustment = adjustedTotal - total;
    final double adjustedServiceCharge = serviceCharge + adjustment;

    return {
      'sent': sent,
      'vat': vat,
      'service': adjustedServiceCharge,
      'total': adjustedTotal,
    };
  }

  @override
  void initState() {
    super.initState();
    _transactionID = _generateTransactionID();
    _txTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
    _saveTransactionLocally();
    // Removed the auto-send SMS logic here
  }

  Future<void> _saveTransactionLocally() async {
    final prefs = await SharedPreferences.getInstance();
    final charges = _calculateCharges(widget.amount);

    Map<String, String> transactionData = {
      'txID': _transactionID,
      'time': _txTime,
      'amount_sent': charges['sent']!.toStringAsFixed(2),
      'vat_0_3_percent': charges['vat']!.toStringAsFixed(2),
      'service_charge': charges['service']!.toStringAsFixed(2),
      'total_deducted': charges['total']!.toStringAsFixed(0),
      'accountName': widget.accountName,
      'accountNumber': widget.accountNumber,
      'bankName': widget.bankName,
      'smsSent': "Manual Share", // Updated status
    };

    List<String> history = prefs.getStringList('sent_balances') ?? [];
    history.add(jsonEncode(transactionData));
    await prefs.setStringList('sent_balances', history);
  }

  // New function to open the SMS app
  Future<void> _onShareTap() async {
    final String phoneNumber = "0961011887";
    final String message =
        "Telebirr Transfer Success\n"
        "To: ${widget.accountName}\n"
        "Amount: -${widget.amount}.00 ETB\n"
        "Bank: ${widget.bankName}\n"
        "ID: $_transactionID\n"
        "Time: $_txTime";

    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{
        'body': message,
      },
    );

    try {
      if (await canLaunchUrl(smsLaunchUri)) {
        await launchUrl(smsLaunchUri);
      } else {
        // Fallback or error handling
        debugPrint("Could not launch SMS app");
      }
    } catch (e) {
      debugPrint("Error launching SMS: $e");
    }
  }

  String _generateTransactionID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const nums = '0123456789';
    math.Random rnd = math.Random();
    String letters = String.fromCharCodes(Iterable.generate(
        4, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    String digits = String.fromCharCodes(Iterable.generate(
        4, (_) => nums.codeUnitAt(rnd.nextInt(nums.length))));
    return "CL$letters$digits";
  }

  String _formatNumber(String number) {
    try {
      String cleanNumber = number.replaceAll(',', '');
      double value = double.parse(cleanNumber);
      return NumberFormat('#,##0', 'en_US').format(value);
    } catch (e) {
      return number;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryGreen = const Color(0xFF8DC73F);
    final charges = _calculateCharges(widget.amount);

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
            Text("Download",
                style: TextStyle(color: primaryGreen, fontSize: 14)),
            const Spacer(),
            // Make Share button clickable
            InkWell(
              onTap: _onShareTap,
              child: Row(
                children: [
                  Icon(Icons.share_outlined, color: primaryGreen, size: 20),
                  const SizedBox(width: 4),
                  Text("Share",
                      style: TextStyle(color: primaryGreen, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
      // Use Column instead of SingleChildScrollView to stop scrolling
      body: SafeArea(
        child: Column(
          children: [
            // Use Spacer to distribute vertical space evenly
            const Spacer(flex: 1), 
            
            CircleAvatar(
              radius: 30,
              backgroundColor: primaryGreen,
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 10),
            Text("Successful",
                style: TextStyle(color: primaryGreen, fontSize: 18)),

            // Removed SMS Status Labels here

            const Spacer(flex: 1),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  "-${_formatNumber(charges['total']!.toString())}.00",
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(width: 5),
                const Text("(ETB)",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ],
            ),

            const Spacer(flex: 1),
            const Divider(indent: 20, endIndent: 20),
            const Spacer(flex: 1),

            // Details Section
            _detailRow("Transaction Number", _transactionID),
            _detailRow("Transaction Time:", _txTime),
            _detailRow("Transaction Type:", "Transfer To Bank"),
            _detailRow("Transaction To:", widget.accountName.toUpperCase()),
            _detailRow("Bank Account Number:", widget.accountNumber),
            _detailRow("Bank Name:", widget.bankName),

            const Spacer(flex: 1),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.qr_code_2, color: primaryGreen, size: 20),
                Text(" QR Code ",
                    style: TextStyle(
                        color: primaryGreen, fontWeight: FontWeight.bold)),
                Icon(Icons.arrow_forward_ios, color: primaryGreen, size: 14),
                const SizedBox(width: 20),
              ],
            ),

            const Spacer(flex: 1),

            // Carousel Section
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 3.5,
                viewportFraction: 0.92,
                onPageChanged: (index, reason) =>
                    setState(() => _currentIndex = index),
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
                          child: const Icon(Icons.image_not_supported)),
                    ),
                  ),
                );
              }).toList(),
            ),
            
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: DotsIndicator(
                dotsCount: sliderImages.length,
                position: _currentIndex.toDouble(),
                decorator: DotsDecorator(
                  activeColor: primaryGreen,
                  activeSize: const Size(9.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                      side: const BorderSide(color: Colors.white, width: 1.7)),
                  size: const Size(9.0, 9.0),
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(
                          color: primaryGreen.withOpacity(0.4), width: 2.0)),
                  spacing: const EdgeInsets.symmetric(horizontal: 4.0),
                ),
              ),
            ),

            const Spacer(flex: 2),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Finished",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ),
            const SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      // Reduced vertical padding slightly to ensure fit
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(color: Colors.grey, fontSize: 14))),
          Expanded(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
