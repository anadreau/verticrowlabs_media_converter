import 'dart:developer';

import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/media_conversion/media_conversion_barrel.dart';
import 'package:ffmpeg_converter/media_conversion/thumbnail.dart';
import 'package:ffmpeg_converter/utils/utils_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///[ConsumerWidget] that displays screen if ffmpeg is installed
class ConverterScreen extends ConsumerWidget {
  ///Implementation of [ConverterScreen]
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileInput = ref.watch(fileInputStringProvider);
    final outputFile = ref.watch(outputStringProvider) ?? 'No file selected';
    final status = ref.watch(statusProvider);
    final buttonEnabled = ref.watch(buttonEnabledProvider);
    log('ButtonEnabled: $buttonEnabled');

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
                if (fileInput == '')
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: SelectableText(
                      'Press folder button to select file to convert',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                if (fileInput != '')
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'File to be converted: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SelectableText(
                              fileInput.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Converted file: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SelectableText(
                              outputFile,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const Divider(
                  indent: 75,
                  endIndent: 75,
                ),
                if (fileInput != '')
                  const Padding(
                    padding: EdgeInsets.all(8),
                    //TO-DO: #25 add thumbnail for selected file. @anadreau
                    child: SizedBox(
                      height: 250,
                      width: 250,
                      child: MediaThumbnailWidget(),
                    ),
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
                      child: SelectableText(
                        'Conversion Status: $status',
                      ),
                    ),
                  ),
                ),
              ],
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
                  child: ConvertMediaButton(buttonEnabled: buttonEnabled),
                ),
              ),
              const FileSelector(),
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
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  //TO-DO: #15 implement admin path variable update. @anadreau

                  // child: MaterialButton(
                  //   onPressed: () {
                  //     return ref.read(ffmpegadminInstallCreator);
                  //   },
                  //   child: Icon(
                  //     Icons.install_mobile,
                  //     color: Theme.of(context).colorScheme.onBackground,
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
