import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';

///Creator that returns the chosen resolution as a MediaScale enum of either
///low, medium, high.
final outputScaleSelector = Creator.value(MediaScale.medium);

///Creator that takes the value from outputScaleSelector and returns
///a String representing the resolution that the media file will be converted to.
final outputScaleCreator = Creator((ref) {
  var scale = ref.watch(outputScaleSelector);
  String resultString;
  resultString = switch (scale) {
    MediaScale.low => MediaScale.low.resolution,
    MediaScale.medium => MediaScale.medium.resolution,
    MediaScale.high => MediaScale.high.resolution
  };
  return resultString;
});
