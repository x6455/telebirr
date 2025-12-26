import 'package:flutter/material.dart';

class EngagePage extends StatefulWidget {
  const EngagePage({super.key});

  @override
  State<EngagePage> createState() => _EngagePageState();
}

class _EngagePageState extends State<EngagePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  
  // List to store saved accounts
  final List<Map<String, String>> _recentAccounts = [];

  void _saveAccount() {
    if (_nameController.text.isNotEmpty && _numberController.text.isNotEmpty) {
      setState(() {
        _recentAccounts.insert(0, {
          'name': _nameController.text,
          'number': _numberController.text,
        });
        // Clear inputs after saving
        _nameController.clear();
        _numberController.clear();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account Saved Successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Engage', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Account Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Account Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(2, 135, 208, 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Save Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            const Text('Recent Saved Accounts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // Recent List
            _recentAccounts.isEmpty
                ? const Center(child: Text("No saved accounts yet", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recentAccounts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color.fromRGBO(141, 199, 63, 1),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(_recentAccounts[index]['name']!),
                          subtitle: Text(_recentAccounts[index]['number']!),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
