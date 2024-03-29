import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/features/file_parsing/file_parsing_barrel.dart';
import 'package:verticrowlabs_media_converter/features/media_conversion/media_conversion_barrel.dart';
import 'package:verticrowlabs_media_converter/features/media_snipping/time_range_selector.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_variables/common_enums.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_variables/ffmpeg_cmd.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_variables/pwsh_cmd.dart';
import 'package:verticrowlabs_media_converter/infrastructure/models/mediatime.dart';

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
    return Padding(
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
    );
  }
}

///[StateProvider] to track state of convert button and disable if fileInput
///is blank.
final buttonEnabledProvider = StateProvider((ref) {
  final fileInput = ref.watch(fileInputStringProvider);
  if (fileInput == '' || fileInput == ' ') {
    //log('FileInput was $fileInput so returning false');
    return false;
  } else {
    //log('File input was not $fileInput so returning true');
    return true;
  }
});

Future<void> _convertMedia(WidgetRef ref) async {
  //log('ConvertMedia started.');
  ref
      .read(conversionStatusProvider.notifier)
      .update((state) => ConversionStatus.inProgress);

  final cmd = ref.watch(ffmpegCmd);
  log('ffmpeg used: $cmd');

  final result = await Isolate.run(
    () => Process.run(
      'powershell.exe',
      ['-Command', updateEvironmentVariableCmd, ';', cmd, '| echo'],
      runInShell: true,
    ),
  );

  if (result.exitCode == 0) {
    ref.read(cmdLog.notifier).update((state) => result.stderr.toString());

    log('Process Result:${result.stdout}');
    //for some reason ffmpeg output is going to stderr
    log('Process err: ${result.stderr}');

    ref
        .read(conversionStatusProvider.notifier)
        .update((state) => ConversionStatus.done);
    ref.read(fileNameProvider.notifier).update((state) => '');
    ref.read(startRangeProvider.notifier).update((state) => 0.0);
    ref.read(maxTimeProvider.notifier).update((state) => '');

    //log('Finished');
  } else {
    log(result.stderr.toString());
    ref.read(cmdLog.notifier).update((state) => result.stderr.toString());
    ref
        .read(conversionStatusProvider.notifier)
        .update((state) => ConversionStatus.error);
    log('Error');
  }
}
