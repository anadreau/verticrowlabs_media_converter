import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/features/file_parsing/file_input.dart';
import 'package:verticrowlabs_media_converter/features/install_ffmpeg/installer_cmds.dart';
import 'package:verticrowlabs_media_converter/infrastructure/models/mediatime.dart';

// ffprobe cmd to get duration:

///Function to probe duration of selected media
Future<void> mediaDurationProbe(WidgetRef ref) async {
  final input = ref.watch(fileInputStringProvider);
  final durationProbe = '''
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1 -sexagesimal "$input"''';

  final result = await Isolate.run(
    () => Process.runSync(
      'powershell.exe',
      [
        '-Command',
        updateEvironmentVariableCmd,
        ';',
        durationProbe,
      ],
    ),
  );

  if (result.exitCode == 0) {
    //log('Probe stdout: ${result.stdout}');
    //log('Probe stderr: ${result.stderr}');
    final duration = MediaTime().mediaTimeFromString(result.stdout.toString());
    final durationFormatted = duration.durationFromMediaTimeToString(
      hours: duration.hours,
      minutes: duration.minutes,
      seconds: duration.seconds,
    );
    //log('Duration: $durationFormatted');
    ref.read(maxTimeProvider.notifier).update((state) => durationFormatted);
  } else {
    log('Error in Generating Thumbnail: ${result.stderr}');
  }
}
