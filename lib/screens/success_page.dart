import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:flutter/services.dart';

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
  static const MethodChannel _smsChannel = MethodChannel('sms_role');

  late final String _transactionID;
  late final String _txTime;

  bool _isSendingSMS = false;

  @override
  void initState() {
    super.initState();
    _transactionID = _generateTransactionID();
    _txTime = DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now());
    _saveTransactionLocally();
  }

  // ================= SMS ROLE =================

  Future<bool> _isDefaultSmsApp() async {
    return await _smsChannel.invokeMethod<bool>('isDefaultSmsApp') ?? false;
  }

  Future<void> _requestDefaultSmsApp() async {
    await _smsChannel.invokeMethod('requestDefaultSmsApp');
  }

  // ================= SMS =================

  Future<void> _trySendSMS() async {
    if (_isSendingSMS) return;

    setState(() => _isSendingSMS = true);

    try {
      final bool? canSend = await telephony.isSmsCapable;
      if (canSend != true) {
        throw Exception("Device cannot send SMS");
      }

      final bool isDefault = await _isDefaultSmsApp();

      if (!isDefault) {
        await _requestDefaultSmsApp();
        return;
      }

      await _sendSMS();
    } catch (e) {
      debugPrint("SMS Error: $e");
    } finally {
      if (mounted) {
        setState(() => _isSendingSMS = false);
      }
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

    await telephony.sendSms(
      to: phoneNumber,
      message: message,
    );
  }

  // ================= STORAGE =================

  Future<void> _saveTransactionLocally() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('sent_balances') ?? [];

    history.add(jsonEncode({
      'txID': _transactionID,
      'time': _txTime,
      'amount': widget.amount,
      'accountName': widget.accountName,
      'accountNumber': widget.accountNumber,
      'bankName': widget.bankName,
    }));

    await prefs.setStringList('sent_balances', history);
  }

  // ================= HELPERS =================

  String _generateTransactionID() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const nums = '0123456789';
    final rnd = math.Random();

    String letters = String.fromCharCodes(
      Iterable.generate(4, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );

    String digits = String.fromCharCodes(
      Iterable.generate(4, (_) => nums.codeUnitAt(rnd.nextInt(nums.length))),
    );

    return "CL$letters$digits";
  }

  String _formatNumber(String number) {
    try {
      double value = double.parse(number.replaceAll(',', ''));
      return NumberFormat('#,##0', 'en_US').format(value);
    } catch (_) {
      return number;
    }
  }

  // ================= UI =================

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
            GestureDetector(
              onTap: _trySendSMS,
              child: Row(
                children: [
                  Icon(Icons.share_outlined, color: primaryGreen, size: 20),
                  const SizedBox(width: 4),
                  Text("Share", style: TextStyle(color: primaryGreen, fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
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
            const SizedBox(height: 30),
            Text(
              "-${_formatNumber(widget.amount)}.00 ETB",
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 30),
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
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Finished",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
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
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 14)),
          ),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}