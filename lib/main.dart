import 'dart:developer';
import 'dart:io';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/converter.dart';
import 'package:file_picker/file_picker.dart';

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ref.watch(inputStringCreator),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      MaterialButton(
                        onPressed: () async {
                          var result = Process.runSync('powershell.exe',
                              ['-Command', '\$env:USERPROFILE']);
                          //var dir = await getDownloadsDirectory();
                          var removeNewlineCode =
                              result.stdout.toString().split('\n');
                          log(removeNewlineCode[0]);
                          log(removeNewlineCode.toString());
                          String videoFolder = removeNewlineCode[0];
                          String videoPath = videoFolder;
                          log('VideoPath: $videoPath');

                          var file = await FilePicker.platform
                              .pickFiles(initialDirectory: videoPath);
                          ref.set(
                              inputStringCreator, file!.paths[0].toString());
                          log('FilePath: ${file.paths[0].toString()}');
                          log('FileName: ${file.names}');
                        },
                        child: const Icon(Icons.folder),
                      )
                    ],
                  ),
                  Text(ref.watch(outputStringCreator).toString()),
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