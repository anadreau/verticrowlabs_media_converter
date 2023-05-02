import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/converter.dart';
import 'package:flutter/material.dart';

final List<String> dropDownList = ['480', '720', '1080'];

class MediaDropDown extends StatefulWidget {
  const MediaDropDown({super.key});

  @override
  State<MediaDropDown> createState() => _MediaDropDownState();
}

class _MediaDropDownState extends State<MediaDropDown> {
  var dropdownValue = dropDownList.first;
  @override
  Widget build(BuildContext context) {
    return Watcher((context, ref, child) {
      return DropdownButton<String>(
          dropdownColor: ThemeData().scaffoldBackgroundColor,
          focusColor: Colors.white.withOpacity(0.0),
          value: dropdownValue,
          items: dropDownList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              dropdownValue = value!;
              switch (value) {
                case '480':
                  ref.set(outputScaleSelector, MediaScale.low);
                  break;
                case '720':
                  ref.set(outputScaleSelector, MediaScale.medium);
                  break;
                case '1080':
                  ref.set(outputScaleSelector, MediaScale.high);
                  break;
              }
            });
          });
    });
  }
}
