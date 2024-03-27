import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/file_parsing/file_input.dart';
import 'package:verticrowlabs_media_converter/utils/utils_barrel.dart';

///[MediaTime] class to handle time information for selected media
///such as start time, end time, and duration.
class MediaTime {
  ///default consructor of [MediaTime]
  MediaTime({
    this.hours,
    this.minutes,
    this.seconds,
  });

  ///Media time hrs:Mins:seconds
  int? hours;

  ///Media time hrs:Mins:seconds
  int? minutes;

  ///Media time hrs:Mins:seconds
  double? seconds;

  ///function to parse from string to [MediaTime]
  MediaTime mediaTimeFromString(String durationString) {
    final parsedDuration = durationString.substring(9);
    final tempList = parsedDuration.split(':');
    final tempHours = int.parse(tempList[0]);
    final tempMinutes = int.parse(tempList[1]);
    final tempSeconds = double.parse(tempList[2]);
    return MediaTime(
      hours: tempHours,
      minutes: tempMinutes,
      seconds: tempSeconds,
    );
  }

  ///function parse from int to String in format 00:00:00.000
  String duration(int? hours, int? minutes, double? seconds) {
    final durationhrs = hours.toString();
    final durationmins = minutes.toString();
    final durationseconds = seconds.toString();
    return '$durationhrs:$durationmins:$durationseconds';
  }
}

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
    final duration = MediaTime().mediaTimeFromString(result.stdout.toString());
    final durationFormatted =
        duration.duration(duration.hours, duration.minutes, duration.seconds);
    log('Duration: $durationFormatted');
    ref.read(maxTimeProvider.notifier).update((state) => durationFormatted);
  } else {
    log('Error in Generating Thumbnail: ${result.stderr}');
  }
}

// Create function that parses the duration by splitting it by ":"
// then changing to int and validating it against the input numbers
// if all three values are equal or lower than max then allow the
// input -ss & -to time to be used.
