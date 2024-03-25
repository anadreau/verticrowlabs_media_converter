import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/file_parsing/file_parsing_barrel.dart';
import 'package:verticrowlabs_media_converter/media_conversion/media_conversion_barrel.dart';
import 'package:verticrowlabs_media_converter/thumbnail_generator/thumbnail_widget.dart';
import 'package:verticrowlabs_media_converter/utils/utils_barrel.dart';

///[ConsumerWidget] that displays screen if ffmpeg is installed
class ConverterScreen extends ConsumerWidget {
  ///Implementation of [ConverterScreen]
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileInput = ref.watch(fileInputStringProvider);
    final outputFile = ref.watch(outputStringProvider) ?? 'No file selected';
    final status = ref.watch(statusProvider);
    final convertButtonEnabled = ref.watch(buttonEnabledProvider);
    log('ButtonEnabled: $convertButtonEnabled');

    return Padding(
      padding: const EdgeInsets.all(100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (fileInput == '')
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Press folder button to select file to convert',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    if (fileInput != '')
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'File to be converted: $fileInput',
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const FileSelector(),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Converted file: $outputFile',
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            //add dialog that edits file name
                            showDialog<FileNameEditingDialog>(
                              context: context,
                              builder: (context) {
                                return const FileNameEditingDialog();
                              },
                            );
                          },
                          child: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  indent: 75,
                  endIndent: 75,
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: MediaThumbnailWidget(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Conversion Status: $status',
                      ),
                    ),
                  ),
                ),
                if (status == ConversionStatus.inProgress.message)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(100, 8, 100, 8),
                    child: LinearProgressIndicator(),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: FileTypeDropDown(),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: MediaDropDown(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ConvertMediaButton(
                          buttonEnabled: convertButtonEnabled,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
