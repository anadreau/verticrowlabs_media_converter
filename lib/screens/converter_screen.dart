import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/ffmpeg_install_helper/admin_install.dart';
import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/media_conversion/media_conversion_barrel.dart';
import 'package:ffmpeg_converter/utils/utils_barrel.dart';
import 'package:flutter/material.dart';

class ConverterScreen extends StatelessWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(100.0),
      child: Watcher((context, ref, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    children: [
                      if (ref.watch(fileInputStringCreator) == '')
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                              'Press folder button to select file to convert'),
                        ),
                      if (ref.watch(fileInputStringCreator) != '')
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'File to be converted: ${ref.watch(fileInputStringCreator)}',
                            softWrap: true,
                          ),
                        ),
                      Watcher((context, ref, child) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Converted file: ${ref.watch(outputStringCreator).toString()}',
                              softWrap: true,
                            ),
                          )),
                      const Divider(
                        indent: 75,
                        endIndent: 75,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Watcher(
                          (context, ref, child) => Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Conversion Status: ${ref.watch(statusCreator)}',
                                ),
                              )),
                        ),
                      ),
                    ],
                  )),
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
                    child: Watcher((context, ref, child) => Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              ref.set(
                                  conversionStatusCreator, Status.inProgress);
                              ref.read(convertMediaCreator);
                            },
                            child: const Text('Convert'),
                          ),
                        )),
                  ),
                  const FileSelector(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: MaterialButton(
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          return ref.read(ffmpegadminInstallCreator);
                        },
                        child: Icon(
                          Icons.install_mobile,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
