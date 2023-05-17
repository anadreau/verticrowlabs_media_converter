import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/utils/common_variables.dart';

///Creator that returns the status of the media conversion as a Status enum of
///either notStarted, inProgress, done, or error
final conversionStatusCreator = Creator.value(Status.notStarted);

///Creator that takesthe value from conversionStatusCreator and returns a
///String representing the status of the media file conversion.
final statusCreator = Creator((ref) {
  Status status = ref.watch(conversionStatusCreator);
  String statusString;

  statusString = switch (status) {
    Status.notStarted => 'Not Started',
    Status.inProgress => 'In Progress',
    Status.done => 'Done',
    Status.error => 'error'
  };
  return statusString;
});
