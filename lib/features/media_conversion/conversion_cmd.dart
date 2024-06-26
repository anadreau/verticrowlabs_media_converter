import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/features/file_parsing/file_parsing_barrel.dart';
import 'package:verticrowlabs_media_converter/features/media_conversion/media_conversion_barrel.dart';
import 'package:verticrowlabs_media_converter/features/media_snipping/time_range_selector.dart';

///[Provider] that handles logic for which ffmpeg cmd is selected when
///convert_button is pressed.
Provider<String> conversionCmd = Provider<String>((ref) {
  final input = ref.watch(fileInputStringProvider);
  final output = ref.watch(outputStringProvider);
  final scale = ref.watch(outputScaleCreator);
  final startTime = ref.watch(startRangeProvider);
  final endTime = ref.watch(endRangeProvider);

  final ffmpegCmd = switch (scale) {
    //SD
    '480' => '''
ffmpeg -hide_banner -stats -i "$input" -ss $startTime -to $endTime -vf scale=640:$scale -c:v libx264 "$output"''',
    //HD
    '720' => '''
ffmpeg -hide_banner -stats -i "$input" -ss $startTime -to $endTime -vf scale=1280:$scale -c:v libx264 "$output"''',
    //1080p
    '1080' => '''
ffmpeg -hide_banner -stats -i "$input" -ss $startTime -to $endTime -vf scale=1920:1080 -c:v libx264 "$output"''',

    //Default
    _ => '''
ffmpeg -hide_banner -stats -i "$input" -ss $startTime -to $endTime -vf scale=1920:1080 -c:v libx264 "$output"'''
  };
  //log('scale is: $scale');
  //log('StartTime: $startTime & EndTime: $endTime');
  // log('ffmpeg cmd being run:\n$ffmpegCmd');

  return ffmpegCmd;
});

///[StateProvider] for log of last conversion that was run's output.
final cmdLog = StateProvider((ref) => '');
