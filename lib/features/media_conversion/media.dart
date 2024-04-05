import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:verticrowlabs_media_converter/features/install_ffmpeg/installer_cmds.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_variables/common_enums.dart';

///[Media] holds all functions and variables related
///to a piece of media that is being converted.
class Media {
  ///Variable for Container Codec type [MediaContainerType]
  MediaContainerType? format;

  ///Variable for Conversion status [ConversionStatus]
  ConversionStatus? conversionStatus;

  ///Variable for resolution of media [MediaScale]
  MediaScale? resolution;

  ///Variable for Start time of media [double]
  double? startTime;

  ///Variable for End time of media [double]
  double? endTime;

  ///String containing original path of media [String?]
  String? originalFilePath;

  ///String containing new path name including raw path and new name
  ///of media [String?]
  String? newFilePath;

  ///converts the selected media file
  Future<List<dynamic>> convertMedia(String conversionCmd) async {
    final result = await Isolate.run(
      () => Process.run(
        'powershell.exe',
        ['-Command', updateEvironmentVariableCmd, ';', conversionCmd, '| echo'],
        runInShell: true,
      ),
    );

    if (result.exitCode == 0) {
      return [true, result.exitCode, result.stderr];
      //log('Finished');
    } else {
      log(result.stderr.toString());

      return [false, result.exitCode, result.stderr];
    }
  }

  ///Function that takes a originalFilePath, newFilePath
  ///resolution scale, startTime, and endTime and
  ///returns a FFmpeg cmd in String format to be used.
  String conversionCmd({
    required String? originalFilePath,
    required String newFilePath,
    required String scale,
    required double startTime,
    required double endTime,
  }) {
    final ffmpegCmd = switch (scale) {
      //SD
      '480' => '''
ffmpeg -hide_banner -stats -i "$originalFilePath" -ss $startTime -to $endTime -vf scale=640:$scale -c:v libx264 "$newFilePath"''',
      //HD
      '720' => '''
ffmpeg -hide_banner -stats -i "$originalFilePath" -ss $startTime -to $endTime -vf scale=1280:$scale -c:v libx264 "$newFilePath"''',
      //1080p
      '1080' => '''
ffmpeg -hide_banner -stats -i "$originalFilePath" -ss $startTime -to $endTime -vf scale=1920:1080 -c:v libx264 "$newFilePath"''',

      //Default
      _ => '''
ffmpeg -hide_banner -stats -i "$originalFilePath" -ss $startTime -to $endTime -vf scale=1920:1080 -c:v libx264 "$newFilePath"'''
    };
    log('ffmpeg used: $ffmpegCmd');
    return ffmpegCmd;
  }
}
