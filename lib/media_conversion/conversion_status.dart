import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';

///Creator that returns the status of the media conversion as a Status enum of
///either notStarted, inProgress, done, or error
final conversionStatusCreator = Creator.value(ConversionStatus.notStarted);

///Creator that takesthe value from conversionStatusCreator and returns a
///String representing the status of the media file conversion.
final statusCreator = Creator((ref) {
  ConversionStatus status = ref.watch(conversionStatusCreator);
  String statusString;

  statusString = switch (status) {
    ConversionStatus.notStarted => ConversionStatus.notStarted.message,
    ConversionStatus.inProgress => ConversionStatus.inProgress.message,
    ConversionStatus.done => ConversionStatus.done.message,
    ConversionStatus.error => ConversionStatus.error.message
  };
  return statusString;
});
