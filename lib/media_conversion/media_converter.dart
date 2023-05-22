import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:ffmpeg_converter/media_conversion/conversion_status.dart';
import 'package:ffmpeg_converter/media_conversion/media_resolution.dart';
import 'package:ffmpeg_converter/utils/common_variables.dart';

///Creator function that takes inputStringCreator, outputStringcreator, and
///outputScaleCreator and forms a ffmpeg cmd that runs in a powershell
///process that updates conversionStatusCreator when the process finishes
///with a done status or error status
final convertMediaCreator = Creator<void>((ref) async {
  var input = ref.read(fileInputStringCreator);
  var output = ref.read(outputStringCreator);
  var scale = ref.read(outputScaleCreator);

  final ffmpegCmd =
      'ffmpeg -i "$input" -vf scale=$scale:-2 -c:v libx264 "$output" | echo';

  ///Runs powershell cmd in an Isolate as to not freeze rest of app while
  ///conversion is taking place.
  final result = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', ffmpegCmd]));

  if (result.exitCode == 0) {
    log(result.stdout);
    ref.set(conversionStatusCreator, Status.done);
    log('Finished');
  } else {
    log(result.stderr);
    ref.set(conversionStatusCreator, Status.error);
  }
});
