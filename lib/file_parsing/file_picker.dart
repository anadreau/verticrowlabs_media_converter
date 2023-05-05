import 'dart:developer';
import 'dart:io';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:file_picker/file_picker.dart';

final filePickerCreator = Creator((ref) async {
  var result =
      Process.runSync('powershell.exe', ['-Command', '\$env:USERPROFILE']);
  //var dir = await getDownloadsDirectory();
  var removeNewlineCode = result.stdout.toString().split('\n');
  log(removeNewlineCode[0]);
  log(removeNewlineCode.toString());
  String videoFolder = removeNewlineCode[0];
  String videoPath = videoFolder;
  log('VideoPath: $videoPath');

  var file = await FilePicker.platform.pickFiles(
      initialDirectory: videoPath,
      dialogTitle: 'Chosose Media File to Convert.',
      allowMultiple: false,
      type: FileType.media);
  if (file != null) {
    ref.set(fileInputStringCreator, file.paths[0].toString());
    log('FilePath: ${file.paths[0].toString()}');
    log('FileName: ${file.names}');
  } else {
    ref.set(fileInputStringCreator, 'No File Selected to Convert');
  }
});
