import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/media_snipping/media_snipping.dart';

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
    final start = ref.watch(startTimeProvider);
    final end = ref.watch(endTimeProvider);
    final startRangeValue = ref.watch(startRangeProvider);
    final endRangeValue = ref.watch(endRangeProvider);
    final mediaDuration = MediaTime().mediaTimeFromString(tempDuration);
    final rangeEnd = MediaTime().durationInSeconds(
      hours: mediaDuration.hours,
      minutes: mediaDuration.minutes,
      seconds: mediaDuration.seconds,
    );
    log('start: $start');
    log('end: $end');
    return RangeSlider(
      max: rangeEnd,
      values: RangeValues(startRangeValue, rangeEnd),
      labels: RangeLabels(start, end),
      onChanged: (RangeValues newValues) {
        ref
            .read(startRangeProvider.notifier)
            .update((state) => newValues.start);
        ref.read(endRangeProvider.notifier).update((state) => newValues.end);
      },
    );
  }
}

final startRangeProvider = StateProvider((ref) => 0.0);
final endRangeProvider = StateProvider((ref) => 0.0);
