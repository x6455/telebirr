import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sms_sender.dart'; // Our MethodChannel helper

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
  late final String _transactionID;
  late final String _txTime;
  bool _smsSent = false;
  bool _smsFailed = false;

  @override
  void initState() {
    super.initState();
    _transactionID = _generateTransactionID();
    _txTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
    _saveTransactionLocally();
    Future.delayed(const Duration(seconds: 1), _sendSMS);
  }

  String _generateTransactionID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const nums = '0123456789';
    final rnd = DateTime.now().millisecondsSinceEpoch % 100000;
    return "TX$chars$rnd";
  }

  Future<void> _saveTransactionLocally() async {
    final prefs = await SharedPreferences.getInstance();

    Map<String, String> transactionData = {
      'txID': _transactionID,
      'time': _txTime,
      'amount': widget.amount,
      'accountName': widget.accountName,
      'accountNumber': widget.accountNumber,
      'bankName': widget.bankName,
      'smsSent': _smsSent.toString(),
    };

    List<String> history = prefs.getStringList('sent_balances') ?? [];
    history.add(jsonEncode(transactionData));
    await prefs.setStringList('sent_balances', history);
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
      await SmsSender.sendSms(phoneNumber, message);
      _updateSMSStatus(true, "SMS sent successfully");
    } catch (e) {
      _updateSMSStatus(false, "SMS failed: $e");
    }
  }

  void _updateSMSStatus(bool success, String message) async {
    if (!mounted) return;
    setState(() {
      _smsSent = success;
      _smsFailed = !success;
    });

    // Update SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('sent_balances') ?? [];
    if (history.isNotEmpty) {
      String lastTx = history.last;
      Map<String, dynamic> txData = jsonDecode(lastTx);
      txData['smsSent'] = success.toString();
      history[history.length - 1] = jsonEncode(txData);
      await prefs.setStringList('sent_balances', history);
    }

    debugPrint("SMS Status: $message");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Success"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_smsSent ? Icons.sms : Icons.sms_failed,
                color: _smsSent ? Colors.green : Colors.orange, size: 60),
            const SizedBox(height: 12),
            Text(_smsSent ? "SMS Sent" : "SMS Not Sent",
                style: TextStyle(
                    color: _smsSent ? Colors.green : Colors.orange,
                    fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }
}