import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///Creator that returns the chosen resolution as a MediaScale enum of either
///low, medium, high.
final outputScaleSelector = StateProvider((ref) => MediaScale.medium);

///Creator that takes the value from outputScaleSelector and returns
///a String representing the resolution
///that the media file will be converted to.
final outputScaleCreator = Provider((ref) {
  final scale = ref.watch(outputScaleSelector);

  return switch (scale) {
    MediaScale.low => MediaScale.low.resolution,
    MediaScale.medium => MediaScale.medium.resolution,
    MediaScale.high => MediaScale.high.resolution
  };
});
