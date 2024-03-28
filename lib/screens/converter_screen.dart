import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/file_parsing/file_parsing_barrel.dart';
import 'package:verticrowlabs_media_converter/media_conversion/media_conversion_barrel.dart';
import 'package:verticrowlabs_media_converter/media_conversion/output_dialog.dart';
import 'package:verticrowlabs_media_converter/media_snipping/media_snipping.dart';
import 'package:verticrowlabs_media_converter/thumbnail_generator/thumbnail_widget.dart';
import 'package:verticrowlabs_media_converter/utils/time_selector.dart';
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
    final validEndTime = ref.watch(maxTimeProvider);
    log('ButtonEnabled: $convertButtonEnabled');

    return Padding(
      padding: const EdgeInsets.all(50),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (fileInput == '')
                  const Flexible(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Press folder button to select file to convert',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                if (fileInput != '')
                  Flexible(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        fileInput!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                //Selects Input file.
                const FileSelector(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      outputFile,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Conversion Status: $status',
                      ),
                    ),
                    //Displays the AlertDialog icon only if the conversion
                    //has completed with done or error status
                    if (status == ConversionStatus.done.message ||
                        status == ConversionStatus.error.message)
                      GestureDetector(
                        onTap: () {
                          showDialog<AlertDialog>(
                            context: context,
                            builder: (context) {
                              return const OutputDialog();
                            },
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Icons.nearby_error),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Flexible(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: MediaThumbnailWidget(),
              ),
            ),
            if (validEndTime != '' &&
                status != ConversionStatus.inProgress.message)
              const Padding(
                padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: TimeRangeSelector(),
              ),
            if (status == ConversionStatus.inProgress.message)
              const Padding(
                padding: EdgeInsets.fromLTRB(100, 8, 100, 8),
                child: LinearProgressIndicator(),
              ),
            Flexible(
              flex: 0,
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }
}
