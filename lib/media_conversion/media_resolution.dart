import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/utils/common_variables.dart';

///Creator that returns the chosen resolution as a MediaScale enum of either
///low, medium, high.
final outputScaleSelector = Creator.value(MediaScale.medium);

///Creator that takes the value from outputScaleSelector and returns
///a String representing the resolution that the media file will be converted to.
final outputScaleCreator = Creator((ref) {
  var scale = ref.watch(outputScaleSelector);
  String resultString;
  switch (scale) {
    case MediaScale.low:
      resultString = '480';
      break;
    case MediaScale.medium:
      resultString = '720';
      break;
    case MediaScale.high:
      resultString = '1080';
      break;
  }
  return resultString;
});
