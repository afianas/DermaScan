import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() {
  test('Load and inspect TFLite model', () async {
    try {
      final interpreter = await Interpreter.fromFile(File('assets/model/dermascan.tflite'));
      
      print('=== Input Tensor ===');
      for (var tensor in interpreter.getInputTensors()) {
        print('Name: ${tensor.name}');
        print('Type: ${tensor.type}');
        print('Shape: ${tensor.shape}');
      }
      
      print('\n=== Output Tensor ===');
      for (var tensor in interpreter.getOutputTensors()) {
        print('Name: ${tensor.name}');
        print('Type: ${tensor.type}');
        print('Shape: ${tensor.shape}');
      }
      
      interpreter.close();
    } catch (e) {
      print('=== TFLITE ERROR ===');
      print(e);
    }
  });
}
