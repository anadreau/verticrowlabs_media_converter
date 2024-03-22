import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/global_variables/common_variables.dart';
import 'package:verticrowlabs_media_converter/media_conversion/container_type.dart';

///List of MediaContainerType as enum
const List<MediaContainerType> dropDownListEnum = MediaContainerType.values;

///List of MediaContainerType as String
List<String> dropDownListasString =
    dropDownListEnum.map((e) => e.containerType).toList();

///[ConsumerStatefulWidget] that returns a [DropdownButton] to select
///[MediaContainerType]
class FileTypeDropDown extends ConsumerStatefulWidget {
  ///Implementation of [FileTypeDropDown]
  const FileTypeDropDown({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FileTypeDropDownState();
}

class _FileTypeDropDownState extends ConsumerState<FileTypeDropDown> {
  String initialListValue = dropDownListasString.first;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: DropdownButton<String>(
          iconEnabledColor: theme.colorScheme.onPrimaryContainer,
          dropdownColor: theme.colorScheme.primaryContainer,
          focusColor: Colors.white.withOpacity(0),
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
              final selectedType = switch (initialListValue) {
                'avi' => MediaContainerType.avi,
                'flv' => MediaContainerType.flv,
                'mkv' => MediaContainerType.mkv,
                'mov' => MediaContainerType.mov,
                'mp4' => MediaContainerType.mp4,
                _ => MediaContainerType.mp4
              };
              log('DropDown type: $selectedType');
              ref
                  .read(containerTypeProvider.notifier)
                  .update((state) => selectedType);
            });
          },
        ),
      ),
    );
  }
}
