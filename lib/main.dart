import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(const DermaScanApp());
}

class DermaScanApp extends StatelessWidget {
  const DermaScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DermaScan',

    theme: ThemeData(
      scaffoldBackgroundColor: const Color(0xFFE8F4F8),

       textTheme: TextTheme(
        bodyMedium: GoogleFonts.vt323(
        color: const Color(0xFF2D3748),
        fontSize: 18,
      ),
     titleLarge: GoogleFonts.pressStart2p(
        color: const Color(0xFF2D3748),
        fontSize: 16,
      ),
    ),
  ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  double scrollProgress = 0;

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final current = scrollController.offset;

      if (maxScroll > 0) {
        setState(() {
          scrollProgress = (current / maxScroll).clamp(0.0, 1.0);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4F8),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: boxStyle(),
                child: const Icon(Icons.crop_free, size: 40),
              ),

              const SizedBox(height: 20),

              const Text(
                "DermaScan",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Advanced acne detection and severity classification",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 80),

              // Main Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: boxStyle(),
                child: Column(
                  children: [
                    const Text(
                      "Get Your Skin Analysis",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Our trained AI model analyzes your facial skin to detect acne and provide personalized recommendations.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7EC8E3),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CameraScreen(),
                          ),
                        );
                      },
                      child: const Text("Start Scanning"),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🔥 HORIZONTAL SCROLL FEATURES
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 260,
                      child: ListView(
                        controller: scrollController, // ✅ CONNECTED
                        scrollDirection: Axis.horizontal,
                        children: [
                          featureBox(
                            title: "AI Detection",
                            desc:
                                "Advanced algorithms analyze your skin to detect and count acne spots with high accuracy",
                            color: const Color(0xFFEADFE6),
                            icon: Icons.crop_free,
                          ),
                          const SizedBox(width: 16),

                          featureBox(
                            title: "3-Level Classification",
                            desc:
                                "Categorizes acne severity into Mild, Moderate, or Severe",
                            color: const Color(0xFFE6DFF0),
                            icon: Icons.show_chart,
                          ),
                          const SizedBox(width: 16),

                          featureBox(
                            title: "Personalized Recommendations",
                            desc:
                                "Receive tailored skincare recommendations based on your specific condition",
                            color: const Color(0xFFDFF0E6),
                            icon: Icons.shield,
                          ),

                          const SizedBox(width: 20),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 💉 SYRINGE BAR
                    Container(
  margin: const EdgeInsets.only(right: 20),
  child: Row(
    children: [

      // 🔹 SYRINGE BODY
      Expanded(
        child: Container(
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF2D3748), width: 2),
          ),
          child: Stack(
            children: [

              // 🔵 Liquid
              FractionallySizedBox(
                widthFactor: scrollProgress,
                child: Container(
                  color: const Color(0xFF7EC8E3),
                ),
              ),

              // 🔘 Plunger
              Positioned(
                left: scrollProgress * MediaQuery.of(context).size.width * 0.65,
                child: Container(
                  width: 8,
                  height: 20,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
        ),
      ),

      const SizedBox(width: 6),

      // 🔸 Needle base
      Container(
        width: 10,
        height: 20,
        color: const Color(0xFF2D3748),
      ),

      // 🔺 Needle tip
      Container(
        width: 0,
        height: 0,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 10, color: Colors.transparent),
            bottom: BorderSide(width: 10, color: Colors.transparent),
            left: BorderSide(width: 10, color: Color(0xFF2D3748)),
          ),
        ),
      ),
    ],
  ),
),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Magic Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(25),
                decoration: boxStyle(color: const Color(0xFFEFE8B8)),
                child: Column(
                  children: [
                    const Text(
                      "The magic behind it",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 25),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: magicStep(
                            "1",
                            "Capture",
                            "Send over a picture of your face",
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: magicStep(
                            "2",
                            "Analyze",
                            "Our AI Model scans your image to detect and classify acne severity",
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: magicStep(
                            "3",
                            "Our Verdict",
                            "Based on the results, we give you insights on your acne",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Disclaimer
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: boxStyle(color: const Color(0xFFD6DEE8)),
                child: const Text(
                  "Medical Disclaimer: DermaScan is for informational purposes only and does not provide medical advice.\n\n"
                  "This tool simulates acne detection for demonstration. For accurate diagnosis and treatment, please consult a licensed dermatologist or healthcare professional.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

  Widget featureCard(String title) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: boxStyle(color: Color(0xFFEADFE6)),
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    );
  }
Widget featureBox({
  required String title,
  required String desc,
  required Color color,
  required IconData icon,
}) {
  return StatefulBuilder(
    builder: (context, setState) {
      bool pressed = false;

      return GestureDetector(
        onTapDown: (_) => setState(() => pressed = true),
        onTapUp: (_) => setState(() => pressed = false),
        onTapCancel: () => setState(() => pressed = false),
        child: AnimatedContainer(
          width: 260,
          height: 240,
          duration: const Duration(milliseconds: 80),
          transform: Matrix4.translationValues(
              pressed ? 4 : 0, pressed ? 4 : 0, 0),

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: const Color(0xFF2D3748), width: 2),
            boxShadow: pressed
                ? []
                : const [
                    BoxShadow(
                      color: Color(0xFF2D3748),
                      offset: Offset(6, 6),
                    )
                  ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ICON
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Icon(icon, size: 20),
              ),

              const SizedBox(height: 20),

              // TITLE
// TITLE
Text(
  title,
  style: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 12),

// DESC
Text(
  desc,
  maxLines: 4,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(
    fontSize: 15,
    height: 1.4,
  )
),

              const SizedBox(height: 12),

            ],
          ),
        ),
      );
    },
  );
}
Widget magicStep(String num, String title, String desc) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: boxStyle(color: const Color(0xFF1DA1D2)),
        child: Text(
          num,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),

      const SizedBox(height: 18),

      Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 10),

      SizedBox(
        height: 240,
        width: 120, // 🔥 CONTROL WIDTH → fixes symmetry
        child: Text(
          desc,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ),
    ],
  );
}
BoxDecoration boxStyle({Color color = Colors.white}) {
  return BoxDecoration(
    color: color,
    border: Border.all(
      color: const Color(0xFF2D3748),
      width: 2,
    ),
    boxShadow: const [
      BoxShadow(
        color: Color(0xFF2D3748),
        offset: Offset(4, 4),
        blurRadius: 0,
      ),
    ],
  );
}