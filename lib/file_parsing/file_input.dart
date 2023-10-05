import 'package:flutter_riverpod/flutter_riverpod.dart';

///String containing full file path of file chosen by file picker.
///
///Default value is ''
final fileInputStringProvider = StateProvider<String>((ref) => '');
final fileNameProvider = StateProvider<String>((ref) => '');
