import 'dart:developer';
import 'dart:io';

import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filePickerCreator = Provider((ref) async {
  final result =
      Process.runSync('powershell.exe', ['-Command', r'$env:USERPROFILE']);
  //var dir = await getDownloadsDirectory();
  final removeNewlineCode = result.stdout.toString().split('\n');
  log(removeNewlineCode[0]);
  log(removeNewlineCode.toString());
  final videoFolder = removeNewlineCode[0];
  final videoPath = videoFolder;
  log('VideoPath: $videoPath');

  final file = await FilePicker.platform.pickFiles(
      initialDirectory: videoPath,
      dialogTitle: 'Chosose Media File to Convert.',
      type: FileType.media,);
  if (file != null) {
    ref
        .read(fileInputStringProvider.notifier)
        .update((state) => file.paths[0].toString());
    log('FilePath: ${file.paths[0]}');
    log('FileName: ${file.names}');
  } else {
    ref
        .read(fileInputStringProvider.notifier)
        .update((state) => 'No File Selected to Convert');
  }
});
