import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ModelService {
  Interpreter? _interpreter;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/model/dermascan.tflite',
    );
  }

  List<List<List<List<double>>>> preprocess(File imageFile) {
    final bytes = imageFile.readAsBytesSync();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception("Failed to decode image");
    }

    img.Image resized = img.copyResize(image, width: 224, height: 224);

    return [
      List.generate(224, (y) {
        return List.generate(224, (x) {
          final pixel = resized.getPixel(x, y);
          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
          ];
        });
      })
    ];
  }

  Map<String, dynamic> predict(File imageFile) {
    if (_interpreter == null) {
      throw Exception("Model not loaded. Call loadModel() first.");
    }

    var input = preprocess(imageFile);

    var output = List.generate(1, (_) => List.filled(3, 0.0));

    try {
  print("🧠 Running inference...");
  _interpreter!.run(input, output);
  print("✅ Inference done");
} catch (e) {
  print("❌ MODEL ERROR: $e");
  throw e;
}

    int maxIndex = 0;
    for (int i = 1; i < output[0].length; i++) {
      if (output[0][i] > output[0][maxIndex]) {
        maxIndex = i;
      }
    }

    List<String> labels = ["Mild", "Moderate", "Severe"];

    return {
      "label": labels[maxIndex],
      "confidence": output[0][maxIndex],
    };
  }
}