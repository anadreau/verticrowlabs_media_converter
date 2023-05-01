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
                  Watcher(
                    (context, ref, child) => Text(ref.watch(statusCreator)),
                  ),
                  MaterialButton(
                    onPressed: () {
                      ref.set(conversionStatusCreator, Status.inProgress);
                      ref.read(convertMediaCreator);
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

//TODO: #1 add file picker @anadreau