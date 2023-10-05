import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/media_conversion/media_conversion_barrel.dart';
import 'package:ffmpeg_converter/utils/utils_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConverterScreen extends ConsumerWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String fileInput = ref.watch(fileInputStringProvider);
    String outputFile = ref.watch(outputStringProvider).toString();
    String status = ref.watch(statusProvider);
    return Padding(
      padding: const EdgeInsets.all(100.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  if (fileInput == '')
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Text('Press folder button to select file to convert'),
                    ),
                  if (fileInput != '')
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'File to be converted: $fileInput',
                        softWrap: true,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Converted file: $outputFile',
                      softWrap: true,
                    ),
                  ),
                  const Divider(
                    indent: 75,
                    endIndent: 75,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Conversion Status: $status',
                          ),
                        )),
                  ),
                ],
              )),
          if (status == ConversionStatus.inProgress.message)
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      ref
                          .read(conversionStatusProvider.notifier)
                          .update((state) => ConversionStatus.inProgress);
                      ref.read(convertMediaProvider);
                    },
                    child: const Text('Convert'),
                  ),
                ),
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
                  //TODO: #15 implement admin path variable update. @anadreau

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
              )
            ],
          ),
        ],
      ),
    );
  }
}
