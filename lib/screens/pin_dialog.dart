import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'success_page.dart'; // Ensure this file is created

class PinDialog {
  static void show(
    BuildContext context, {
    required String amount,
    required Color primaryGreen,
    required String accountName,
    required String accountNumber,
    required String bankName,
  }) {
    String pin = "";

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "PIN",
      barrierColor: Colors.black54,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(builder: (context, setModalState) {
          
          // --- INTERNAL KEY TAP LOGIC WITH LOADER ---
          void onKeyTap(String value) {
            setModalState(() {
              if (value == "x") {
                if (pin.isNotEmpty) pin = pin.substring(0, pin.length - 1);
              } else if (pin.length < 6) {
                pin += value;
              }
            });

            if (pin.length == 6) {
              // 1. Show the Telebirr Loader Overlay
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: TelebirrLoader()),
              );

              // 2. Run for 2 seconds then navigate to SuccessPage
              Future.delayed(const Duration(seconds: 2), () {
                if (context.mounted) {
                  // Pop the loader
                  Navigator.of(context).pop();
                  // Pop the PinDialog
                  Navigator.of(context).pop();

                  // Navigate to the final Success UI
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuccessPage(
                        amount: amount,
                        accountName: accountName,
                        accountNumber: accountNumber,
                        bankName: bankName,
                      ),
                    ),
                  );
                }
              });
            }
          }

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 1. FLOATING PIN BOX
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 270, // Height fixed as requested
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const Text("Enter PIN",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 15),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                                text: "$amount.00 ",
                                style: const TextStyle(fontSize: 36)),
                            const TextSpan(
                                text: "ETB", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // 6 Gray Rectangles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          bool isFilled = pin.length > index;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: isFilled
                                  ? Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                          color: Colors.black, shape: BoxShape.circle),
                                    )
                                  : null,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // 2. TRANSPARENT SPACE (150)
                const SizedBox(height: 150),

                // 3. GRID NUMBER PAD
                Container(
                  color: Colors.white,
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      String label = "";
                      bool isDisabled = false;

                      if (index < 9) {
                        label = "${index + 1}";
                      } else if (index == 9) {
                        isDisabled = true;
                      } else if (index == 10) {
                        label = "0";
                      } else if (index == 11) {
                        label = "x";
                      }

                      bool isGrayBackground = (index == 9 || index == 11);

                      return Container(
                        decoration: BoxDecoration(
                          color: isGrayBackground ? const Color(0xFFEEEEEE) : Colors.white,
                          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: isDisabled ? null : () => onKeyTap(label),
                          child: label == "x"
                              ? const Icon(Icons.backspace_outlined, color: Colors.black)
                              : Text(label,
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.black)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

// --- TELEBIRR LOADER WIDGET ---
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
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(141, 199, 63, 1),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
