import 'package:flutter/material.dart';
import 'package:telebirrbybr7/screens/main_screen.dart';

class PinEntryPage extends StatefulWidget {
  const PinEntryPage({super.key});

  @override
  State<PinEntryPage> createState() => _PinEntryPageState();
}

class _PinEntryPageState extends State<PinEntryPage> {
  String _pin = "";
  final int _pinLength = 5; // Telebirr typically uses 5 or 6 digits

  void _onNumberPress(String number) {
    if (_pin.length < _pinLength) {
      setState(() => _pin += number);
    }
    
    // Auto-navigate when PIN is complete
    if (_pin.length == _pinLength) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      });
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "Enter PIN",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 30),
          
          // PIN Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pinLength, (index) {
              bool isFilled = index < _pin.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled ? const Color(0xFF8DC73F) : Colors.transparent,
                  border: Border.all(
                    color: isFilled ? const Color(0xFF8DC73F) : Colors.black,
                    width: 1.5,
                  ),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 25),
          const Text(
            "Forgot PIN?",
            style: TextStyle(color: Color(0xFF8DC73F), fontSize: 16),
          ),
          
          const Spacer(),

          // Custom Number Pad
          Container(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                _buildNumberRow(['1', '2', '3']),
                _buildNumberRow(['4', '5', '6']),
                _buildNumberRow(['7', '8', '9']),
                // Bottom row: Empty, 0, Backspace
                Row(
                  children: [
                    const Expanded(child: SizedBox()), 
                    _buildNumberButton('0'),
                    Expanded(
                      child: InkWell(
                        onTap: _onBackspace,
                        child: const SizedBox(
                          height: 80,
                          child: Icon(Icons.backspace_outlined, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberRow(List<String> numbers) {
    return Row(
      children: numbers.map((n) => _buildNumberButton(n)).toList(),
    );
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: InkWell(
        onTap: () => _onNumberPress(number),
        splashColor: Colors.transparent, // No UI indication as requested
        highlightColor: Colors.transparent,
        child: Container(
          height: 80,
          alignment: Alignment.center,
          child: Text(
            number,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
