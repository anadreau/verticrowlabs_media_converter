import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///Creator that holds the variable for file type to be converted to
final containerTypeProvider = StateProvider((ref) => MediaContainerType.mp4);

final mediaTypeProvider = Provider(
  (ref) {
    final type = ref.watch(containerTypeProvider);
    final typeOutput = switch (type) {
      MediaContainerType.avi => '.avi',
      MediaContainerType.flv => '.flv',
      MediaContainerType.mkv => '.mkv',
      MediaContainerType.mov => '.mov',
      MediaContainerType.mp4 => '.mp4',
    };
    return typeOutput;
  },
);
