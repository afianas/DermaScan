import 'dart:io';
import 'dart:math' as math;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

import 'package:flutter/services.dart' show rootBundle;

class ModelService {
  Interpreter? _interpreter;
  final List<String> _labels = ["Mild", "Moderate", "Severe"];

  Future<void> loadModel() async {
    // WORKAROUND: tflite_flutter's `fromAsset` often throws "Unable to create interpreter" 
    // on Windows Desktop due to native memory pointer lifecycle bugs. 
    // We fix this by manually extracting to a temp file and using `fromFile`.
    final byteData = await rootBundle.load('assets/model/dermascan.tflite');
    final tempFile = File('${Directory.systemTemp.path}/dermascan.tflite');
    await tempFile.writeAsBytes(byteData.buffer.asUint8List(
        byteData.offsetInBytes, byteData.lengthInBytes));
    
    _interpreter = await Interpreter.fromFile(tempFile);
  }

  List<List<List<List<double>>>> _preprocessFloat32(img.Image image) {
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

  List<List<List<List<int>>>> _preprocessUint8(img.Image image) {
    img.Image resized = img.copyResize(image, width: 224, height: 224);
    return [
      List.generate(224, (y) {
        return List.generate(224, (x) {
          final pixel = resized.getPixel(x, y);
          return [
            pixel.r.toInt(),
            pixel.g.toInt(),
            pixel.b.toInt(),
          ];
        });
      })
    ];
  }

  int _countAcneSpots(img.Image image) {
    // A simplified dart-port for lesion counting resembling the OpenCV logic.
    // Scale down image to speed up processing
    img.Image smallImg = img.copyResize(image, width: 200);
    int width = smallImg.width;
    int height = smallImg.height;

    int spotCount = 0;
    List<bool> visited = List.filled(width * height, false);

    // Simple connected components specifically looking for "reddish" blobs
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int index = y * width + x;
        if (visited[index]) continue;

        final pixel = smallImg.getPixel(x, y);
        num r = pixel.r;
        num g = pixel.g;
        num b = pixel.b;

        // Characteristic of inflamed acne: distinctly red compared to green/blue
        if (r > g + 25 && r > b + 25 && r > 100) {
          // Found a potential spot seed, do a small BFS to mark the blob
          int blobSize = 0;
          List<math.Point<int>> queue = [math.Point(x, y)];
          visited[index] = true;

          while (queue.isNotEmpty) {
            var curr = queue.removeLast();
            blobSize++;

            if (blobSize > 100) break; // Limit max blob size to consider it a single spot

            List<List<int>> dirs = [[0, 1], [1, 0], [0, -1], [-1, 0]];
            for (var dir in dirs) {
              int nx = curr.x + dir[0];
              int ny = curr.y + dir[1];

              if (nx >= 0 && nx < width && ny >= 0 && ny < height) {
                int nIndex = ny * width + nx;
                if (!visited[nIndex]) {
                  final nPixel = smallImg.getPixel(nx, ny);
                  num nr = nPixel.r;
                  num ng = nPixel.g;
                  num nb = nPixel.b;

                  // Slightly looser condition for neighbors in the same blob
                  if (nr > ng + 15 && nr > nb + 15) {
                    visited[nIndex] = true;
                    queue.add(math.Point(nx, ny));
                  }
                }
              }
            }
          }

          // Filter out tiny noise (1 pixel) and massive red blocks
          if (blobSize >= 2 && blobSize <= 100) {
            spotCount++;
          }
        } else {
          visited[index] = true;
        }
      }
    }

    return spotCount;
  }

  Map<String, dynamic> predict(File imageFile) {
    if (_interpreter == null) {
      throw Exception("Interpreter not loaded");
    }

    final bytes = imageFile.readAsBytesSync();
    img.Image? image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception("Failed to decode image");
    }

    // Determine tensor type directly from the model logic dynamically
    final inputTensor = _interpreter!.getInputTensor(0);
    final outputTensor = _interpreter!.getOutputTensor(0);

    final isInputUint8 = inputTensor.type == TensorType.uint8;
    final isOutputUint8 = outputTensor.type == TensorType.uint8;

    Object input = isInputUint8 ? _preprocessUint8(image) : _preprocessFloat32(image);
    Object output = isOutputUint8 ? [List<int>.filled(3, 0)] : [List<double>.filled(3, 0.0)];

    // 1. Run TFLite Inference
    _interpreter!.run(input, output);

    List<double> results;
    if (isOutputUint8) {
      final uintList = (output as List<List<int>>)[0];
      results = uintList.map((e) => e / 255.0).toList();
    } else {
      results = (output as List<List<double>>)[0];
    }

    int maxIndex = 0;
    double maxConfidence = results[0];
    for (int i = 1; i < results.length; i++) {
      if (results[i] > maxConfidence) {
        maxConfidence = results[i];
        maxIndex = i;
      }
    }
    String tfliteLabel = _labels[maxIndex];

    // 2. Run Dart-based lesion counting
    int count = _countAcneSpots(image);

    // 3. Combine both for a robust final judgment
    // By default, trust the TFLite model, but bump severity if spot count is unusually high
    String finalLabel = tfliteLabel;
    
    if (tfliteLabel == "Mild" && count > 15) {
      finalLabel = "Moderate";
      maxConfidence = 0.8; // Override confidence to reflect rule-based confidence
    } else if (tfliteLabel == "Moderate" && count > 30) {
      finalLabel = "Severe";
      maxConfidence = 0.85;
    } else if (count > 50) {
      finalLabel = "Severe";
      maxConfidence = 0.95;
    }

    return {
      "label": finalLabel,
      "tflite_label": tfliteLabel,
      "confidence": maxConfidence,
      "count": count,
    };
  }
}