//TO-DO: #34 Implement video snipping. @anadreau

//example: ffmpeg -i input.mp4 -ss 00:05:00 -to 00:06:00 output.mp4
//example: ffmpeg -i input.mp4 -ss 00:00:00 -to 00:00:00 -vf scale=1920:1080
// -c:v libx264 output.mp4

import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/file_parsing/file_parsing_barrel.dart';
import 'package:verticrowlabs_media_converter/media_conversion/media_conversion_barrel.dart';
import 'package:verticrowlabs_media_converter/media_snipping/media_snipping.dart';

///[Provider] that handles logic for which ffmpeg cmd is selected when
///convert_button is pressed.
Provider<String> ffmpegCmd = Provider<String>((ref) {
  final input = ref.watch(fileInputStringProvider);
  final output = ref.watch(outputStringProvider);
  final scale = ref.watch(outputScaleCreator);
  final startTime = ref.watch(startTimeProvider);
  final endTime = ref.watch(endTimeProvider);

  final ffmpegCmd = switch (scale) {
    //SD
    '480' =>
      'ffmpeg -i "$input" $startTime $endTime -vf scale=640:$scale -c:v libx264 "$output" | echo',
    //HD
    '720' =>
      'ffmpeg -i "$input" $startTime $endTime -vf scale=1280:$scale -c:v libx264 "$output" | echo',
    //1080p
    '1080' =>
      'ffmpeg -i "$input" $startTime $endTime -vf scale=1920:1080 -c:v libx264 "$output" | echo',

    //Default
    _ =>
      'ffmpeg -i "$input" $startTime $endTime -vf scale=1920:1080 -c:v libx264 "$output" | echo'
  };
  log('scale is: $scale');
  log('StartTime: $startTime & EndTime: $endTime');
  log('ffmpeg cmd being run:\n$ffmpegCmd');

  return ffmpegCmd;
});
