import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';

enum Status { notStarted, inProgress, done, error }

enum MediaScale { low, medium, high }

final inputStringCreator = Creator.value(
    '"C:/Users/anadr/Videos/Convert/Puss.in.Boots.The.Last.Wish.2022.1080p.WEBRip.x264-RARBG.mp4"');
final outputStringCreator = Creator((ref) {
  var input = ref.watch(inputStringCreator);
  var output = input.split('/');

  List newOutput = output;
  var oldFileName = output.removeLast();
  newOutput.removeRange(output.length, output.length);
  var joinedOutput = newOutput.join('/');
  //var test = joinedOutput.substring(1);
  var filetypeIndex = oldFileName.lastIndexOf('.');
  var newFileName = '${oldFileName.substring(0, filetypeIndex)}.converted.mp4';
  log('Joined: $joinedOutput');
  log('old: $oldFileName');
  log('new: $newFileName');
  String result = '$joinedOutput/$newFileName';
  String finalResult = result.substring(1);
  log('result: $result');
  log('result: $finalResult');
  return finalResult;
});
//const command = 'ping google.com | ConvertTo-Json';
final outputScaleSelector = Creator.value(MediaScale.medium);
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
final conversionStatusCreator = Creator.value(Status.notStarted);
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

final convertMediaCreator = Creator<void>((ref) async {
  var input = ref.read(inputStringCreator);
  var output = ref.read(outputStringCreator);
  var scale = ref.read(outputScaleCreator);

  final ffmpegCmd =
      'ffmpeg -i $input -vf scale=$scale:-2 -c:v libx264 $output | ConvertTo-Json | echo';

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
