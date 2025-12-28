import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

// 1. IMPORTS ADDED HERE
import 'package:telebirrbybr7/screens/engage_page.dart'; // To access globalEngageList
import 'package:telebirrbybr7/screens/bank_amount_page.dart'; // To navigate to next screen
import 'dart:math' as math;

class TelebirrLoader extends StatefulWidget {
  const TelebirrLoader({super.key});

  @override
  State<TelebirrLoader> createState() => _TelebirrLoaderState();
}

class _TelebirrLoaderState extends State<TelebirrLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), 
    )..repeat();

    _rotationAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _rotationAnimation,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(8, (index) {
            double angle = (index * 45 - 90) * (math.pi / 180);
            double radius = 22.0;
            double dotSize = 2.5 + (index * 1.6); 

            return Positioned(
              left: 30 + radius * math.cos(angle) - (dotSize / 2),
              top: 30 + radius * math.sin(angle) - (dotSize / 2),
              // Use Opacity widget instead of a parameter in BoxDecoration
              child: Opacity(
                opacity: 1.0,
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(141, 199, 63, 1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}



class TransferToBankPage extends StatefulWidget {
  const TransferToBankPage({super.key});

  @override
  State<TransferToBankPage> createState() => _TransferToBankPageState();
}

class _TransferToBankPageState extends State<TransferToBankPage> {
  // Controllers and State Variables
  final TextEditingController _accountController = TextEditingController();
  int _currentIndex = 0;
  bool _isButtonEnabled = false;
  String selectedBankName = 'Please Choose';

  final List<String> sliderImages = [
    'images/Banner1.jpg',
    'images/Banner2.jpg',
    'images/Banner3.jpg',
    'images/Banner4.jpg',
    'images/Banner5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _accountController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      _isButtonEnabled = _accountController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  // 2. NEW LOGIC: HANDLE NEXT BUTTON PRESS
  void _handleNextProcess() async {
    // A. Show Loading Dialog
    // A. Show Loading Dialog with GIF
showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => Center(
    child: Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Center(
        child: TelebirrLoader(), // The new code-based animation
      ),
    ),
  ),
);


    // B. Wait for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // C. Close Loading Dialog
    if (!mounted) return;
    Navigator.pop(context);

    // D. Check if account exists in globalEngageList
    try {
      final foundAccount = globalEngageList.firstWhere(
        (item) => item['number'] == _accountController.text,
      );

      // --- IF FOUND: Navigate to BankAmountPage ---
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BankAmountPage(
            accountName: foundAccount['name']!,
            accountNumber: foundAccount['number']!,
            bankName: selectedBankName,
          ),
        ),
      );
    } catch (e) {
      // --- IF NOT FOUND: Show Floating Error ---
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('query not found'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.black54,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.4, // Floating in middle
            left: 50,
            right: 50,
          ),
        ),
      );
    }
  }
  // -------------------------------------------

  void _showBankSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Choose Bank",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _buildBankItem("Abay Bank", "images/abay.png"),
                    _buildBankItem("Addis Bank S.C.", "images/addis.png"),
                    _buildBankItem("Ahadu Bank", "images/ahadu.png"),
                    _buildBankItem("Amhara Bank", "images/amhara.png"),
                    _buildBankItem("Awash Bank", "images/Awash.png"),
                    _buildBankItem("Bank of Abyssinia", "images/abyssinia.png"),
                    _buildBankItem("Berhan Bank", "images/berhan.png"),
                    _buildBankItem("Bunna Bank", "images/bunna.png"),
                    _buildBankItem("Commercial Bank of Ethiopia", "images/cbe.png"),
                    _buildBankItem("Cooperative Bank of Oromia", "images/coop.png"),
                    _buildBankItem("Dashen Bank", "images/dashen.png"),
                    _buildBankItem("Global Bank Ethiopia", "images/global.png"),
                    _buildBankItem("Temo Bank", "images/loading.gif"),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBankItem(String name, String imagePath) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedBankName = name;
        });
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath, 
              width: 45, 
              height: 45, 
              errorBuilder: (c, e, s) => const Icon(Icons.account_balance, size: 30),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
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
            // ... inside your build method, replace the existing CarouselSlider and DotsIndicator with this:

const SizedBox(height: 10),
CarouselSlider(
  options: CarouselOptions(
    autoPlay: true,
    // Adjusting aspect ratio to make it a slim banner like the image
    aspectRatio: 3.5, 
    viewportFraction: 0.92,
    onPageChanged: (index, reason) {
      setState(() {
        _currentIndex = index;
      });
    },
  ),
  items: sliderImages.map((imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported),
          ),
        ),
      ),
    );
  }).toList(),
),

// --- UPDATED DOTS INDICATOR ---
Padding(
  padding: const EdgeInsets.only(top: 8.0),
  child: DotsIndicator(
  dotsCount: sliderImages.length,
  position: _currentIndex,
  decorator: DotsDecorator(
    // --- ACTIVE DOT (The "Dot inside a hole") ---
    activeColor: const Color.fromRGBO(141, 199, 63, 1), 
    activeSize: const Size(9.0, 9.0), // Make this slightly larger than the inactive size
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6.0),
      // This border matches the background color to create the "gap"
      side: const BorderSide(
        color: Color(0xFFF5F5F5), // Your background color
        width: 1.7, // The thickness of the "hole" gap
      ),
    ),

    // --- INACTIVE DOTS (The "Hole") ---
    size: const Size(9.0, 9.0),
    color: Colors.transparent, // Hollow center
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0),
      side: const BorderSide(
        color: Color.fromRGBO(141, 199, 63, 0.4), // Light green ring
        width: 2.0,
      ),
    ),
    spacing: const EdgeInsets.symmetric(horizontal: 4.0),
  ),
),


),

            const SizedBox(height: 15),

            // Input Form Card
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
                  Text('Select Bank', style: _labelStyle()),
                  const SizedBox(height: 6),
                  
                  // CLICKABLE DROPDOWN
                  GestureDetector(
                    onTap: () => _showBankSelection(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedBankName,
                            style: TextStyle(
                              color: selectedBankName == 'Please Choose' 
                                  ? Colors.grey.shade600 
                                  : Colors.black,
                              fontSize: 15,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text('Account No', style: _labelStyle()),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _accountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter Account Number',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

                  const SizedBox(height: 20),

                  // 3. UPDATED BUTTON with _handleNextProcess
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? _handleNextProcess : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(2, 135, 208, 1),
                        disabledBackgroundColor: const Color.fromRGBO(2, 135, 208, 0.25),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white,
                        elevation: _isButtonEnabled ? 2 : 0,
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

            const SizedBox(height: 20),

            // Recent Section
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildRecentItem('Mrs Wagaye Kasa Alemu', 'Commercial Bank of Ethiopia (100072931166)', 'images/cbe.png', isLast: false),
                  _buildRecentItem('ZENEBECH HAILE GULUMA', 'Dashen Bank (5010657636011)', 'images/dashen.png', isLast: false),
                  _buildRecentItem('YOHANNES GETNET ABEBE...', 'Dashen Bank (0239945076011)', 'images/dashen.png', isLast: false),
                  _buildRecentItem('MILLION ABREHAM TESFAYE', 'Awash Bank (01320253636800)', 'images/Awash.png', isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle() => TextStyle(
    color: Colors.grey.shade600, 
    fontSize: 14, 
    fontWeight: FontWeight.w500,
  );

  Widget _buildRecentItem(String name, String details, String imagePath, {required bool isLast}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Image.asset(imagePath, width: 40, height: 40),
          title: Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
          subtitle: Text(details, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), overflow: TextOverflow.ellipsis),
          trailing: Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ),
        if (!isLast) Divider(height: 1, thickness: 1, color: Colors.grey.shade100, indent: 70),
      ],
    );
  }
}
