import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/utils/common_variables.dart';

///String containing full file path of file chosen by file picker.
///
///Default value is ''
final inputStringCreator = Creator.value('', name: 'inputStringCreator');
final fileNameCreator = Creator.value('', name: 'fileNameCreator');

///String containing full file path and new name used for converted file.
///
///Takes inputStringCreator value and parses and converts it into new file name.
final outputStringCreator = Creator((ref) {
  //TODO: #5 @anadreau Change variable names so function flow is easier to follow.
  var input = ref.watch(inputStringCreator);
  var output = input.split('/');
  String? finalResult;

  if (ref.read(inputStringCreator) != '') {
    List newOutput = output;
    var oldFileName = output.removeLast();
    newOutput.removeRange(output.length, output.length);
    var joinedOutput = newOutput.join('/');
    //var test = joinedOutput.substring(1);
    var filetypeIndex = oldFileName.lastIndexOf('.');
    var newFileName =
        '${oldFileName.substring(0, filetypeIndex)}.converted.mp4';
    log('Joined: $joinedOutput');
    log('old: $oldFileName');
    log('new: $newFileName');
    String result = '$joinedOutput/$newFileName';
    finalResult = result.substring(1);
    log('result: $result');
    log('result: $finalResult');
  } else {
    finalResult = null;
  }

  return finalResult;
});

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

///Creator that returns the status of the media conversion as a Status enum of
///either notStarted, inProgress, done, or error
final conversionStatusCreator = Creator.value(Status.notStarted);

///Creator that takesthe value from conversionStatusCreator and returns a
///String representing the status of the media file conversion.
final statusCreator = Creator((ref) {
  var status = ref.watch(conversionStatusCreator);
  String statusString;
  switch (status) {
    case Status.notStarted:
      statusString = 'notStarted';
      break;
    case Status.inProgress:
      statusString = 'inProgress';
      break;
    case Status.done:
      statusString = 'done';
      break;
    case Status.error:
      statusString = 'error';
      break;
  }
  return statusString;
});

///Creator function that takes inputStringCreator, outputStringcreator, and
///outputScaleCreator and forms a ffmpeg cmd that runs in a powershell
///process that updates conversionStatusCreator when the process finishes
///with a done status or error status
final convertMediaCreator = Creator<void>((ref) async {
  var input = ref.read(inputStringCreator);
  var output = ref.read(outputStringCreator);
  var scale = ref.read(outputScaleCreator);

  final ffmpegCmd =
      'ffmpeg -i $input -vf scale=$scale:-2 -c:v libx264 $output | ConvertTo-Json | echo';

  ///Runs powershell cmd in an Isolate as to not freeze rest of app while
  ///conversion is taking place.
  final result = await Isolate.run(
      () => Process.runSync('powershell.exe', ['-Command', ffmpegCmd]));

  if (result.exitCode == 0) {
    log(result.stdout);
    ref.set(conversionStatusCreator, Status.done);
    log('Finished');
  } else {
    log(result.stderr);
    ref.set(conversionStatusCreator, Status.error);
  }
});
