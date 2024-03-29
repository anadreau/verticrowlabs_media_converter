import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/features/file_parsing/file_parsing_barrel.dart';

///String containing full path of file
final filePathCreator = Provider((ref) {
  final fileInput = ref.watch(fileInputStringProvider);
  final parsedFileBySlash = fileInput!.split('/');
  String? filePathResult;

  if (fileInput != '') {
    final workingParsedFileList = parsedFileBySlash;

    ///String that represents the original filename
    final oldFileName = parsedFileBySlash.removeLast();

    ///Removes last item in list which should be the old file name
    workingParsedFileList.removeRange(
      parsedFileBySlash.length,
      parsedFileBySlash.length,
    );

    ///Joins the workingParsedFileList by / into single String
    final joinedOutput = workingParsedFileList.join('/');

    ///finds the index where the file type starts based on last '.'
    final filetypeIndex = oldFileName.lastIndexOf('/');

    filePathResult = joinedOutput.substring(0, filetypeIndex);
  } else {
    filePathResult = null;
  }
  return filePathResult;
});
