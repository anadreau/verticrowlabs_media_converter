import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

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
    final parsedDuration = durationString.replaceAll(RegExp('duration='), '');
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
  String durationFromMediaTimeToString({
    int? hours,
    int? minutes,
    double? seconds,
  }) {
    final durationhrs = hours.toString();
    final durationmins = minutes.toString();
    final durationseconds = seconds.toString();
    return '$durationhrs:$durationmins:$durationseconds';
  }

  ///function takes the hours, minutes, and seconds and returns
  ///seconds
  double durationFromMediaTimeToSeconds({
    int? hours,
    int? minutes,
    double? seconds,
  }) {
    final temphours = hours ?? 0;
    final tempminutes = minutes ?? 0;
    final tempseconds = seconds ?? 0;
    final durationInSeconds =
        (((temphours * 60) + tempminutes) * 60) + tempseconds;
    return durationInSeconds;
  }

  ///function takes seconds and formats to hrs:mins:seconds
  String durationFromSecondsToString({double? seconds}) {
    final hours = (seconds! / 3600).truncate();
    final remainingSeconds = seconds - (hours * 3600);
    final minutes = (remainingSeconds / 60).truncate();
    final remainingSeconds2 = remainingSeconds - (minutes * 60);

    final formattedHours = hours.toString().padLeft(2, '0');
    final formattedMinutes = minutes.toString().padLeft(2, '0');
    final formattedSeconds =
        remainingSeconds2.toStringAsFixed(3).padLeft(2, '0');

    return '$formattedHours:$formattedMinutes:$formattedSeconds';
  }
}

///variable [StateProvider]<String> to hold -to stop time in 00:00:00 format
///variable defaults to '' when not used
final endTimeProvider = StateProvider((ref) => ref.watch(maxTimeProvider));

///[StateProvider] that sets the length of the selected media
///so that [endTimeProvider] can not exceed it.
final maxTimeProvider = StateProvider((ref) => '');
