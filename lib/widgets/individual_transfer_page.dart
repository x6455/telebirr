import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class IndividualTransferPage extends StatefulWidget {
  const IndividualTransferPage({super.key});

  @override
  State<IndividualTransferPage> createState() =>
      _IndividualTransferPageState();
}

class _IndividualTransferPageState
    extends State<IndividualTransferPage> {
  int _currentIndex = 0;

  final List<String> sliderImages = [
    'images/Banner1.jpg',
    'images/Banner2.jpg',
    'images/Banner3.jpg',
    'images/Banner4.jpg',
    'images/Banner5.jpg',
  ];

  final TextEditingController _numberController =
      TextEditingController();

  final FocusNode _focusNode = FocusNode();

  bool _isButtonEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _numberController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      _isButtonEnabled =
          _numberController.text.length == 9;
    });
  }

  Future<void> _handleNext() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Send Money to Individual",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme:
            const IconThemeData(color: Colors.black),
      ),

      body: Stack(
        children: [
          GestureDetector(
            onTap: () => _focusNode.unfocus(),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  const SizedBox(height: 10),

                  /// 🔹 Slider
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
                    items: sliderImages.map((img) {
                      return Container(
                        margin:
                            const EdgeInsets.symmetric(
                                horizontal: 5),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(12),
                          child: Image.asset(
                            img,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 10),

                  /// 🔹 Input Card
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Please Enter Mobile Number",
                        ),
                        const SizedBox(height: 12),

                        TextField(
                          controller: _numberController,
                          focusNode: _focusNode,
                          keyboardType:
                              TextInputType.phone,
                          maxLength: 9,
                          textAlignVertical:
                              TextAlignVertical.center,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black),

                          decoration: InputDecoration(
                            counterText: "",
                            contentPadding:
                                const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14),

                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(
                                      left: 12,
                                      top: 14),
                              child: Text(
                                "+251 ",
                                style: TextStyle(
                                    color: Colors
                                        .black
                                        .withOpacity(
                                            0.7)),
                              ),
                            ),

                            enabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      8),
                              borderSide: BorderSide(
                                  color: Colors
                                      .green
                                      .shade300),
                            ),

                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      8),
                              borderSide:
                                  const BorderSide(
                                      color:
                                          Colors.green,
                                      width: 2),
                            ),

                            disabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      8),
                              borderSide: BorderSide(
                                  color: Colors
                                      .green
                                      .shade300),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🔹 Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed:
                                (_isButtonEnabled &&
                                        !_isLoading)
                                    ? _handleNext
                                    : null,
                            style: ElevatedButton
                                .styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(
                                      2, 135, 208, 1),
                              elevation: 0,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(8),
                              ),
                            ),
                            child: const Text("Next"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 CONTACTS (ROUNDED CONTAINER)
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildRecentTile(
                            "Hewan", Colors.amber),
                        _buildRecentTile(
                            "TEWABE", Colors.amber),
                        _buildRecentTile(
                            "Abera", Colors.amber),
                        _buildRecentTile(
                            "Biruk", Colors.amber),
                        _buildRecentTile(
                            "Meron", Colors.amber),
                        _buildRecentTile(
                            "Natnael", Colors.amber),
                        _buildRecentTile(
                            "Samirawit", Colors.amber),
                        _buildRecentTile(
                            "Yonas", Colors.amber),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          /// 🔹 LOADING OVERLAY
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'images/loading.gif',
                    width: 50,
                    height: 50,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentTile(
      String name, Color avatarColor) {
    return Column(
      children: [
        ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16),
          leading: CircleAvatar(
            backgroundColor: avatarColor,
            child: const Icon(Icons.person,
                color: Colors.white),
          ),
          title: Text(name),
          trailing: const Icon(Icons.chevron_right,
              color: Colors.grey),
          onTap: () {
            _focusNode.requestFocus();
          },
        ),

        const Divider(
          height: 1,
          thickness: 1,
          indent: 72,
          endIndent: 16,
          color: Color(0xFFF0F0F0),
        ),
      ],
    );
  }
}