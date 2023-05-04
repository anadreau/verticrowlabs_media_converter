import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/converter.dart';
import 'package:ffmpeg_converter/file_picker.dart';
import 'package:ffmpeg_converter/utils/common_variables.dart';
import 'package:ffmpeg_converter/utils/drop_down.dart';

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
                if (ref.watch(inputStringCreator) == '')
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                        Text('Press folder button to select file to convert'),
                  ),
                if (ref.watch(inputStringCreator) != '')
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      ref.watch(inputStringCreator),
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
                if (ref.watch(statusCreator) == 'inProgress')
                  const LinearProgressIndicator(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MediaDropDown(),
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
                              return AlertDialog(
                                content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Edit File Name'),
                                    TextFormField(),
                                  ],
                                ),
                                actions: [
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  MaterialButton(
                                    onPressed: () {},
                                    child: const Text('Confirm'),
                                  )
                                ],
                              );
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