import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:verticrowlabs_media_converter/file_parsing/file_input.dart';
import 'package:verticrowlabs_media_converter/utils/pwsh_cmd.dart';

///[Provider] to track state of generated thumbnail.
final thumbnailLoadedProvider = StateProvider((ref) => false);

///[FutureProvider] that supplies the path to the thumbnail image in
///the temp folder on the machine.
final thumbnailPathProvider = FutureProvider((ref) async {
  final path = await getTemporaryDirectory();
  return path.path;
});

///Function that generates a Thumbnail from selected file and
///updates [thumbnailLoadedProvider]
Future<void> generateThumbnail(WidgetRef ref) async {
  final input = ref.read(fileInputStringProvider);
  final thumbnailPath = await getTemporaryDirectory();
  log('Thumbnail dir: ${thumbnailPath.path}');
  //Used to clear application cache that caused old thumbnail to be loaded
  //even though new thumbnail was generated.
  await FileImage(File('${thumbnailPath.path}/thumbnail.jpg')).evict();

  //Cmd that removes the thumbnail from previous media conversion.
  final clearTmpCmd = 'rm ${thumbnailPath.path}/thumbnail.jpg | echo';

  //Cmd that generates the thumbnail
  final ffmpegCmd =
      """ffmpeg -i '$input' -vf "select='eq(pict_type,PICT_TYPE_I)'" -vsync vfr -ss 00:01:00 -vframes 1 ${thumbnailPath.path}/thumbnail.jpg""";

  final result = await Isolate.run(
    () => Process.runSync(
      'powershell.exe',
      [
        '-Command',
        updateEvironmentVariableCmd,
        ';',
        clearTmpCmd,
        ';',
        ffmpegCmd,
      ],
    ),
  );

  if (result.exitCode == 0) {
    log('Finished Generating Thumbnail: ${result.stdout}');
    ref.read(thumbnailLoadedProvider.notifier).update((state) => true);
  } else {
    log('Error in Generating Thumbnail: ${result.stderr}');
  }
}
