import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/infrastructure/models/mediatime.dart';

///[TimeRangeSelector] to check if checkbox is selected and allow
///the input of time 00:00:00.000
class TimeRangeSelector extends ConsumerWidget {
  ///[TimeRangeSelector] Default Constructor
  const TimeRangeSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempDuration = ref.watch(maxTimeProvider);
    //final start = ref.watch(startTimeProvider);
    //final end = ref.watch(endTimeProvider);
    final startRangeValue = ref.watch(startRangeProvider);
    final endRangeValue = ref.watch(endRangeProvider);
    final mediaDuration = MediaTime().mediaTimeFromString(tempDuration);
    final rangeEnd = MediaTime().durationFromMediaTimeToSeconds(
      hours: mediaDuration.hours,
      minutes: mediaDuration.minutes,
      seconds: mediaDuration.seconds,
    );
    final formattedStart =
        MediaTime().durationFromSecondsToString(seconds: startRangeValue);
    final formattedEnd =
        MediaTime().durationFromSecondsToString(seconds: endRangeValue);
    log('start: ${startRangeValue.toStringAsFixed(3)}');
    log('end: ${endRangeValue.toStringAsFixed(3)}');
    return Row(
      children: [
        Text(
          formattedStart,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: RangeSlider(
            max: rangeEnd,
            values: RangeValues(startRangeValue, endRangeValue),
            onChanged: (RangeValues newValues) {
              ref
                  .read(startRangeProvider.notifier)
                  .update((state) => newValues.start);
              ref
                  .read(endRangeProvider.notifier)
                  .update((state) => newValues.end);
            },
          ),
        ),
        Text(
          formattedEnd,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

///[StateProvider] Holds value for the start of the [TimeRangeSelector]
final startRangeProvider = StateProvider((ref) => 0.0);

///[StateProvider] Holds value for the end of the [TimeRangeSelector]
final endRangeProvider = StateProvider((ref) {
  final tempDuration = ref.watch(maxTimeProvider);
  final mediaDuration = MediaTime().mediaTimeFromString(tempDuration);
  final rangeEnd = MediaTime().durationFromMediaTimeToSeconds(
    hours: mediaDuration.hours,
    minutes: mediaDuration.minutes,
    seconds: mediaDuration.seconds,
  );
  return rangeEnd;
});
