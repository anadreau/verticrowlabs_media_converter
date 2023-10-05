import 'dart:developer';
import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:ffmpeg_converter/media_conversion/container_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///String containing full file path and new name used for converted file.
///
///Takes inputStringCreator value and parses and converts it into new file name.
final outputStringProvider = Provider((ref) {
  var fileInput = ref.watch(fileInputStringProvider);
  var parsedFileBySlash = fileInput.split('\\');
  String? filePathResult;
  String newFileName;
  String result;
  String edittedFileName = ref.watch(fileNameProvider);
  String joinedOutput;
  String fileType = ref.watch(mediaTypeProvider);

  if (fileInput != '') {
    List workingParsedFileList = parsedFileBySlash;

    ///String that represents the original filename
    var oldFileName = parsedFileBySlash.removeLast();

    ///Removes last item in list which should be the old file name
    workingParsedFileList.removeRange(
        parsedFileBySlash.length, parsedFileBySlash.length);

    ///Joins the workingParsedFileList by / into single String
    joinedOutput = workingParsedFileList.join('\\');

    ///finds the index where the file type starts based on last '.'
    int filetypeIndex = oldFileName.lastIndexOf('.');

    if (edittedFileName.isNotEmpty || edittedFileName != '') {
      oldFileName = edittedFileName;
      newFileName = '$oldFileName$fileType';
      log('here');
    } else {
      ///Creates new String from oldFileName without the old filetype plus
      ///.converted.mp4
      log('skipped if statement');
      newFileName =
          '${oldFileName.substring(0, filetypeIndex)}.converted$fileType';
    }

    log('Joined: $joinedOutput');
    log('old: $oldFileName');
    log('new: $newFileName');
    result = '$joinedOutput\\$newFileName';
    filePathResult = result.substring(0);
    log('result: $result');
    log('result: $filePathResult');
  } else {
    filePathResult = null;
  }

  return filePathResult;
});
