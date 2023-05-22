import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:ffmpeg_converter/utils/common_variables.dart';
import 'package:ffmpeg_converter/utils/file_type_drop_down.dart';
import 'package:ffmpeg_converter/utils/resolution_drop_down.dart';
import 'package:ffmpeg_converter/media_conversion/media_conversion_barrel.dart';

import 'package:flutter/material.dart';

//TODO: #9 Implement function to check if FFMPEG is downloaded and download and install if needed. @anadreau

void main() {
  runApp(CreatorGraph(child: const ConverterApp()));
}

class ConverterApp extends StatelessWidget {
  const ConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'bugFix',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        body: Watcher((context, ref, child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (ref.watch(fileInputStringCreator) == '')
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                        Text('Press folder button to select file to convert'),
                  ),
                if (ref.watch(fileInputStringCreator) != '')
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      ref.watch(fileInputStringCreator),
                      softWrap: true,
                    ),
                  ),
                Watcher((context, ref, child) => Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        ref.watch(outputStringCreator).toString(),
                        softWrap: true,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Watcher(
                    (context, ref, child) => Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ref.watch(statusCreator),
                          ),
                        )),
                  ),
                ),
                if (ref.watch(statusCreator) == Status.inProgress.message)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(100, 8, 100, 8),
                    child: LinearProgressIndicator(),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FileTypeDropDown(),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: MediaDropDown(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Watcher((context, ref, child) => MaterialButton(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            onPressed: () {
                              ref.set(
                                  conversionStatusCreator, Status.inProgress);
                              ref.read(convertMediaCreator);
                            },
                            child: const Text('Convert'),
                          )),
                    ),
                    Watcher(
                      (context, ref, child) => MaterialButton(
                        onPressed: () {
                          ref.read(filePickerCreator);
                        },
                        child: Icon(
                          Icons.folder,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        //add dialog that edits file name
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const FileNameEditingDialog();
                            });
                      },
                      child: Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

//TODO: #3 @anadreau Add ability to name file