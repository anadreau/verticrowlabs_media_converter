import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/media_conversion/media_conversion_barrel.dart';
import 'package:ffmpeg_converter/utils/utils_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//TO-DO: #24 Make text selectable and
//change text format to be more readable. @anadreau

///[ConsumerWidget] that displays screen if ffmpeg is installed
class ConverterScreen extends ConsumerWidget {
  ///Implementation of [ConverterScreen]
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileInput = ref.watch(fileInputStringProvider);
    final outputFile = ref.watch(outputStringProvider).toString();
    final status = ref.watch(statusProvider);
    return Padding(
      padding: const EdgeInsets.all(100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                if (fileInput == '')
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child:
                        Text('Press folder button to select file to convert'),
                  ),
                if (fileInput != '')
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'File to be converted: $fileInput',
                      softWrap: true,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8),
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
                  child: MaterialButton(
                    onPressed: () => _convertMedia(ref),
                    child: const Text('Convert'),
                  ),
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

Future<void> _convertMedia(WidgetRef ref) async {
  ref
      .read(conversionStatusProvider.notifier)
      .update((state) => ConversionStatus.inProgress);
  final input = ref.read(fileInputStringProvider);
  final output = ref.read(outputStringProvider);
  final scale = ref.read(outputScaleCreator);

  final ffmpegCmd = switch (scale) {
    '480' =>
      'ffmpeg -i "$input" -vf scale=$scale:-2 -c:v libx264 "$output" | echo',
    '720' =>
      'ffmpeg -i "$input" -vf scale=$scale:-2 -c:v libx264 "$output" | echo',
    '1280' =>
      'ffmpeg -i "$input" -vf scale=1280:720 -c:v libx264 "$output" | echo',
    _ => 'ffmpeg -i "$input" -vf scale=$scale:-2 -c:v libx264 "$output" | echo'
  };
  log('scale is: $scale');
  log('ffmpeg cmd being run:\n$ffmpegCmd');

  final result = await Isolate.run(
    () => Process.runSync(
      'powershell.exe',
      ['-Command', updateEvironmentVariableCmd, ';', ffmpegCmd],
    ),
  );

  if (result.exitCode == 0) {
    log(result.stdout.toString());
    ref
        .read(conversionStatusProvider.notifier)
        .update((state) => ConversionStatus.done);
    log('Finished');
  } else {
    log(result.stderr.toString());
    ref
        .read(conversionStatusProvider.notifier)
        .update((state) => ConversionStatus.error);
    log('Error');
  }
}
