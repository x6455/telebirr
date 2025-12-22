import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class IndividualTransferPage extends StatefulWidget {
  const IndividualTransferPage({super.key});

  @override
  State<IndividualTransferPage> createState() => _IndividualTransferPageState();
}

class _IndividualTransferPageState extends State<IndividualTransferPage> {
  // Slider Logic
  int _currentIndex = 0;
  final List<String> sliderImages = [
    'images/banner-1.jpg',
    'images/banner-2.jpg',
    'images/banner-3.jpg',
  ];

  // Input & Button Logic
  final TextEditingController _numberController = TextEditingController();
  bool _isButtonEnabled = false;

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
            // 1. Sliding Banners Logic
            const SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 39 / 15,
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
                      // Error builder helps if image path is wrong
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Slider Indicator
            DotsIndicator(
              dotsCount: sliderImages.length,
              position: _currentIndex,
              decorator: DotsDecorator(
                activeColor: Colors.green,
                size: const Size.square(8.0),
                activeSize: const Size(18.0, 8.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
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
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                    decoration: InputDecoration(
                      counterText: "",
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      // PREFIX: Normal weight to match user input
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
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // BUTTON LOGIC
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(2, 135, 208, 1),
                        // "Blurred"/Slightly blue color when disabled
                        disabledBackgroundColor:
                            const Color.fromRGBO(2, 135, 208, 0.25),
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

            // 3. Recent Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Recent",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
