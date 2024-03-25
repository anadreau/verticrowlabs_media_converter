import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/file_parsing/file_parsing_barrel.dart';
import 'package:verticrowlabs_media_converter/media_conversion/media_conversion_barrel.dart';
import 'package:verticrowlabs_media_converter/utils/ffmpeg_cmd.dart';
import 'package:verticrowlabs_media_converter/utils/utils_barrel.dart';

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

  final cmd = ref.watch(ffmpegCmd);

  final result = await Isolate.run(
    () => Process.runSync(
      'powershell.exe',
      ['-Command', updateEvironmentVariableCmd, ';', cmd],
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
