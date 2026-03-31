import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';

void main() async {
  try {
    final interpreter = await Interpreter.fromFile(File('assets/model/dermascan.tflite'));
    
    print('Input tensors:');
    for (var tensor in interpreter.getInputTensors()) {
      print('Name: ${tensor.name}, Type: ${tensor.type}, Shape: ${tensor.shape}');
    }
    
    print('\nOutput tensors:');
    for (var tensor in interpreter.getOutputTensors()) {
      print('Name: ${tensor.name}, Type: ${tensor.type}, Shape: ${tensor.shape}');
    }
    
    interpreter.close();
  } catch (e) {
    print('Failed to load model: $e');
  }
}
