import 'dart:developer';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/media_conversion/media_conversion_barrel.dart';
import 'package:flutter/material.dart';

final List<MediaScale> mediaScaledropDownList = MediaScale.values.toList();

final List<String> dropDownList =
    mediaScaledropDownList.map((e) => e.resolution).toList();

class MediaDropDown extends StatefulWidget {
  const MediaDropDown({super.key});

  @override
  State<MediaDropDown> createState() => _MediaDropDownState();
}

class _MediaDropDownState extends State<MediaDropDown> {
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
        child: Watcher((context, ref, child) {
          return DropdownButton<String>(
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
                  ref.set(outputScaleSelector, scale);
                });
              });
        }),
      ),
    );
  }
}
