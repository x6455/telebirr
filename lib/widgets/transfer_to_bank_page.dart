import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransferToBankPage extends StatefulWidget {
  const TransferToBankPage({super.key});

  @override
  State<TransferToBankPage> createState() => _TransferToBankPageState();
}

class _TransferToBankPageState extends State<TransferToBankPage> {
  // Use a controller to track input changes if you want to enable the button later
  final TextEditingController _accountController = TextEditingController();

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
        title: Text(
          'Transfer to Bank',
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Promotional Banner Area
            Container(
              margin: const EdgeInsets.all(16.0),
              width: double.infinity,
              height: 140, // Adjust height as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  // Using your existing banner asset or a placeholder
                  image: AssetImage('images/Banner1.jpg'), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Green Dots Indicator
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, size: 8, color: Colors.green),
                SizedBox(width: 5),
                Icon(Icons.circle_outlined, size: 8, color: Colors.green),
                SizedBox(width: 5),
                Icon(Icons.circle_outlined, size: 8, color: Colors.green),
                SizedBox(width: 5),
                Icon(Icons.circle_outlined, size: 8, color: Colors.green),
              ],
            ),

            const SizedBox(height: 20),

            // 2. Input Form Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select Bank Label
                  Text('Select Bank', style: _labelStyle()),
                  const SizedBox(height: 8),
                  // Select Bank Dropdown (Simulated)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Please Choose',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        ),
                        Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Account No Label
                  Text('Account No', style: _labelStyle()),
                  const SizedBox(height: 8),
                  // Account No Input
                  TextField(
                    controller: _accountController,
                    decoration: InputDecoration(
                      hintText: 'Enter Account Number',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Action disabled for now as per UI
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300, // Disabled look
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 3. Recent Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.delete_outline, color: Colors.grey.shade500, size: 20),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Recent List Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildRecentItem(
                    'Mrs Wagaye Kasa Alemu',
                    'Commercial Bank of Ethiopia (100072931166)',
                    'images/cbe.png', // Ensure this matches your asset name
                    isLast: false,
                  ),
                  _buildRecentItem(
                    'ZENEBECH HAILE GULUMA',
                    'Dashen Bank (5010657636011)',
                    'images/dashen.png',
                    isLast: false,
                  ),
                  _buildRecentItem(
                    'YOHANNES GETNET ABEBE...',
                    'Dashen Bank (0239945076011)',
                    'images/dashen.png',
                    isLast: false,
                  ),
                  _buildRecentItem(
                    'MILLION ABREHAM TESFAYE',
                    'Awash Bank (01320253636800)',
                    'images/Awash.png', // Assuming you have an Awash logo
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle() {
    return TextStyle(
      color: Colors.grey.shade600,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _buildRecentItem(String name, String details, String imagePath, {required bool isLast}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Image.asset(imagePath, width: 40, height: 40),
          title: Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            details,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
        if (!isLast)
          Divider(height: 1, thickness: 1, color: Colors.grey.shade100, indent: 70),
      ],
    );
  }
}
