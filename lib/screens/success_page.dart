import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:intl/intl.dart';
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
  late final String _transactionID;
  late final String _txTime;
  bool _smsSent = false;
  bool _smsFailed = false;
  bool _isSendingSMS = false;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _transactionID = _generateTransactionID();
    _txTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
    _saveTransactionLocally();

    // Attempt SMS automatically after small delay
    Future.delayed(const Duration(seconds: 1), _trySendSMS);
  }

  double _roundToZeroCents(double value) => value.roundToDouble();

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
      'smsSent': _smsSent.toString(),
    };

    List<String> history = prefs.getStringList('sent_balances') ?? [];
    history.add(jsonEncode(transactionData));
    await prefs.setStringList('sent_balances', history);
  }

  Future<void> _trySendSMS() async {
    if (_isSendingSMS) return;

    setState(() {
      _isSendingSMS = true;
      _errorMessage = "";
    });

    try {
      // Request SMS permissions
      bool permissionsGranted = (await telephony.requestSmsPermissions) ?? false;
      if (!permissionsGranted) {
        _updateSMSStatus(false, "SMS permission denied.");
        return;
      }

      // Check SMS capability
      final bool? canSend = await telephony.isSmsCapable;
      if (canSend != true) throw Exception("Device cannot send SMS");

      // Send SMS automatically
      await _sendSMS();
    } catch (e) {
      _updateSMSStatus(false, "Error: $e");
      debugPrint("SMS Error: $e");
    } finally {
      setState(() => _isSendingSMS = false);
    }
  }

  Future<void> _sendSMS() async {
    final String phoneNumber = "0961011887"; // Replace with recipient
    final String message =
        "Telebirr Transfer Success\n"
        "To: ${widget.accountName}\n"
        "Amount: -${widget.amount}.00 ETB\n"
        "Bank: ${widget.bankName}\n"
        "ID: $_transactionID\n"
        "Time: $_txTime";

    try {
      await telephony.sendSms(to: phoneNumber, message: message);
      _updateSMSStatus(true, "SMS sent successfully.");
    } catch (e) {
      _updateSMSStatus(false, "Failed to send SMS: $e");
    }
  }

  void _updateSMSStatus(bool success, String message) {
    if (!mounted) return;
    setState(() {
      _smsSent = success;
      _smsFailed = !success;
      _errorMessage = message;
    });
    _updateTransactionSMSStatus(success);
    debugPrint("SMS Status: $message");
  }

  Future<void> _updateTransactionSMSStatus(bool smsSent) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('sent_balances') ?? [];
    if (history.isNotEmpty) {
      String lastTx = history.last;
      Map<String, dynamic> txData = jsonDecode(lastTx);
      txData['smsSent'] = smsSent.toString();
      history[history.length - 1] = jsonEncode(txData);
      await prefs.setStringList('sent_balances', history);
    }
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
      double value = double.parse(number.replaceAll(',', ''));
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
        title: Text("Transaction Success", style: TextStyle(color: primaryGreen)),
      ),
      body: SafeArea(
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

            if (_isSendingSMS)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Sending SMS...", style: TextStyle(color: Colors.blue)),
              ),
            if (_smsSent && !_isSendingSMS)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("SMS Sent ✓", style: TextStyle(color: Colors.green)),
              ),
            if (_smsFailed && !_isSendingSMS)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            const SizedBox(height: 20),
            Text("-${_formatNumber(charges['total']!.toString())}.00 ETB",
                style: const TextStyle(fontSize: 40)),

            const SizedBox(height: 20),
            _detailRow("Transaction Number", _transactionID),
            _detailRow("Transaction Time", _txTime),
            _detailRow("Transaction Type", "Transfer To Bank"),
            _detailRow("Transaction To", widget.accountName.toUpperCase()),
            _detailRow("Bank Account Number", widget.accountNumber),
            _detailRow("Bank Name", widget.bankName),

            const Spacer(),
            SizedBox(
              width: 200,
              height: 40,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Finished", style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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