import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/file_parsing/file_parsing_barrel.dart';
import 'package:verticrowlabs_media_converter/media_conversion/conversion_status.dart';
import 'package:verticrowlabs_media_converter/media_snipping/media_snipping.dart';
import 'package:verticrowlabs_media_converter/thumbnail_generator/thumbnail_barrel.dart';
import 'package:verticrowlabs_media_converter/utils/common_variables.dart';

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
            ref.read(fileNameProvider.notifier).update((state) => ''),
            _fileSelector(ref)
                .then((_) => generateThumbnail(ref))
                .then((_) => mediaDurationProbe(ref)),
            ref.read(thumbnailLoadedProvider.notifier).update((state) => false),
            ref
                .read(conversionStatusProvider.notifier)
                .update((state) => ConversionStatus.notStarted),
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
