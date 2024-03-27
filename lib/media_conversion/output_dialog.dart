import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/utils/ffmpeg_cmd.dart';

///[AlertDialog] that displays the log of last run convesion.
class OutputDialog extends ConsumerWidget {
  ///[OutputDialog] default Constructor
  const OutputDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cmdOutput = ref.watch(cmdLog);
    return Padding(
      padding: const EdgeInsets.all(50),
      child: AlertDialog(
        title: const Center(
          child: Text(
            'Output log',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: SelectionArea(
            child: Text(
              cmdOutput,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}
