import 'package:flutter/material.dart';

class IndividualTransferPage extends StatelessWidget {
  const IndividualTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Send Money to Individual',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Green Promotion Banner
            Container(
              margin: const EdgeInsets.all(16),
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8CC644), Color(0xFF5E8A24)],
                ),
              ),
              child: Stack(
                children: [
                   // Replace with your actual banner image asset
                   const Center(child: Text("Invite Banner Asset Here", style: TextStyle(color: Colors.white))),
                ],
              ),
            ),

            // 2. Input Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Please Enter Mobile Number", 
                    style: TextStyle(color: Colors.black87, fontSize: 14)),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      prefixText: "+251 ",
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.qr_code_scanner, color: Colors.lightGreen[600]),
                          const SizedBox(width: 12),
                          Icon(Icons.contact_phone_outlined, color: Colors.lightGreen[600]),
                          const SizedBox(width: 12),
                        ],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD1E4F3), // Light blue from screenshot
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Next", 
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Recent Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Recent", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Icon(Icons.delete_outline, color: Colors.grey[400]),
                ],
              ),
            ),
            _buildRecentTile("Hewan", Colors.amber),
            _buildRecentTile("TEWABE", Colors.amber),
            _buildRecentTile("Abera", Colors.amber),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTile(String name, Color avatarColor) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: avatarColor,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name, style: const TextStyle(fontSize: 15)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
