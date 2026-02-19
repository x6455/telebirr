import 'package:flutter/material.dart';
import 'package:telebirrbybr7/screens/main_screen.dart';
import 'package:telebirrbybr7/screens/pin_entry_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController(text: "961011887");
  
// 1. Change the Animation type to double for easier pixel control
late AnimationController _animationController;
late Animation<double> _scrollAnimation;

@override
void initState() {
  super.initState();
  
  _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8), // Adjust speed (higher = slower train)
  )..repeat(); // Removed reverse: true so it loops forward only

  _scrollAnimation = Tween<double>(
    begin: 1.0,  // Start position (1.0 = far right)
    end: -1.0,   // End position (-1.0 = far left)
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.linear, // Constant speed like a train
  ));
}


  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F9E9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const SizedBox(height: 10),
              
              // 1 & 2. Top Logos and English selector positioning
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('images/ethio.png', height: 25), // Left Logo
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset('images/telebirr.png', height: 25), // Right Logo
                      const SizedBox(height: 4),
                      const Text(
                        "English ▼",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 60),

              // 4. Animated "Welcome" text moving right to left
              SlideTransition(
                position: _slideAnimation,
                child: const Column(
                  children: [
                    Text(
                      "Welcome to telebirr SuperApp",
                      style: TextStyle(
                        fontSize: 22, 
                        color: Color(0xFF008DCD), 
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Text(
                      "All-in-One",
                      style: TextStyle(fontSize: 18, color: Color(0xFF008DCD)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Column(
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 3,
                    width: 50,
                    color: const Color(0xFF8DC73F),
                  ),
                ],
              ),

              const SizedBox(height: 50),

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
                    child: Text("+251 ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
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

              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  // Inside LoginPage Next Button
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const PinEntryPage()),
  );
},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008DCD),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text("Next", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account ? "),
                  Text(
                    "Create New Account", 
                    style: TextStyle(color: Colors.lightGreen.shade700, fontWeight: FontWeight.bold)
                  ),
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

              // 3. Terms and Versioning info
              const Text(
                "Terms and Conditions", 
                style: TextStyle(color: Color(0xFF8DC73F)) // No underline
              ),
              const SizedBox(height: 5),
              const Text(
                "@2023 ethiotelecom. All rights reserved 1.0.0 version",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
