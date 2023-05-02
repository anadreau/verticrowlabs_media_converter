import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/converter.dart';
import 'package:ffmpeg_converter/file_picker.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(CreatorGraph(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red)),
      home: Scaffold(
        backgroundColor: ThemeData.from(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.red))
            .secondaryHeaderColor,
        body: Center(
          child: Watcher((context, ref, child) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          ref.watch(inputStringCreator),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          ref.read(filePickerCreator);
                        },
                        child: Icon(
                          Icons.folder,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(ref.watch(outputStringCreator).toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Watcher(
                      (context, ref, child) => Text(ref.watch(statusCreator)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          onPressed: () {
                            ref.set(conversionStatusCreator, Status.inProgress);
                            ref.read(convertMediaCreator);
                          },
                          child: const Text('Convert'),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

//TODO: #1 add file picker @anadreau