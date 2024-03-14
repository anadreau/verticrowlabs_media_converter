import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:ffmpeg_converter/utils/pwsh_cmd.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

///[ConsumerWidget] that sets [fileInputStringProvider] when button is pressed.
class FileSelector extends ConsumerWidget {
  ///Implementation of [FileSelector]
  const FileSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: MaterialButton(
          onPressed: () => {
            _fileSelector(ref).then((_) => _generateThumbnail(ref)),
          },
          child: Icon(
            Icons.folder,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}

Future<void> _fileSelector(WidgetRef ref) async {
  final path = await FilePicker.platform.pickFiles(
    dialogTitle: 'Chosose Media File to Convert.',
    type: FileType.media,
  );
  if (path?.paths.first != null) {
    ref.read(fileInputStringProvider.notifier).state = path!.paths.first;
  }
}

Future<void> _generateThumbnail(WidgetRef ref) async {
  final input = ref.read(fileInputStringProvider);
  final thumbnailPath = await getTemporaryDirectory();
  log('Thumbnail dir: ${thumbnailPath.path}');

  final ffmpegCmd =
      """ffmpeg -i $input -vf "select='eq(pict_type,PICT_TYPE_I)'" -vsync vfr -ss 00:00:30 -vframes 1 ${thumbnailPath.path}/thumbnail.jpg""";

  final result = await Isolate.run(
    () => Process.runSync(
      'powershell.exe',
      ['-Command', updateEvironmentVariableCmd, ';', ffmpegCmd],
    ),
  );

  if (result.exitCode == 0) {
    log('Finished Generating Thumbnail: ${result.stdout}');
  } else {
    log('Error in Generating Thumbnail: ${result.stderr}');
  }
}
