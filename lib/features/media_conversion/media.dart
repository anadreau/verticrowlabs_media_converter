import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/features/install_ffmpeg/installer_cmds.dart';

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

///Creator that holds the variable for file type to be converted to
final containerTypeProvider = StateProvider((ref) => MediaContainerType.mp4);

///[Provider] that returns [MediaContainerType] based on [containerTypeProvider]
final mediaTypeProvider = Provider(
  (ref) {
    final type = ref.watch(containerTypeProvider);
    final typeOutput = switch (type) {
      MediaContainerType.avi => '.avi',
      MediaContainerType.flv => '.flv',
      MediaContainerType.mkv => '.mkv',
      MediaContainerType.mov => '.mov',
      MediaContainerType.mp4 => '.mp4',
    };
    return typeOutput;
  },
);

///Creator that returns the status of the media conversion as a Status enum of
///either notStarted, inProgress, done, or error
final conversionStatusProvider =
    StateProvider((ref) => ConversionStatus.notStarted);

///Creator that takesthe value from conversionStatusCreator and returns a
///String representing the status of the media file conversion.
final statusProvider = StateProvider((ref) {
  final status = ref.watch(conversionStatusProvider);

  return switch (status) {
    ConversionStatus.notStarted => ConversionStatus.notStarted.message,
    ConversionStatus.inProgress => ConversionStatus.inProgress.message,
    ConversionStatus.done => ConversionStatus.done.message,
    ConversionStatus.error => ConversionStatus.error.message
  };
});

///Creator that returns the chosen resolution as a MediaScale enum of either
///low, medium, high.
final outputScaleSelector = StateProvider((ref) => MediaScale.medium);

///Creator that takes the value from outputScaleSelector and returns
///a String representing the resolution
///that the media file will be converted to.
final outputScaleCreator = Provider((ref) {
  final scale = ref.watch(outputScaleSelector);

  return switch (scale) {
    MediaScale.low => MediaScale.low.resolution,
    MediaScale.medium => MediaScale.medium.resolution,
    MediaScale.high => MediaScale.high.resolution
  };
});

///Enum for Container Codec type
enum MediaContainerType {
  ///Container type is .mp4
  mp4('mp4'),

  ///Container type is .mkv
  mkv('mkv'),

  ///Container type is .mov
  mov('mov'),

  ///Container type is .avi
  avi('avi'),

  ///Container type is .flv
  flv('flv');

  const MediaContainerType(this.containerType);

  ///Returns [MediaContainerType] as a [String]
  final String containerType;
}

///Enum for Resolution quality
enum MediaScale {
  ///Resolution quality is 720p
  medium('720'),

  ///Resolution quality is 480p
  low('480'),

  ///Resolution quality is 1280p
  high('1280');

  const MediaScale(this.resolution);

  ///Returns [MediaScale] as a [String]
  final String resolution;
}

///Enum for conversion status
enum ConversionStatus {
  ///Conversion has not started
  notStarted('Not Started'),

  ///Conversion is in progress
  inProgress('In Progress'),

  ///Conversion is completed
  done('Done'),

  ///Conversion has returned an error
  error('Error');

  const ConversionStatus(this.message);

  ///Returns [ConversionStatus] as a [String]
  final String message;
}
