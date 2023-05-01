import 'package:ffmpeg_converter/converter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Text('Selected file'),
              const Text('Output file'),
              const Text('Conversion status'),
              MaterialButton(
                onPressed: () {
                  mediaConverter();
                },
                child: const Text('Convert'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
