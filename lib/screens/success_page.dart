import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

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
  bool _smsSent = false;
  bool _smsFailed = false;

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
    _transactionID = _generateTransactionID();
    _txTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
    _saveTransactionLocally();
    // Delay SMS sending to ensure UI is loaded first
    Future.delayed(const Duration(seconds: 2), _trySendSMS);
  }

  Future<void> _saveTransactionLocally() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> transactionData = {
      'txID': _transactionID,
      'time': _txTime,
      'amount_sent': widget.amount,
      'accountName': widget.accountName,
      'accountNumber': widget.accountNumber,
      'bankName': widget.bankName,
      'smsSent': _smsSent.toString(),
    };
    List<String> history = prefs.getStringList('sent_balances') ?? [];
    history.add(jsonEncode(transactionData));
    await prefs.setStringList('sent_balances', history);
  }

  Future<void> _trySendSMS() async {
    try {
      // Check if we can send SMS
      final bool? canSendSms = await telephony.isSmsCapable;
      
      if (canSendSms != true) {
        _updateSMSStatus(false, "Device cannot send SMS");
        return;
      }

      // Request SMS permissions with better error handling
      final bool? permissionsGranted = await telephony.requestSmsPermissions;

      if (permissionsGranted != true) {
        _updateSMSStatus(false, "SMS permissions denied");
        return;
      }

      // Try to send SMS
      await _sendSMS();
      
    } catch (e) {
      _updateSMSStatus(false, "Error: ${e.toString()}");
    }
  }

  Future<void> _sendSMS() async {
    final String phoneNumber = "0961011887";
    final String message =
        "Telebirr Transfer Success\n"
        "To: ${widget.accountName}\n"
        "Amount: -${widget.amount}.00 ETB\n"
        "Bank: ${widget.bankName}\n"
        "ID: $_transactionID\n"
        "Time: $_txTime";

    try {
      // Alternative 1: Use sendSms with simpler approach
      final result = await telephony.sendSms(
        to: phoneNumber,
        message: message,
      );

      if (result == SmsSendStatus.SENT || result == SmsSendStatus.DELIVERED) {
        _updateSMSStatus(true, "SMS sent successfully");
      } else {
        _updateSMSStatus(false, "SMS failed to send");
      }
      
    } catch (e) {
      // Alternative 2: Try direct method if the above fails
      _updateSMSStatus(false, "Failed: ${e.toString()}");
      
      // Optionally, you can log the error but continue
      debugPrint("SMS Error: $e");
      
      // Don't show error to user if it's just a background SMS notification
      // The transaction itself was successful
    }
  }

  void _updateSMSStatus(bool success, String message) {
    if (mounted) {
      setState(() {
        _smsSent = success;
        _smsFailed = !success;
      });
      
      // Only show snackbar for failures (optional)
      if (!success) {
        debugPrint("SMS Status: $message");
        // You can choose not to show this to the user since it's background SMS
        // _showStatusSnackBar("Note: Could not send SMS notification", isError: false);
      }
    }
  }

  void _showStatusSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xFF8DC73F),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
            CircleAvatar(
              radius: 30,
              backgroundColor: primaryGreen,
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 10),
            Text("Successful", style: TextStyle(color: primaryGreen, fontSize: 18)),
            
            // Optional: Show SMS status icon
            if (_smsSent)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sms, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text("SMS Sent", style: TextStyle(color: Colors.green, fontSize: 12)),
                  ],
                ),
              ),
            
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text("-${_formatNumber(widget.amount)}.00",
                    style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 5),
                const Text("(ETB)", style: TextStyle(fontSize: 16, color: Colors.black)),
              ],
            ),
            const SizedBox(height: 40),
            const Divider(indent: 20, endIndent: 20),
            const SizedBox(height: 10),
            _detailRow("Transaction Number", _transactionID),
            _detailRow("Transaction Time:", _txTime),
            _detailRow("Transaction Type:", "Transfer To Bank"),
            _detailRow("Transaction To:", widget.accountName.toUpperCase()),
            _detailRow("Bank Account Number:", widget.accountNumber),
            _detailRow("Bank Name:", widget.bankName),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.qr_code_2, color: primaryGreen, size: 20),
                Text(" QR Code ",
                    style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold)),
                Icon(Icons.arrow_forward_ios, color: primaryGreen, size: 14),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 12),
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
                      side: BorderSide(color: primaryGreen.withOpacity(0.4), width: 2.0)),
                  spacing: const EdgeInsets.symmetric(horizontal: 4.0),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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