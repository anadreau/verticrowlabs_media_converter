import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';

///Creator that holds the variable for file type to be converted to
final containerTypeCreator = Creator.value(MediaContainerType.mp4);

final mediaTypeCreator = Creator(
  (ref) {
    MediaContainerType type = ref.watch(containerTypeCreator);
    String typeOutput = switch (type) {
      MediaContainerType.avi => '.avi',
      MediaContainerType.flv => '.flv',
      MediaContainerType.mkv => '.mkv',
      MediaContainerType.mov => '.mov',
      MediaContainerType.mp4 => '.mp4',
    };
    return typeOutput;
  },
);
