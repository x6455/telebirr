import 'package:flutter/material.dart';

class PinDialog {
  static void show(BuildContext context, {required String amount, required Color primaryGreen}) {
    String pin = "";

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "PIN",
      barrierColor: Colors.black54,
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(builder: (context, setModalState) {
          
          void onKeyTap(String value) {
            setModalState(() {
              if (value == "x") {
                if (pin.isNotEmpty) pin = pin.substring(0, pin.length - 1);
              } else if (pin.length < 6) {
                pin += value;
              }
            });
            if (pin.length == 6) {
              print("PIN Entered: $pin");
              Navigator.pop(context);
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
                  height: 240,
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
                      const Text("Enter PIN", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 15),
                      // Fix 2: Smaller ETB and .00 appended
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(text: "$amount.00 ", style: const TextStyle(fontSize: 36)),
                            const TextSpan(text: "ETB", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          bool isFilled = pin.length > index;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Center(
                              child: isFilled
                                  ? Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                                    )
                                  : null,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 150),

                // 3. GRID NUMBER PAD
                Container(
                  color: Colors.white,
                  child: GridView.builder(
                    padding: EdgeInsets.zero, // Fix 4: Removed top offset
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.2,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      String label = "";
                      bool isActionKey = false;

                      if (index < 9) {
                        label = "${index + 1}";
                      } else if (index == 10) {
                        label = "0";
                      } else {
                        label = "x";
                        isActionKey = true;
                      }

                      // Fix 1: Gray background for empty space (index 9) and X (index 11)
                      bool isGrayBackground = (index == 9 || index == 11);

                      return Container(
                        decoration: BoxDecoration(
                          color: isGrayBackground ? const Color(0xFFEEEEEE) : Colors.white,
                          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
                        ),
                        child: TextButton(
                          // Fix 3: No color/ripple on press
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: (index == 9) ? null : () => onKeyTap(label),
                          child: label == "x"
                              ? const Icon(Icons.backspace_outlined, color: Colors.black)
                              : Text(label, style: const TextStyle(fontSize: 24, color: Colors.black)),
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
