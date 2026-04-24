import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart'; // Add this for permissions

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

  List<Map<String, String>> _accounts = [];
  List<Map<String, String>> _filteredAccounts = [];

  bool _upperCaseEnabled = false;
  static const _storageKey = 'saved_engage_accounts';

  @override
  void initState() {
    super.initState();
    _loadAccounts();
    _searchController.addListener(_filterAccounts);
  }

  // --- Persistence Logic ---

  Future<void> _loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      final List decoded = json.decode(jsonString);
      setState(() {
        _accounts = decoded.map((e) => Map<String, String>.from(e)).toList();
        _filteredAccounts = List.from(_accounts);
        globalEngageList = List.from(_accounts);
      });
    }
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, json.encode(_accounts));
    globalEngageList = List.from(_accounts);
  }

  // --- Backup & Restore Logic ---

  Future<void> _exportBackup() async {
  Future<void> _exportBackup() async {
  try {
    if (await _requestStoragePermission() != true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
      return;
    }

    String jsonContent = json.encode(_accounts);

    String fileName =
        'engage_backup_${DateTime.now().millisecondsSinceEpoch}.json';

    String path = "/storage/emulated/0/Download/$fileName";

    File file = File(path);
    await file.writeAsString(jsonContent);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved to Downloads: $fileName')),
      );
    }
  } catch (e) {
    debugPrint("Export error: $e");

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export backup: $e')),
      );
    }
  }
}
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 11+ (API 30+), we don't need explicit storage permission for app-specific directories
      // But for general storage access, we might need it
      if (await Permission.storage.isGranted) {
        return true;
      }
      
      var status = await Permission.storage.request();
      return status.isGranted;
    }
    // iOS handles permissions through file picker automatically
    return true;
  }

  Future<void> _importRestore() async {
    try {
      // Check permission for reading
      if (await _requestStoragePermission() != true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission denied')),
          );
        }
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: 'Select backup file to restore',
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        
        // Check if file exists
        if (!await file.exists()) {
          throw Exception('File does not exist');
        }
        
        String content = await file.readAsString();
        
        // Validate JSON format
        List decoded;
        try {
          decoded = json.decode(content);
        } catch (e) {
          throw Exception('Invalid JSON format');
        }
        
        // Validate data structure
        List<Map<String, String>> restoredAccounts = [];
        for (var item in decoded) {
          if (item is Map && item.containsKey('name') && item.containsKey('number')) {
            restoredAccounts.add(Map<String, String>.from(item));
          } else {
            throw Exception('Invalid account data structure');
          }
        }

        setState(() {
          _accounts = restoredAccounts;
          _filteredAccounts = List.from(_accounts);
        });

        await _saveToStorage();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Restored ${restoredAccounts.length} accounts successfully!'))
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No file selected'))
          );
        }
      }
    } catch (e) {
      debugPrint("Import error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to restore file: ${e.toString()}'))
        );
      }
    }
  }

  // --- UI Actions ---

  void _saveAccount() {
    if (_nameController.text.isEmpty || _numberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields'))
      );
      return;
    }

    final account = {
      'name': _upperCaseEnabled ? _nameController.text.toUpperCase() : _nameController.text,
      'number': _numberController.text,
    };

    setState(() {
      _accounts.insert(0, account);
      _filteredAccounts = List.from(_accounts);
      _nameController.clear();
      _numberController.clear();
    });

    _saveToStorage();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account saved successfully!'))
    );
  }

  void _deleteAccount(int index) {
    setState(() {
      final removed = _filteredAccounts.removeAt(index);
      _accounts.remove(removed);
    });
    _saveToStorage();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account deleted'))
    );
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
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                account['name'] = _upperCaseEnabled ? _nameController.text.toUpperCase() : _nameController.text;
                account['number'] = _numberController.text;
                _filteredAccounts = List.from(_accounts);
              });
              _saveToStorage();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account updated'))
              );
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
        title: const Text('Engage', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          // Backup Button
          IconButton(
            icon: const Icon(Icons.upload_file, color: Colors.blue), 
            onPressed: _exportBackup,
            tooltip: 'Export backup',
          ),
          // Restore Button
          IconButton(
            icon: const Icon(Icons.file_download, color: Colors.green), 
            onPressed: _importRestore,
            tooltip: 'Import backup',
          ),
          Row(
            children: [
              const Text('UPPER', style: TextStyle(color: Colors.black, fontSize: 12)),
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
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search accounts',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Account Name', 
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Account Number', 
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveAccount, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Account'),
              ),
            ),
            const SizedBox(height: 20),
            if (_filteredAccounts.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No accounts found'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredAccounts.length,
                itemBuilder: (context, index) {
                  final account = _filteredAccounts[index];
                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _deleteAccount(index),
                    child: Card(
                      elevation: 2,
                      child: ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(
                          account['name']!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(account['number']!),
                        trailing: const Icon(Icons.edit, size: 20, color: Colors.grey),
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