import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/media_snipping/media_snipping.dart';

///[TimeSelector] to check if checkbox is selected and allow
///the input of time 00:00:00.000
class TimeSelector extends ConsumerWidget {
  ///[TimeSelector] Default Constructor
  const TimeSelector({
    required this.stateProvider,
    required this.timePosition,
    super.key,
  });

  final StateProvider<bool?> stateProvider;
  final TimePosition timePosition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkValue = ref.watch(stateProvider);

    return Row(
      children: [
        Checkbox(
          value: checkValue,
          onChanged: (bool? newValue) {
            ref.read(stateProvider.notifier).update((state) => newValue);
          },
        ),
        switch (timePosition) {
          TimePosition.start => const Text('Start 00:00:00'),
          TimePosition.end => const Text('End 00:00:00'),
        },
      ],
    );
  }
}
