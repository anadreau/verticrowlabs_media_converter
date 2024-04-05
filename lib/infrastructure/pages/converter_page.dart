import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/features/file_parsing/file_parsing_barrel.dart';
import 'package:verticrowlabs_media_converter/features/media_conversion/ffmpeg_cmd.dart';
import 'package:verticrowlabs_media_converter/features/media_conversion/media_conversion_barrel.dart';
import 'package:verticrowlabs_media_converter/features/media_snipping/time_range_selector.dart';
import 'package:verticrowlabs_media_converter/features/thumbnail_generator/thumbnail_widget.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_variables/common_enums.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_widgets/file_selector_widget.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_widgets/file_type_drop_down.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_widgets/output_dialog.dart';
import 'package:verticrowlabs_media_converter/infrastructure/common_widgets/resolution_drop_down.dart';
import 'package:verticrowlabs_media_converter/infrastructure/models/mediatime.dart';

///[ConverterPage] that displays if ffmpeg is installed
///Main screen where files and options can be selected
///to convert.
class ConverterPage extends ConsumerWidget {
  ///Implementation of [ConverterPage]
  const ConverterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fileInput = ref.watch(fileInputStringProvider);
    final outputFile = ref.watch(outputStringProvider);
    final status = ref.watch(statusProvider);
    final convertButtonEnabled = ref.watch(buttonEnabledProvider);
    final validEndTime = ref.watch(maxTimeProvider);

    return Padding(
      padding: const EdgeInsets.all(50),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _FileInputRow(fileInput: fileInput),
            _FileOutputRow(outputFile: outputFile),
            const Divider(
              indent: 75,
              endIndent: 75,
            ),
            _ConversionStatusWidget(status: status),
            const Flexible(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: MediaThumbnailWidget(),
              ),
            ),
            if (validEndTime != '' &&
                status != ConversionStatus.inProgress.message)
              const Padding(
                padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: TimeRangeSelector(),
              ),
            if (status == ConversionStatus.inProgress.message)
              const Padding(
                padding: EdgeInsets.fromLTRB(100, 8, 100, 8),
                child: LinearProgressIndicator(),
              ),
            Flexible(
              flex: 0,
              child: _ConversionButtonsRow(
                convertButtonEnabled: convertButtonEnabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileInputRow extends StatelessWidget {
  const _FileInputRow({
    required this.fileInput,
  });

  final String? fileInput;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (fileInput == '')
          const Flexible(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Press folder button to select file to convert',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        if (fileInput != '')
          Flexible(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                fileInput!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        //Selects Input file.
        const FileSelector(),
      ],
    );
  }
}

class _FileOutputRow extends StatelessWidget {
  const _FileOutputRow({
    required this.outputFile,
  });

  final String outputFile;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              outputFile,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: MaterialButton(
              onPressed: () {
                //add dialog that edits file name
                showDialog<FileNameEditingDialog>(
                  context: context,
                  builder: (context) {
                    return const FileNameEditingDialog();
                  },
                );
              },
              child: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ConversionStatusWidget extends StatelessWidget {
  const _ConversionStatusWidget({
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Conversion Status: $status',
              ),
            ),
            //Displays the AlertDialog icon only if the conversion
            //has completed with done or error status
            if (status == ConversionStatus.done.message ||
                status == ConversionStatus.error.message)
              GestureDetector(
                onTap: () {
                  showDialog<AlertDialog>(
                    context: context,
                    builder: (context) {
                      return OutputDialog(
                        log: cmdLog,
                      );
                    },
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.nearby_error),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ConversionButtonsRow extends StatelessWidget {
  const _ConversionButtonsRow({
    required this.convertButtonEnabled,
  });

  final bool convertButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: FileTypeDropDown(),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: MediaDropDown(),
        ),
        ConvertMediaButton(
          buttonEnabled: convertButtonEnabled,
        ),
      ],
    );
  }
}
