import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/media_conversion/media_conversion_barrel.dart';
import 'package:ffmpeg_converter/utils/utils_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///[ConsumerWidget] Button that starts media conversion when pressed.
///disabled/enabled based on [buttonEnabled] value
class ConvertMediaButton extends ConsumerWidget {
  ///[ConvertMediaButton] Default constructor.
  const ConvertMediaButton({
    required this.buttonEnabled,
    super.key,
  });

  ///[buttonEnabled] if true [_convertMedia] is run when button is pressed.
  ///if false, button is disabled.
  final bool buttonEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialButton(
      onPressed: buttonEnabled ? () => _convertMedia(ref) : null,
      child: const Text('Convert'),
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
    //SD
    '480' =>
      'ffmpeg -i "$input" -vf scale=640:$scale -c:v libx264 "$output" | echo',
    //HD
    '720' =>
      'ffmpeg -i "$input" -vf scale=1280:$scale -c:v libx264 "$output" | echo',
    //1080p
    '1280' =>
      'ffmpeg -i "$input" -vf scale=1920:1080 -c:v libx264 "$output" | echo',

    //Default
    _ => 'ffmpeg -i "$input" -vf scale=1920:1080 -c:v libx264 "$output" | echo'
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
