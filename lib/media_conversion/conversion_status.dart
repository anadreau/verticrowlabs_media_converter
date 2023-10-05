import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///Creator that returns the status of the media conversion as a Status enum of
///either notStarted, inProgress, done, or error
final conversionStatusProvider =
    StateProvider((ref) => ConversionStatus.notStarted);

///Creator that takesthe value from conversionStatusCreator and returns a
///String representing the status of the media file conversion.
final statusProvider = StateProvider((ref) {
  final status = ref.watch(conversionStatusProvider);
  String statusString;

  statusString = switch (status) {
    ConversionStatus.notStarted => ConversionStatus.notStarted.message,
    ConversionStatus.inProgress => ConversionStatus.inProgress.message,
    ConversionStatus.done => ConversionStatus.done.message,
    ConversionStatus.error => ConversionStatus.error.message
  };
  return statusString;
});
