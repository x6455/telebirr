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
  
  late AnimationController _animationController;
  late Animation<double> _scrollAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8), 
    )..repeat(); 

    _scrollAnimation = Tween<double>(
      begin: 1.2,  // Start fully off-screen right
      end: -1.2,   // End fully off-screen left
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear, 
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
              
              // Top Logos and English selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('images/ethio.png', height: 25), 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Image.asset('images/telebirr.png', height: 25), 
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

              // Welcome text moving like a train (Vanishes at edges)
              ClipRect(
                child: AnimatedBuilder(
                  animation: _scrollAnimation,
                  builder: (context, child) {
                    return FractionalTranslation(
                      translation: Offset(_scrollAnimation.value, 0),
                      child: child,
                    );
                  },
                  child: const SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          "Welcome to telebirr SuperApp",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22, 
                            color: Color(0xFF008DCD), 
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        Text(
                          "All-in-One",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Color(0xFF008DCD)),
                        ),
                      ],
                    ),
                  ),
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

              // --- MOBILE NUMBER INPUT BOX ---
              SizedBox(
                width: double.infinity, 
                height: 55, // Fixed height for the "Box"
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.phone,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("+251 ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                        ],
                      ),
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
              ),

              const SizedBox(height: 40),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
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

              const Text(
                "Terms and Conditions", 
                style: TextStyle(color: Color(0xFF8DC73F)) 
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
