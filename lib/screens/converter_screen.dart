import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/media_conversion/media_conversion_barrel.dart';
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
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                if (fileInput == '')
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: SelectableText(
                      'Press folder button to select file to convert',
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
                    child: Text('Image will go here.'),
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
                  child: MaterialButton(
                    onPressed: buttonEnabled ? () => _convertMedia(ref) : null,
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

///[StateProvider] to track state of convert button and disable if fileInput
///is blank.
final buttonEnabledProvider = StateProvider((ref) {
  final fileInput = ref.watch(fileInputStringProvider);
  if (fileInput == '' || fileInput == ' ') {
    log('FileInput was $fileInput so returning false');
    return false;
  } else {
    log('File input was not $fileInput so returning true');
    return true;
  }
});

Future<void> _convertMedia(WidgetRef ref) async {
  log('ConvertMedia started.');
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
    ref.read(fileNameProvider.notifier).update((state) => '');

    log('Finished');
  } else {
    log(result.stderr.toString());
    ref
        .read(conversionStatusProvider.notifier)
        .update((state) => ConversionStatus.error);
    log('Error');
  }
}

Future<void> _generateThumbnail(WidgetRef ref) async {
  final input = ref.read(fileInputStringProvider);

  final ffmpegCmd =
      """ffmpeg -i $input -vf "select='eq(pict_type,PICT_TYPE_I)'" -vsync vfr -ss 00:00:30 -vframes 1 thumbnail2.jpg""";

  final result = await Isolate.run(
    () => Process.runSync(
      'powershell.exe',
      ['-Command', updateEvironmentVariableCmd, ';', ffmpegCmd],
    ),
  );
}
