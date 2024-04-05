import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///[AlertDialog] that displays the log of last run convesion.
class OutputDialog extends ConsumerWidget {
  ///[OutputDialog] default Constructor
  const OutputDialog({
    required this.log,
    super.key,
  });

  ///Put in [Provider<String>] that you want shown in the
  ///[OutputDialog]
  final StateProvider<String> log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cmdOutput = ref.watch(log);
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
