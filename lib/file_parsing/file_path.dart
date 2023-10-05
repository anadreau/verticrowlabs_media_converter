import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///String containing full path of file
final filePathCreator = Provider((ref) {
  var fileInput = ref.watch(fileInputStringProvider);
  var parsedFileBySlash = fileInput.split('/');
  String? filePathResult;

  if (fileInput != '') {
    List workingParsedFileList = parsedFileBySlash;

    ///String that represents the original filename
    var oldFileName = parsedFileBySlash.removeLast();

    ///Removes last item in list which should be the old file name
    workingParsedFileList.removeRange(
        parsedFileBySlash.length, parsedFileBySlash.length);

    ///Joins the workingParsedFileList by / into single String
    String joinedOutput = workingParsedFileList.join('/');

    ///finds the index where the file type starts based on last '.'
    int filetypeIndex = oldFileName.lastIndexOf('/');

    filePathResult = joinedOutput.substring(0, filetypeIndex);
  } else {
    filePathResult = null;
  }
  return filePathResult;
});
