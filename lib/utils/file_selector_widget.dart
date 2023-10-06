import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///[ConsumerWidget] that sets [fileInputStringProvider] when button is pressed.
class FileSelector extends ConsumerWidget {
  ///Implementation of [FileSelector]
  const FileSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: MaterialButton(
          onPressed: () => _fileSelector(ref),
          child: Icon(
            Icons.folder,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}

Future<void> _fileSelector(WidgetRef ref) async {
  final path = await FilePicker.platform.pickFiles(
    dialogTitle: 'Chosose Media File to Convert.',
    type: FileType.media,
  );

  ref.read(fileInputStringProvider.notifier).state =
      path?.paths.first ?? 'No file selected';
}
