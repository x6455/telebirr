import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';

class TransferToBankPage extends StatefulWidget {
  const TransferToBankPage({super.key});

  @override
  State<TransferToBankPage> createState() => _TransferToBankPageState();
}

class _TransferToBankPageState extends State<TransferToBankPage> {
  // 1. Controllers and State Variables
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
    // Listener to enable button and change color when user types
    _accountController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      // Button turns blue/active if there is any text in the account field
      _isButtonEnabled = _accountController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  // 2. The Bank Selection Overlay Logic
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
              
              // Search Bar
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

              // Bank Grid
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
          selectedBankName = name; // Update only the text name
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
            // 3. Sliding Banners logic
            const SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 39 / 13, // Aspect ratio tailored for banners
                viewportFraction: 0.9,
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
            DotsIndicator(
              dotsCount: sliderImages.length,
              position: _currentIndex,
              decorator: DotsDecorator(
                activeColor: Colors.green,
                size: const Size.square(8.0),
                activeSize: const Size(18.0, 8.0),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // 4. Input Form Card
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
                  const SizedBox(height: 8),
                  
                  // CLICKABLE DROPDOWN
                  GestureDetector(
                    onTap: () => _showBankSelection(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                              fontSize: 16,
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text('Account No', style: _labelStyle()),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _accountController,
                    keyboardType: TextInputType.number,
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

                  // 5. NEXT BUTTON logic
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isButtonEnabled ? () {} : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(2, 135, 208, 1), // Blue color
                        disabledBackgroundColor: const Color.fromRGBO(2, 135, 208, 0.25), // Faded blue when disabled
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

            const SizedBox(height: 25),

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
