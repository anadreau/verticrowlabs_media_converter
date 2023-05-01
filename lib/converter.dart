import 'dart:developer';
import 'dart:io';

import 'package:creator/creator.dart';

enum Status { notStarted, inProgress, done, error }

final inputStringCreator = Creator.value(
    '"C:/Users/anadr/Videos/Convert/Puss.in.Boots.The.Last.Wish.2022.1080p.WEBRip.x264-RARBG.mp4"');
final outputStringCreator = Creator.value(
    'C:/Users/anadr/Videos/Convert/Puss.in.Boots.The.Last.Wish.720.mp4');
//const command = 'ping google.com | ConvertTo-Json';
final outputScaleCreator = Creator.value('720');
final conversionStatusCreator = Creator.value(Status.notStarted);

final convertMediaEmitter = Emitter((ref, emit) {
  var input = ref.read(inputStringCreator);
  var output = ref.read(outputStringCreator);
  var scale = ref.read(outputScaleCreator);

  final ffmpegCmd =
      'ffmpeg -i $input -vf scale=$scale:-2 -c:v libx264 $output | ConvertTo-Json';
  ref.set(conversionStatusCreator, Status.inProgress);
  final result = Process.runSync('powershell.exe', ['-Command', ffmpegCmd]);

  if (result.exitCode == 0) {
    log(result.stdout);
    ref.set(conversionStatusCreator, Status.done);
    log('Finished');
  } else {
    log(result.stderr);
    ref.set(conversionStatusCreator, Status.error);
  }
});
