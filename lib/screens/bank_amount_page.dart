import 'package:flutter/material.dart';
import 'dart:async';

class BankAmountPage extends StatefulWidget {
  final String accountName;
  final String accountNumber;
  final String bankName;

  const BankAmountPage({
    super.key,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
  });

  @override
  State<BankAmountPage> createState() => _BankAmountPageState();
}

class _BankAmountPageState extends State<BankAmountPage> {
  String _amount = "";
  bool _showCursor = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    // 5. Blinking cursor logic
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _showCursor = !_showCursor;
      });
    });
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    super.dispose();
  }

  void _onKeyTap(String value) {
    setState(() {
      if (value == "back") {
        if (_amount.isNotEmpty) {
          _amount = _amount.substring(0, _amount.length - 1);
        }
      } else if (value == ".") {
        if (!_amount.contains(".")) {
          _amount += value;
        }
      } else {
        _amount += value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Transfer to Bank',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 1. Wider Container (+5 width logic via padding/margin)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA349E5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          // 2. CBE Icon leading
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 22,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset('images/cbe.png', errorBuilder: (c, e, s) => const Icon(Icons.account_balance)),
                            ),
                          ),
                          title: Text(
                            widget.accountName.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          subtitle: Text(
                            "${widget.bankName} (${widget.accountNumber})",
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Amount", style: TextStyle(color: Colors.black54, fontSize: 16)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    _amount,
                                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  // 5. Blinking Green Cursor
                                  Opacity(
                                    opacity: _showCursor ? 1.0 : 0.0,
                                    child: Container(
                                      width: 3,
                                      height: 28,
                                      color: const Color(0xFF8DC73F),
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text("(ETB)", style: TextStyle(color: Colors.grey, fontSize: 16)),
                                ],
                              ),
                              // 3. Thinner line with decreased opacity
                              Divider(thickness: 0.5, height: 30, color: Colors.grey.withOpacity(0.3)),
                              // 4. Balance text NOT bold
                              Text(
                                "Balance: 123,975.41(ETB)",
                                style: TextStyle(
                                  color: const Color(0xFF4A6572),
                                  fontWeight: FontWeight.normal, // Not bold
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CUSTOM KEYBOARD
          Container(
            padding: const EdgeInsets.all(3), // 5. Spacing around keyboard
            color: const Color(0xFFE0E0E0),
            height: 300,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _row(["1", "2", "3"]),
                      _row(["4", "5", "6"]),
                      _row(["7", "8", "9"]),
                      // 5. Wide 0 button below 7 & 8
                      Expanded(
                        child: Row(
                          children: [
                            _buildKey("0", flex: 2),
                            _buildKey(".", flex: 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // 5. Backspace above Transfer
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildKey("back", isAction: true),
                      Expanded(
                        flex: 3,
                        child: Material(
                          color: const Color(0xFF8DC73F).withOpacity(0.4),
                          child: InkWell(
                            onTap: () => print("Transferring $_amount"),
                            child: const Center(
                              child: RotatedBox(
                                quarterTurns: 0,
                                child: Text("Transfer",
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(List<String> keys) {
    return Expanded(
      child: Row(
        children: keys.map((k) => _buildKey(k)).toList(),
      ),
    );
  }

  Widget _buildKey(String label, {int flex = 1, bool isAction = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.all(3), // 5. Spacing between buttons
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: () => _onKeyTap(label),
            child: Center(
              child: label == "back"
                  ? const Icon(Icons.backspace_outlined, color: Colors.black54)
                  : Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
            ),
          ),
        ),
      ),
    );
  }
}
