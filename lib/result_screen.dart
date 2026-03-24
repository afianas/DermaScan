import 'package:flutter/material.dart';
import 'dart:io';
import '../services/model_service.dart';

class ResultScreen extends StatefulWidget {
  final File image;

  const ResultScreen({super.key, required this.image});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ModelService model;

  String result = "Analyzing...";
  double confidence = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    model = ModelService();
    runModel();
  }
  Future<void> runModel() async {
  try {
    print("🚀 Starting model...");

    // Load model (only once ideally, but safe here)
    await model.loadModel();
    print("✅ Model loaded");

    // Run prediction
    final output = model.predict(widget.image);
    print("🔥 Output: $output");

    // Update UI
    setState(() {
      result = output['label'];
      confidence = output['confidence'];
      isLoading = false;
    });

  } catch (e) {
    print("❌ ERROR in runModel: $e");

    // Prevent infinite loading if something fails
    setState(() {
      isLoading = false;
      result = "Error";
      confidence = 0.0;
    });
  }
}
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4F8),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: boxStyle(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔙 Header
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: boxStyle(),
                          child: const Icon(Icons.arrow_back, size: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Analysis Results",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 🖼 Image preview
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: boxStyle(color: Colors.grey[300]!),
                    child: Image.file(widget.image, fit: BoxFit.cover),
                  ),

                  const SizedBox(height: 20),

                  // 🔥 Severity
                  const Text("Severity Level:"),
                  const SizedBox(height: 8),

                  Container(
                    height: 20,
                    decoration: boxStyle(),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Container(color: Colors.green)),
                        Expanded(flex: 3, child: Container(color: Colors.orange)),
                        Expanded(flex: 4, child: Container(color: Colors.red)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 5),

                  // 👇 CHANGED (dynamic result)
                  isLoading
                      ? const CircularProgressIndicator()
                      : Text(result),

                  const SizedBox(height: 20),

                  // 📊 Stats
                  Row(
                    children: [
                      Expanded(child: statBox("11", "Detected Spots")),
                      const SizedBox(width: 10),
                      Expanded(child: statBox("12%", "Affected Area")),
                      const SizedBox(width: 10),

                      // 👇 CHANGED (dynamic confidence)
                      Expanded(
                        child: statBox(
                          isLoading
                              ? "..."
                              : "${(confidence * 100).toStringAsFixed(1)}%",
                          "Confidence",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 📈 Confidence bar
                  const Text("Model Confidence"),
                  const SizedBox(height: 8),

                  Container(
                    height: 20,
                    decoration: boxStyle(),
                    child: Row(
                      children: [
                        Expanded(
                          flex: (confidence * 10).toInt().clamp(1, 10),
                          child: Container(color: Colors.blue),
                        ),
                        Expanded(
                          flex: 10 - (confidence * 10).toInt().clamp(1, 10),
                          child: Container(color: Colors.grey[300]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 💡 Recommendations
                  const Text(
                    "Recommendations",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  recommendation("Cleanse twice daily"),
                  recommendation("Use non-comedogenic products"),
                  recommendation("Avoid touching face frequently"),
                  recommendation("Consult dermatologist if severe"),

                  const SizedBox(height: 20),

                  // 🔁 Scan again
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: boxStyle(color: const Color(0xFF7EC8E3)),
                        child: const Text("Scan Again"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget statBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: boxStyle(color: const Color(0xFFEADFE6)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget recommendation(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: boxStyle(color: const Color(0xFFD6DEE8)),
      child: Text("• $text"),
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
}