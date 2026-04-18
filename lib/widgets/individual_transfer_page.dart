import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';

class IndividualTransferPage extends StatefulWidget {
  const IndividualTransferPage({super.key});

  @override
  State<IndividualTransferPage> createState() => _IndividualTransferPageState();
}

class _IndividualTransferPageState extends State<IndividualTransferPage> {
  // Slider Logic
  int _currentIndex = 0;
  final List<String> sliderImages = [
    'images/Banner1.jpg',
    'images/Banner2.jpg',
    'images/Banner3.jpg',
    'images/Banner4.jpg',
    'images/Banner5.jpg',
  ];

  // Input & Button Logic
  final TextEditingController _numberController = TextEditingController();
  bool _isButtonEnabled = false;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _numberController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      // Enables button only if exactly 9 digits are entered
      _isButtonEnabled = _numberController.text.length == 9;
    });
  }

  Future<void> _handleNext() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    // Show floating loader with GIF
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.1), // light gray overlay feel
      builder: (_) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Image.asset(
              'images/loading.gif',
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
    );

    // Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Close loader (only if still mounted)
    if (mounted) Navigator.of(context, rootNavigator: true).pop();

    setState(() => _isLoading = false);

    // Here you can add navigation or further logic after the 3 seconds
    // For now, just show a snackbar that it's complete
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Number verified')),
      );
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Send Money to Individual',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Sliding Banners Logic (Custom dots indicator like SuccessPage)
            const SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 39 / 9,
                viewportFraction: 0.9,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: sliderImages.map((imagePath) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Custom Slider Indicator (like SuccessPage)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(sliderImages.length, (i) {
                  final isActive = i == _currentIndex;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    width: 8.0,
                    height: 8.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 0.8),
                    ),
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 50),
                        width: isActive ? 4.0 : 0,
                        height: isActive ? 4.0 : 0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 10),

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
                    controller: _numberController,
                    keyboardType: TextInputType.phone,
                    maxLength: 9,
                    enabled: !_isLoading,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                      counterText: "",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, top: 14),
                        child: Text(
                          "+251 ",
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.qr_code_scanner,
                              color: Colors.lightGreen[600]),
                          const SizedBox(width: 12),
                          Icon(Icons.contact_phone_outlined,
                              color: Colors.lightGreen[600]),
                          const SizedBox(width: 12),
                        ],
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightGreen[400]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // BUTTON LOGIC - No UI changes
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (_isButtonEnabled && !_isLoading) ? _handleNext : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(2, 135, 208, 1),
                        disabledBackgroundColor: const Color.fromRGBO(2, 135, 208, 0.25),
                        disabledForegroundColor: Colors.white,
                        elevation: _isButtonEnabled ? 2 : 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Next",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Recent Section with 5 more names (8 total)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Recent",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      // Show delete confirmation
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear Recents'),
                          content: const Text('Remove all recent contacts?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Clear recents logic would go here
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Recents cleared')),
                                );
                              },
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Icon(Icons.delete_outline, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            
            // Original 3 names + 5 new names (8 total)
            _buildRecentTile("Hewan", Colors.amber),
            _buildRecentTile("TEWABE", Colors.amber),
            _buildRecentTile("Abera", Colors.amber),
            
            // 5 Additional Names
            _buildRecentTile("Biruk", Colors.blue),
            _buildRecentTile("Meron", Colors.purple),
            _buildRecentTile("Natnael", Colors.teal),
            _buildRecentTile("Samirawit", Colors.pink),
            _buildRecentTile("Yonas", Colors.indigo),
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
        onTap: () {
          // Auto-fill the phone number when tapping on recent contact
          // This would need phone numbers associated with names
          setState(() {
            _numberController.clear();
            // Example: _numberController.text = "912345678";
            // For demo purposes, showing a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected: $name')),
            );
          });
        },
      ),
    );
  }
}
