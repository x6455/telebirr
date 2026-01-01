import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
    
    // Convert JSON strings back to Maps and reverse to show newest first
    setState(() {
      _history = historyStrings
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList()
          .reversed
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF0089CF);
    const Color telebirrGreen = Color(0xFF8DC73F);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
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
          
          // Summary Row (Static values to match UI)
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

          // Transaction List
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _history.isEmpty 
                ? const Center(child: Text("No records found"))
                : ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final tx = _history[index];
                      return _buildTransactionItem(tx);
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
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(color: isActive ? Colors.white : color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> tx) {
    // Extracting data from your SuccessPage format
    final String amount = tx['amount_sent'] ?? "0.00";
    final String time = tx['time'] ?? ""; // format: yyyy/MM/dd HH:mm:ss
    final String dateHeader = time.split(' ')[0].substring(0, 7).replaceAll('/', '-'); // Gets "2026-01"

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Header (Simplified logic: showing it for every item or group by date)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(dateHeader, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        Container(
          color: Colors.white,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.more_horiz, color: Colors.orange, size: 30),
            ),
            title: const Text("Transfer Money", style: TextStyle(fontSize: 14)),
            subtitle: Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            trailing: Text(
              "-$amount.00", 
              style: const TextStyle(color: Color(0xFF0089CF), fontWeight: FontWeight.bold, fontSize: 16)
            ),
          ),
        ),
        const Divider(height: 1, indent: 70),
      ],
    );
  }
}
