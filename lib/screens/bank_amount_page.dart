import 'package:flutter/material.dart';

class BankAmountPage extends StatefulWidget {
  // These fields receive the data from Engage Page
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

  // Logic to handle custom keyboard taps
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
        title: const Text(
          'Transfer to Bank',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // SCROLLABLE TOP SECTION
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 1. Purple Info Card
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFA349E5), // Telebirr Purple
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: Icon(Icons.account_balance, color: Color(0xFFA349E5)),
                            ),
                          ),
                          title: Text(
                            widget.accountName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            "${widget.bankName} (${widget.accountNumber})",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        // White Amount Section
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
                              const Text(
                                "Amount",
                                style: TextStyle(color: Colors.black54, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Display entered amount or placeholder
                                  Text(
                                    _amount.isEmpty ? "" : _amount,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Text(
                                    "(ETB)",
                                    style: TextStyle(color: Colors.grey, fontSize: 16),
                                  ),
                                ],
                              ),
                              const Divider(thickness: 1, height: 30),
                              const Text(
                                "Balance: 123,975.41(ETB)",
                                style: TextStyle(
                                  color: Color(0xFF4A6572),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Add notes(optional)",
                      style: TextStyle(color: Color(0xFF8DC73F), fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CUSTOM KEYBOARD SECTION
          Container(
            color: const Color(0xFFF0F0F0),
            height: 260, // Fixed height for keyboard area
            child: Row(
              children: [
                // Numbers Grid
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildKeyRow(["1", "2", "3"]),
                      _buildKeyRow(["4", "5", "6"]),
                      _buildKeyRow(["7", "8", "9"]),
                      _buildKeyRow([".", "0", "back"]),
                    ],
                  ),
                ),
                // Transfer Button (Vertical Bar)
                Expanded(
                  flex: 1,
                  child: Material(
                    color: const Color(0xFFD6E8BC), // Light Green button
                    child: InkWell(
                      onTap: () {
                        print("Transfer Clicked: $_amount");
                      },
                      child: const Center(
                        child: Text(
                          "Transfer",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Expanded(
      child: Row(
        children: keys.map((key) {
          return Expanded(
            child: Material(
              color: Colors.white,
              child: InkWell(
                onTap: () => _onKeyTap(key),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200, width: 0.5),
                  ),
                  child: Center(
                    child: key == "back"
                        ? const Icon(Icons.backspace_outlined, size: 24)
                        : Text(
                            key,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
