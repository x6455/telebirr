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
  
  // VAT and Service Charge Calculations
  late final double _originalAmount;
  late final double _vatAmount;
  late final double _serviceCharge;
  late final double _totalAmount;
  late final String _displayAmount; // For UI display

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
    
    // Calculate VAT and Service Charge
    _originalAmount = double.parse(widget.amount);
    _calculateAmounts();
    
    _transactionID = _generateTransactionID();
    _txTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
    _saveTransactionLocally();
    // Delay SMS sending to ensure UI is loaded first
    Future.delayed(const Duration(seconds: 2), _trySendSMS);
  }

  void _calculateAmounts() {
    // Calculate 0.3% VAT
    _vatAmount = (_originalAmount * 0.003);
    
    // Calculate 15% of VAT as service charge
    _serviceCharge = (_vatAmount * 0.15);
    
    // Calculate total amount (original + VAT + service charge)
    double rawTotal = _originalAmount + _vatAmount + _serviceCharge;
    
    // Round to nearest whole number (zero cents)
    _totalAmount = rawTotal.roundToDouble();
    
    // Calculate how much we need to adjust to make total round number
    double adjustment = _totalAmount - rawTotal;
    
    // Adjust service charge to compensate (small adjustment)
    double adjustedServiceCharge = _serviceCharge + adjustment;
    
    // Ensure service charge is not negative (edge case for very small amounts)
    if (adjustedServiceCharge < 0) {
      adjustedServiceCharge = 0;
      _totalAmount = (_originalAmount + _vatAmount).roundToDouble();
    }
    
    // Update final values
    _serviceCharge = double.parse(adjustedServiceCharge.toStringAsFixed(2));
    _totalAmount = double.parse(_totalAmount.toStringAsFixed(2));
    
    // Display amount (total amount to show in UI)
    _displayAmount = _totalAmount.toStringAsFixed(0); // Remove cents for display
  }

  Future<void> _saveTransactionLocally() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> transactionData = {
      'txID': _transactionID,
      'time': _txTime,
      'amount_sent': widget.amount, // Original amount
      'amount_display': _displayAmount, // Display amount (with VAT)
      'vat_amount': _vatAmount.toStringAsFixed(2),
      'service_charge': _serviceCharge.toStringAsFixed(2),
      'total_amount': _totalAmount.toStringAsFixed(2),
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
        "Original Amount: ${widget.amount}.00 ETB\n"
        "VAT (0.3%): ${_vatAmount.toStringAsFixed(2)} ETB\n"
        "Service Charge: ${_serviceCharge.toStringAsFixed(2)} ETB\n"
        "Total: -${_displayAmount}.00 ETB\n"
        "Bank: ${widget.bankName}\n"
        "ID: $_transactionID\n"
        "Time: $_txTime";

    try {
      // Use statusListener for newer versions of telephony package
      await telephony.sendSms(
        to: phoneNumber,
        message: message,
        statusListener: (SendStatus status) {
          // Handle different statuses
          if (status == SendStatus.SENT || status == SendStatus.DELIVERED) {
            _updateSMSStatus(true, "SMS sent successfully");
          } else {
            _updateSMSStatus(false, "SMS failed to send");
          }
        },
      );
      
      // If we get here without error, consider it sent
      // The statusListener will update the actual status
      _updateSMSStatus(true, "SMS sending initiated");
      
    } catch (e) {
      _updateSMSStatus(false, "Failed: ${e.toString()}");
      
      // Optionally, you can log the error but continue
      debugPrint("SMS Error: $e");
    }
  }

  void _updateSMSStatus(bool success, String message) {
    if (mounted) {
      setState(() {
        _smsSent = success;
        _smsFailed = !success;
      });
      
      // Update shared preferences with SMS status
      _updateTransactionSMSStatus(success);
      
      // Only show snackbar for failures (optional)
      if (!success) {
        debugPrint("SMS Status: $message");
      } else {
        debugPrint("SMS Status: Success - $message");
      }
    }
  }

  Future<void> _updateTransactionSMSStatus(bool smsSent) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('sent_balances') ?? [];
    
    if (history.isNotEmpty) {
      // Get the last transaction (the one we just added)
      String lastTx = history.last;
      Map<String, dynamic> txData = jsonDecode(lastTx);
      txData['smsSent'] = smsSent.toString();
      history[history.length - 1] = jsonEncode(txData);
      await prefs.setStringList('sent_balances', history);
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
            if (_smsFailed)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sms_failed, color: Colors.orange, size: 16),
                    const SizedBox(width: 4),
                    Text("SMS Not Sent", style: TextStyle(color: Colors.orange, fontSize: 12)),
                  ],
                ),
              ),
            
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text("-${_formatNumber(_displayAmount)}.00",
                    style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 5),
                const Text("(ETB)", style: TextStyle(fontSize: 16, color: Colors.black)),
              ],
            ),
            
            // Show breakdown of charges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Column(
                children: [
                  _chargeRow("Original Amount:", "${widget.amount}.00 ETB"),
                  _chargeRow("VAT (0.3%):", "${_vatAmount.toStringAsFixed(2)} ETB"),
                  _chargeRow("Service Charge:", "${_serviceCharge.toStringAsFixed(2)} ETB"),
                  const Divider(),
                  _chargeRow("Total Deducted:", "-${_displayAmount}.00 ETB", isBold: true),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
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

  Widget _chargeRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal
          )),
          Text(value, style: TextStyle(
            color: isBold ? Colors.black : Colors.grey[800],
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal
          )),
        ],
      ),
    );
  }
}
