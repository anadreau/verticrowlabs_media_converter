//TO-DO: #34 Implement video snipping. @anadreau

//example: ffmpeg -i input.mp4 -ss 00:05:00 -to 00:06:00 output.mp4
//example: ffmpeg -i input.mp4 -ss 00:00:00 -to 00:00:00 -vf scale=1920:1080
// -c:v libx264 output.mp4

//ffmpeg cmd
import 'package:flutter_riverpod/flutter_riverpod.dart';

String ffmpegCmd = '';
//variable [Provider]<String> to hold -ss start time in 00:00:00 format
//variable defaults to '' when not used
///
final startTimeProvider = Provider((ref) => '');
//variable [Provider]<String> to hold -to stop time in 00:00:00 format
//variable defaults to '' when not used
final endTimeProvider = Provider((ref) => '');
