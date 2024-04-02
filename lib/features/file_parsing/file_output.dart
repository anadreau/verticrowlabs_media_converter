import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/features/file_parsing/file_parsing.dart';
import 'package:verticrowlabs_media_converter/features/file_parsing/file_parsing_barrel.dart';

///Takes file path and file name and returns
///new filepath with new name if file name is
///not null.
final outputStringProvider = Provider((ref) {
  final input = ref.watch(fileInputStringProvider);
  final fileName = ref.watch(fileNameProvider);
  return FileParser().filePathParser(
    input,
    fileName,
  );
});
