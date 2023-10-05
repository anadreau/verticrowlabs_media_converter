import 'dart:developer';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/media_conversion/media_conversion_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final List<MediaScale> mediaScaledropDownList = MediaScale.values.toList();

final List<String> dropDownList =
    mediaScaledropDownList.map((e) => e.resolution).toList();

class MediaDropDown extends ConsumerStatefulWidget {
  const MediaDropDown({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MediaDropDownState();
}

class _MediaDropDownState extends ConsumerState<MediaDropDown> {
  var dropdownValue = dropDownList.first;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: DropdownButton<String>(
            iconEnabledColor: theme.colorScheme.onPrimaryContainer,
            dropdownColor: theme.colorScheme.primaryContainer,
            focusColor: Colors.white.withOpacity(0.0),
            value: dropdownValue,
            items: dropDownList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text('${value}p'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                dropdownValue = value!;

                log('dropdownValue: $dropdownValue');
                MediaScale scale = switch (dropdownValue) {
                  '480' => MediaScale.low,
                  '720' => MediaScale.medium,
                  '1080' => MediaScale.high,
                  _ => MediaScale.medium
                };
                ref.read(outputScaleSelector.notifier).update((state) => scale);
              });
            }),
      ),
    );
  }
}
