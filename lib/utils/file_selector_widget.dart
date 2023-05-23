import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:flutter/material.dart';

class FileSelector extends StatelessWidget {
  const FileSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Watcher(
        (context, ref, child) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: MaterialButton(
            onPressed: () {
              ref.read(filePickerCreator);
            },
            child: Icon(
              Icons.folder,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
      ),
    );
  }
}
