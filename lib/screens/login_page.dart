import 'package:flutter/material.dart';
import 'package:telebirrbybr7/screens/main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Matches the number in your screenshot
  final TextEditingController _controller = TextEditingController(text: "961011887");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The light mint/green background from your image
      backgroundColor: const Color(0xFFF3F9E9), 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Top Logos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network('https://upload.wikimedia.org/wikipedia/en/b/b3/Ethio_telecom_logo.png', height: 40, errorBuilder: (c, e, s) => const Icon(Icons.business)),
                  const Text("English ▼", style: TextStyle(fontWeight: FontWeight.bold)),
                  Image.network('https://upload.wikimedia.org/wikipedia/commons/b/bc/Telebirr_Logo.png', height: 40, errorBuilder: (c, e, s) => const Icon(Icons.account_balance_wallet)),
                ],
              ),
              
              const SizedBox(height: 60),

              // Welcome Text
              const Text(
                "Welcome to telebirr SuperA",
                style: TextStyle(fontSize: 22, color: Color(0xFF008DCD), fontWeight: FontWeight.w600),
              ),
              const Text(
                "All-in-One",
                style: TextStyle(fontSize: 18, color: Color(0xFF008DCD)),
              ),

              const SizedBox(height: 30),

              // Login Label with Green Underline
              Column(
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 3,
                    width: 50,
                    color: const Color(0xFF8DC73F), // telebirr green
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Mobile Number Input
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Mobile Number", style: TextStyle(color: Colors.grey, fontSize: 16)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    child: Text("+251 ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF9F9F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to MainScreen and clear navigation stack
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008DCD), // telebirr blue
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Next", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),

              const SizedBox(height: 25),

              // Footer Links
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account ? "),
                  Text("Create New Account", style: TextStyle(color: Colors.lightGreen.shade700, fontWeight: FontWeight.bold)),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("teleHub", style: TextStyle(color: Colors.lightGreen.shade700, fontSize: 16)),
                  Text("Help", style: TextStyle(color: Colors.lightGreen.shade700, fontSize: 16)),
                ],
              ),

              const SizedBox(height: 60),

              const Text("Terms and Conditions", style: TextStyle(color: Color(0xFF8DC73F), decoration: TextDecoration.underline)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
