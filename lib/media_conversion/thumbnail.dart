import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:ffmpeg_converter/utils/utils_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

//Thumbnail function goes here.
class MediaThumbnailWidget extends StatelessWidget {
  const MediaThumbnailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Future<void> _generateThumbnail(WidgetRef ref) async {
  final input = ref.read(fileInputStringProvider);
  final thumbnailPath = await getTemporaryDirectory();
  log('Thumbnail dir: $thumbnailPath');

  final ffmpegCmd =
      """ffmpeg -i $input -vf "select='eq(pict_type,PICT_TYPE_I)'" -vsync vfr -ss 00:00:30 -vframes 1 $thumbnailPath/thumbnail.jpg""";

  final result = await Isolate.run(
    () => Process.runSync(
      'powershell.exe',
      ['-Command', updateEvironmentVariableCmd, ';', ffmpegCmd],
    ),
  );

  if (result.exitCode == 0) {
    log(result.stdout.toString());

    log('Finished Generating Thumbnail');
  } else {
    log('Error in Generating Thumbnail: ${result.stderr}');
  }
}

Future<FileImage> _retrieveThumbnail(WidgetRef ref) async {
  final thumbnailPath = await getTemporaryDirectory();
  final imageFile = File('$thumbnailPath/thumbnail.jpg');
  final imageFileExists = imageFile.existsSync();
  log('imageFileExists: $imageFileExists');
  if (imageFileExists == true) {
    return FileImage(imageFile);
  } else {
    final imageHolder = File('/assets/ImageHolder.jpg');
    return FileImage(imageHolder);
  }
}
