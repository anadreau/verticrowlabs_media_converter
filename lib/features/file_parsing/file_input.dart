import 'package:flutter_riverpod/flutter_riverpod.dart';

///[Provider} containing full file path of file chosen by file picker.
///
///Default value is ''
final fileInputStringProvider = StateProvider<String?>((ref) => '');

///[Provider} containing full file path of file chosen by file picker.
///
///Default value is ''
final fileNameProvider = StateProvider<String?>((ref) => null);
