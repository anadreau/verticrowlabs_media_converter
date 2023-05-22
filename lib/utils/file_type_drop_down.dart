import 'dart:developer';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/media_conversion/container_type.dart';
import 'package:ffmpeg_converter/utils/common_variables.dart';
import 'package:flutter/material.dart';

///List of MediaContainerType as enum
const List<MediaContainerType> dropDownListEnum = MediaContainerType.values;

///List of MediaContainerType as String
List<String> dropDownListasString =
    dropDownListEnum.map((e) => e.containerType).toList();

class FileTypeDropDown extends StatefulWidget {
  const FileTypeDropDown({super.key});

  @override
  State<FileTypeDropDown> createState() => _FileTypeDropDownState();
}

class _FileTypeDropDownState extends State<FileTypeDropDown> {
  var initialListValue = dropDownListasString.first;
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      final theme = Theme.of(context);
      return DropdownButton<String>(
          iconEnabledColor: theme.colorScheme.primaryContainer,
          dropdownColor: theme.colorScheme.primaryContainer,
          focusColor: Colors.white.withOpacity(0.0),
          value: initialListValue,
          items: dropDownListasString
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              initialListValue = value!;
              log('Dropdown value: $value');
              MediaContainerType selectedType = switch (initialListValue) {
                'avi' => MediaContainerType.avi,
                'flv' => MediaContainerType.flv,
                'mkv' => MediaContainerType.mkv,
                'mov' => MediaContainerType.mov,
                'mp4' => MediaContainerType.mp4,
                _ => MediaContainerType.mp4
              };
              log('DropDown type: $selectedType');
              ref.set(containerTypeCreator, selectedType);
            });
          });
    });
  }
}
