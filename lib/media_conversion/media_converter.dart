import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/media_conversion/conversion_status.dart';
import 'package:ffmpeg_converter/media_conversion/media_resolution.dart';
import 'package:ffmpeg_converter/utils/pwsh_cmd.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///Creator function that takes inputStringCreator, outputStringcreator, and
///outputScaleCreator and forms a ffmpeg cmd that runs in a powershell
///process that updates conversionStatusCreator when the process finishes
///with a done status or error status
final convertMediaProvider = FutureProvider((ref) async {
  final input = ref.read(fileInputStringProvider);
  final output = ref.read(outputStringProvider);
  final scale = ref.read(outputScaleCreator);

  final ffmpegCmd =
      'ffmpeg -i "$input" -vf scale=$scale:-2 -c:v libx264 "$output" | echo';

  ///Runs powershell cmd in an Isolate as to not freeze rest of app while
  ///conversion is taking place.
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
  }
});
