import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/file_parsing/file_input.dart';
import 'package:verticrowlabs_media_converter/utils/utils_barrel.dart';

///variable [StateProvider]<String> to hold -ss start time in 00:00:00 format
///variable defaults to '' when not used
final startTimeProvider = StateProvider((ref) => '');

///variable [StateProvider]<String> to hold -to stop time in 00:00:00 format
///variable defaults to '' when not used
final endTimeProvider = StateProvider((ref) => '');

///[StateProvider] that sets the length of the selected media
///so that [endTimeProvider] can not exceed it.
final maxTimeProvider = StateProvider((ref) => '');

// ffprobe cmd to get duration:

///Function to probe duration of selected media
Future<void> mediaDurationProbe(WidgetRef ref) async {
  final input = ref.watch(fileInputStringProvider);
  final durationProbe = '''
ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1 -sexagesimal $input''';

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
    log('Probe stdout: ${result.stdout}');
    log('Probe stderr: ${result.stderr}');
    final duration = result.stdout.toString();
    final durationFormatted = duration.substring(9);
    log('Duration: $durationFormatted');
    ref.read(maxTimeProvider.notifier).update((state) => durationFormatted);
  } else {
    log('Error in Generating Thumbnail: ${result.stderr}');
  }
}
