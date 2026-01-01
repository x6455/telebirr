import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart'; // Useful for formatting the current date
import '../screens/transaction_detail_screen.dart';
import 'package:intl/intl.dart';

class TransactionRecordsPage extends StatefulWidget {
  const TransactionRecordsPage({super.key});

  @override
  State<TransactionRecordsPage> createState() => _TransactionRecordsPageState();
}

class _TransactionRecordsPageState extends State<TransactionRecordsPage> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactionHistory();
  }

  Future<void> _loadTransactionHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> historyStrings = prefs.getStringList('sent_balances') ?? [];
    
    setState(() {
      _history = historyStrings
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList()
          .reversed // Show newest first
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0089CF);
    
    // Get current date for the header
    final String todayDate = DateFormat('yyyy-dd').format(DateTime.now());

    return Scaffold(
      // 1. Page background set to white
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Transaction Records', 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(icon: const Icon(Icons.more_horiz, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.cancel_outlined, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Toggle Buttons Row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _buildToggleButton("Main Account Transaction", true, primaryBlue)),
                const SizedBox(width: 12),
                Expanded(child: _buildToggleButton("Reward Transaction", false, primaryBlue)),
              ],
            ),
          ),
          
          // Summary Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text("Pay: -21263.90  Income: 21174.00  Total: -89.90",
                    style: TextStyle(fontSize: 12, color: Colors.black87)),
                const Spacer(),
                Icon(Icons.calendar_today_outlined, color: Colors.orange.shade300, size: 20),
              ],
            ),
          ),

          // 2. Single Date Header at the Top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                todayDate,
                style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14),
              ),
            ),
          ),

          // Transaction List with Alternating Colors
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _history.isEmpty 
                ? const Center(child: Text("No records found"))
                : ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final tx = _history[index];
                      // 3. Logic for Alternating Colors (Zebra Striping)
                      // index 0 is white, index 1 is light gray, index 2 is white...
                      final Color bgColor = (index % 2 == 0) 
                          ? Colors.white 
                          : const Color(0xFFF9F9F9); // Very subtle gray

                      return _buildTransactionItem(tx, bgColor);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? color : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isActive ? Colors.white : color, 
          fontSize: 16, 
          fontWeight: FontWeight.normal, // Font property for the text
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> tx, Color backgroundColor) {
    final String amount = tx['amount_sent'] ?? "0.00";
   final String time = tx['time'] ?? "";
String timeWithoutSeconds = time;
try {
  if (time.isNotEmpty) {
    // Remove seconds from the end
    timeWithoutSeconds = time.replaceAll(RegExp(r':\d{2}$'), '');
  }
} catch (e) {
  // Keep original if something goes wrong
}

    return Container(
      color: backgroundColor,
      child: InkWell(
        // This makes the row clickable and navigates to the detail screen
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionDetailScreen(txData: tx),
            ),
          );
        },
        child: Column(
          children: [
            ListTile(
  leading: Container(
    width: 36, // Size of the circle
    height: 36, // Size of the circle
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.orange, // Border color
        width: 3, // 3px border width
      ),
    ),
    child: const Icon(
      Icons.more_horiz,
      color: Colors.orange,
      size: 30, // Slightly smaller to fit inside the circle
    ),
  ),
              title: const Text("Transfer Money", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,), ),
              subtitle: Text(time, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              trailing: Text(
                "-$amount",
                style: const TextStyle(
                    color: Color(0xFFFBBB47),
                    fontWeight: FontWeight.normal,
                    fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
