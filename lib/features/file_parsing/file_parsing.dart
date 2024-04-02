///[FileParser] Handles file input and output functions
class FileParser {
  ///Takes a String and splits it into a list by backslash
  List<String> fileNameParser(String? fileInput) {
    return fileInput!.split(r'\');
  }

  ///Takes a list and removes the last value
  ///which would be the file name.
  String oldFileName(List<String> parsedFile) {
    return parsedFile.removeLast();
  }

  ///Takes a String and removes the file name
  ///returning just the raw path of the file.
  String rawPath(String fileInput) {
    final workingList = fileNameParser(fileInput);
    final oldName = oldFileName(workingList);
    workingList.removeWhere((element) => element == oldName);
    return workingList.join(r'\');
  }

  ///Takes a String and keeps the old file name or
  ///replaces it with the new file name if one is given.
  String filePathParser(String? fileInput, String? fileName) {
    final workingFile = fileNameParser(fileInput);
    final oldName = oldFileName(workingFile);
    if (fileName == null && fileInput != '') {
      return '${rawPath(fileInput!)}\\$oldName';
    }
    if (fileName == null && fileInput == '') {
      return 'No file selected';
    } else {
      return '${rawPath(fileInput!)}\\$fileName';
    }
  }
}
