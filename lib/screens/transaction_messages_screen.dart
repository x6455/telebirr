import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telebirrbybr7/screens/transaction_detail_screen.dart';

class TransactionMessagesScreen extends StatefulWidget {
  const TransactionMessagesScreen({super.key});

  @override
  State<TransactionMessagesScreen> createState() => _TransactionMessagesScreenState();
}

class _TransactionMessagesScreenState extends State<TransactionMessagesScreen> {
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    // Using the key 'sent_balances' defined in your success_page.dart
    final List<String> history = prefs.getStringList('sent_balances') ?? [];

    setState(() {
      _transactions = history
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList()
          .reversed // Show the newest transactions at the top
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Transaction Message",
          style: TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: Colors.black, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? const Center(child: Text("No transactions found"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _transactions.length,
                  itemBuilder: (context, index) {
                    final tx = _transactions[index];
                    return _buildTransactionCard(tx);
                  },
                ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> tx) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TransactionDetailScreen(txData: tx),
        ),
      );
    },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8), // match your card's radius
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 4,
              offset: const Offset(0, 2), // only bottom shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF0056B3),
                    child: Icon(Icons.check, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Transfer to Bank",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "-${tx['amount_sent']}.00",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Perforated line (Ticket effect)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  _cutout(isLeft: true),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            (constraints.constrainWidth() / 8).floor(),
                            (index) => const SizedBox(
                              width: 4,
                              height: 1,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color(0xFFEEEEEE),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _cutout(isLeft: false),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _infoRow("Transaction Time:", tx['time'] ?? ""),
                  const SizedBox(height: 6),
                  _infoRow("Transaction To:", tx['accountName']?.toUpperCase() ?? ""),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


  Widget _cutout({required bool isLeft}) {
    return Container(
      height: 20,
      width: 10,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4), // Match screen background
        borderRadius: BorderRadius.only(
          topRight: isLeft ? const Radius.circular(12) : Radius.zero,
          bottomRight: isLeft ? const Radius.circular(12) : Radius.zero,
          topLeft: !isLeft ? const Radius.circular(12) : Radius.zero,
          bottomLeft: !isLeft ? const Radius.circular(12) : Radius.zero,
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
