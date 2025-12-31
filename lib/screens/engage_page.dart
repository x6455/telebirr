import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Map<String, String>> globalEngageList = [];

class EngagePage extends StatefulWidget {
  const EngagePage({super.key});

  @override
  State<EngagePage> createState() => _EngagePageState();
}

class _EngagePageState extends State<EngagePage> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _searchController = TextEditingController();

  final List<Map<String, String>> _accounts = [];
  List<Map<String, String>> _filteredAccounts = [];

  bool _upperCaseEnabled = false;

  static const _storageKey = 'saved_engage_accounts';

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    _searchController.addListener(_filterAccounts);
  }

  Future<void> _loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      setState(() {
        _accounts.addAll(
          decoded.map((e) => Map<String, String>.from(e)),
        );
        _filteredAccounts = List.from(_accounts);
        globalEngageList = List.from(_accounts);
      });
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, json.encode(_accounts));
  }

  void _saveAccount() {
    if (_nameController.text.isEmpty || _numberController.text.isEmpty) return;

    final account = {
      'name': _upperCaseEnabled
          ? _nameController.text.toUpperCase()
          : _nameController.text,
      'number': _numberController.text,
    };

    setState(() {
      _accounts.insert(0, account);
      _filteredAccounts.insert(0, account);
      globalEngageList.insert(0, account);
      _nameController.clear();
      _numberController.clear();
    });

    _saveToStorage();
  }

  void _deleteAccount(int index) {
    setState(() {
      final removed = _filteredAccounts.removeAt(index);
      _accounts.remove(removed);
      globalEngageList.remove(removed);
    });
    _saveToStorage();
  }

  void _editAccount(Map<String, String> account) {
    _nameController.text = account['name']!;
    _numberController.text = account['number']!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Account'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _nameController),
            const SizedBox(height: 10),
            TextField(controller: _numberController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                account['name'] = _upperCaseEnabled
                    ? _nameController.text.toUpperCase()
                    : _nameController.text;
                account['number'] = _numberController.text;
              });
              _saveToStorage();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _filterAccounts() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredAccounts = _accounts.where((account) {
        return account['name']!.toLowerCase().contains(query) ||
            account['number']!.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Engage',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          Row(
            children: [
              const Text('UPPER', style: TextStyle(color: Colors.black)),
              Checkbox(
                value: _upperCaseEnabled,
                onChanged: (v) => setState(() => _upperCaseEnabled = v!),
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Search
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search accounts',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            /// Input
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: 'Account Name',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveAccount,
                child: const Text('Save Account'),
              ),
            ),

            const SizedBox(height: 20),

            /// List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredAccounts.length,
              itemBuilder: (context, index) {
                final account = _filteredAccounts[index];
                return Dismissible(
                  key: ValueKey(account),
                  background: Container(color: Colors.red),
                  onDismissed: (_) => _deleteAccount(index),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(account['name']!),
                      subtitle: Text(account['number']!),
                      onTap: () => _editAccount(account),
                    ),
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
