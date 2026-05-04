import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // ================= STORAGE =================

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

  // ================= PERMISSION =================

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      var status = await Permission.manageExternalStorage.request();
      if (status.isGranted) return true;

      if (await Permission.storage.isGranted) {
        return true;
      }

      status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  // ================= EXPORT =================

  Future<void> _exportBackup() async {
    try {
      if (!await _requestStoragePermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }

      String jsonContent = json.encode(_accounts);

      if (Platform.isAndroid) {
        try {
          final path = '/storage/emulated/0/Download/EngageBackups';
          final dir = Directory(path);

          if (!await dir.exists()) {
            await dir.create(recursive: true);
          }

          String fileName =
              'engage_backup_${DateTime.now().millisecondsSinceEpoch}.json';

          final file = File('$path/$fileName');
          await file.writeAsString(jsonContent);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saved to Download/EngageBackups')),
          );
          return;
        } catch (e) {
          debugPrint("Direct save failed: $e");
        }
      }

      // fallback
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save backup',
        fileName:
            'engage_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsString(jsonContent);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup saved')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  // ================= IMPORT =================

  Future<void> _importRestore() async {
    try {
      if (!await _requestStoragePermission()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);

        String content = await file.readAsString();
        List decoded = json.decode(content);

        List<Map<String, String>> restored = decoded
            .map((e) => Map<String, String>.from(e))
            .toList();

        setState(() {
          _accounts = restored;
          _filteredAccounts = List.from(_accounts);
        });

        await _saveToStorage();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restored ${restored.length} accounts')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Restore failed: $e')),
      );
    }
  }

  // ================= UI =================

  void _saveAccount() {
    if (_nameController.text.isEmpty ||
        _numberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all fields')),
      );
      return;
    }

    final account = {
      'name': _upperCaseEnabled
          ? _nameController.text.toUpperCase()
          : _nameController.text,
      'number': _numberController.text,
    };

    setState(() {
      _accounts.insert(0, account);
      _filteredAccounts = List.from(_accounts);
      _nameController.clear();
      _numberController.clear();
    });

    _saveToStorage();
  }

  void _deleteAccount(int index) {
    setState(() {
      final removed = _filteredAccounts.removeAt(index);
      _accounts.remove(removed);
    });
    _saveToStorage();
  }

  void _editAccount(Map<String, String> account) {
    _nameController.text = account['name']!;
    _numberController.text = account['number']!;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit'),
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
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
      _filteredAccounts = _accounts.where((a) {
        return a['name']!.toLowerCase().contains(query) ||
            a['number']!.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Engage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: _exportBackup,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _importRestore,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration:
                  const InputDecoration(hintText: 'Search'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration:
                  const InputDecoration(hintText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _numberController,
              decoration:
                  const InputDecoration(hintText: 'Number'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveAccount,
              child: const Text('Save'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredAccounts.length,
                itemBuilder: (c, i) {
                  final acc = _filteredAccounts[i];
                  return ListTile(
                    title: Text(acc['name']!),
                    subtitle: Text(acc['number']!),
                    onTap: () => _editAccount(acc),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteAccount(i),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
