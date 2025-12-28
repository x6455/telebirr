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

  // Colors based on your screenshots
  final Color _primaryGreen = const Color(0xFF8DC73F);
  final Color _purpleColor = const Color(0xFFA349E5);

  @override
  void initState() {
    super.initState();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
      }
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

  // --- NEW: THE BOTTOM SHEET FUNCTION ---
  void _showConfirmationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows it to take needed height
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 300, // Fixed height for the sheet
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA), // Slightly off-white background
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // 1. Close Button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // 2. Title
              const Text(
                "Transfer To Bank",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // 3. Amount Display
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    // Format amount to 2 decimal places if possible
                    double.tryParse(_amount)?.toStringAsFixed(2) ?? "0.00",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "ETB",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 4. Payment Method Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Method",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Wallet Icon
                          Icon(Icons.account_balance_wallet, color: _primaryGreen, size: 28),
                          const SizedBox(width: 15),
                          // Text Info
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
  void _showConfirmationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 420, // Adjusted height
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Text(
                "Transfer To Bank",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    double.tryParse(_amount)?.toStringAsFixed(2) ?? "0.00",
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Text("ETB", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 30),
              
              // --- THE UPDATED WHITE CONTAINER ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Payment Method text is now INSIDE the white box
                      const Text(
                        "Payment Method",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 12), 
                      Row(
                        children: [
                          Icon(Icons.account_balance_wallet, color: _primaryGreen, size: 30),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Balance",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "(Available Balance:ETB)",
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle, color: _primaryGreen, size: 24),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Transfer",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    const Color themeBgColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: themeBgColor,
      appBar: AppBar(
        backgroundColor: themeBgColor,
        elevation: 0,
        title: const Text(
          'Transfer to Bank',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 1, bottom: 16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: _purpleColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          leading: Container(
                            width: 35,
                            height: 35,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Image.asset(
                                'images/cbe.png',
                                errorBuilder: (c, e, s) =>
                                    Icon(Icons.account_balance, color: _purpleColor),
                              ),
                            ),
                          ),
                          title: Text(
                            widget.accountName.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
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
                              const Text("Amount", style: TextStyle(color: Colors.black, fontSize: 16)),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    _amount,
                                    style: const TextStyle(
                                        fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  const SizedBox(width: 2),
                                  Opacity(
                                    opacity: _showCursor ? 1.0 : 0.0,
                                    child: Container(
                                      width: 1.5,
                                      height: 32,
                                      color: _primaryGreen,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text("(ETB)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                              Divider(thickness: 0.5, height: 30, color: Colors.grey.withOpacity(0.2)),
                              const Text(
                                "Balance: 123,975.41(ETB)",
                                style: TextStyle(
                                  color: Color(0xFF4A6572),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Add notes(optional)",
                      style: TextStyle(color: _primaryGreen, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CUSTOM KEYBOARD
          Container(
            padding: const EdgeInsets.all(3),
            color: themeBgColor,
            height: 235,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _row(["1", "2", "3"]),
                      _row(["4", "5", "6"]),
                      _row(["7", "8", "9"]),
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
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildKey("back", isAction: true),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          child: Material(
                            color: (_amount.isNotEmpty &&
                                    double.tryParse(_amount) != null &&
                                    double.parse(_amount) > 0)
                                ? _primaryGreen
                                : _primaryGreen.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                            child: InkWell(
                              // --- UPDATED: CALLS THE BOTTOM SHEET FUNCTION ---
                              onTap: (_amount.isNotEmpty &&
                                      double.tryParse(_amount) != null &&
                                      double.parse(_amount) > 0)
                                  ? _showConfirmationBottomSheet
                                  : null,
                              child: const Center(
                                child: Text("Transfer",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
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
        margin: const EdgeInsets.all(3),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: () => _onKeyTap(label),
            child: Center(
              child: label == "back"
                  ? const Icon(Icons.backspace_outlined, color: Colors.black54)
                  : Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}
