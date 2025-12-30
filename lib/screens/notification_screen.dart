import 'package:flutter/material.dart';
import 'package:telebirrbybr7/screens/transaction_messages_screen.dart'; // Ensure this path is correct

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5, // Subtle shadow as seen in the screenshot
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          _NotificationTile(
            icon: Icons.settings_outlined,
            color: const Color(0xFF2196F3), // System Blue
            title: 'System Information',
            onTap: () {
              // Navigation for System Info can be added here
            },
          ),
          const Divider(height: 1, indent: 70),
          _NotificationTile(
            icon: Icons.mail_outline,
            color: const Color(0xFF4CAF50), // Transaction Green
            title: 'Transaction Message',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionMessagesScreen(),
                ),
              );
            },
          ),
          const Divider(height: 1, indent: 70),
          _NotificationTile(
            icon: Icons.percent_outlined, // Matches the % icon in screenshot
            color: const Color(0xFFFFA726), // Promotion Orange
            title: 'Promotion News',
            onTap: () {
              // Navigation for Promotion News can be added here
            },
          ),
          const Divider(height: 1, indent: 70),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const _NotificationTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15, 
          color: Colors.black87,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios, 
        color: Color(0xFFBDBDBD), // Light grey arrow
        size: 14,
      ),
    );
  }
}