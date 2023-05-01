import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/converter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CreatorGraph(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Watcher((context, ref, child) => Column(
                children: [
                  Text(ref.watch(inputStringCreator)),
                  Text(ref.watch(outputStringCreator)),
                  Text(ref.watch(conversionStatusCreator).toString()),
                  MaterialButton(
                    onPressed: () {
                      ref.read(convertMediaEmitter);
                    },
                    child: const Text('Convert'),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
