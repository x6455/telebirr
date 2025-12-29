import 'package:flutter/material.dart';

class PinDialog {
  static void show(BuildContext context, {required String amount, required Color primaryGreen}) {
    String pin = "";

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "PIN",
      barrierColor: Colors.black54, // Semi-transparent background
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
              // Final Action after 6 digits
              print("PIN Entered: $pin");
              Navigator.pop(context);
            }
          }

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 1. FLOATING PIN BOX (Height 270, Offset 20)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 270,
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
                      Text(
                        "$amount ETB",
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      // 6 Gray Rectangles (30x30)
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

                // 2. TRANSPARENT SPACE (150)
                const SizedBox(height: 150),

                // 3. GRID NUMBER PAD WITH LINES
                Container(
                  color: Colors.white,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.2, // Adjusts key height
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      String label = "";
                      if (index < 9) label = "${index + 1}";
                      if (index == 10) label = "0";
                      if (index == 11) label = "x";

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
                        ),
                        child: TextButton(
                          onPressed: label.isEmpty ? null : () => onKeyTap(label),
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
