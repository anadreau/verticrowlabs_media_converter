import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:creator/creator.dart';

enum Status { notStarted, inProgress, done, error }

final inputStringCreator = Creator.value(
    '"C:/Users/anadr/Videos/Convert/Puss.in.Boots.The.Last.Wish.2022.1080p.WEBRip.x264-RARBG.mp4"');
final outputStringCreator = Creator((ref) {
  var input = ref.watch(inputStringCreator);
  var output = input.split('/');
  var oldFileName = output.removeLast();
  List newOutput = output;
  newOutput.removeRange(output.length, output.length);
  var joinedOutput = newOutput.join('/');
  var filetypeIndex = oldFileName.lastIndexOf('.');
  var newFileName = '${oldFileName.substring(0, filetypeIndex)}720.mp4';
  log(joinedOutput);
  log('old: $oldFileName');
  log('new: $newFileName');
  return '$joinedOutput/$newFileName';
});
//const command = 'ping google.com | ConvertTo-Json';
final outputScaleCreator = Creator.value('720');
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
final statusEmitter = Emitter<String>((ref, emit) {
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
  emit(statusString);
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
