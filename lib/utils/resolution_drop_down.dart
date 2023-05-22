import 'dart:developer';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/media_conversion/media_conversion_barrel.dart';
import 'package:ffmpeg_converter/utils/common_variables.dart';
import 'package:flutter/material.dart';

final List<MediaScale> dropDownListEnum = MediaScale.values.toList();

final List<String> dropDownList =
    dropDownListEnum.map((e) => e.resolution).toList();

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
    return Watcher((context, ref, child) {
      return DropdownButton<String>(
          iconEnabledColor: theme.colorScheme.primaryContainer,
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
    });
  }
}
