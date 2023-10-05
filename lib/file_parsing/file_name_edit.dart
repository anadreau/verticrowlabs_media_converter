import 'package:ffmpeg_converter/file_parsing/file_parsing_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

///Alert dialog that sets the String from textController to filename

class FileNameEditingDialog extends StatefulWidget {
  const FileNameEditingDialog({super.key});

  @override
  State<FileNameEditingDialog> createState() => _FileNameEditingDialogState();
}

class _FileNameEditingDialogState extends State<FileNameEditingDialog> {
  final formkey = GlobalKey<FormFieldState>();
  TextEditingController fileNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Edit File Name'),
          TextFormField(
            key: formkey,
            controller: fileNameController,
            validator: (value) =>
                value == null || value.isEmpty || value.trimRight().isEmpty
                    ? 'Name cannot be blank'
                    : null,
          ),
        ],
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            fileNameController.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        EditButtonConsumer(
            formkey: formkey, fileNameController: fileNameController),
      ],
    );
  }
}

class EditButtonConsumer extends ConsumerWidget {
  const EditButtonConsumer({
    super.key,
    required this.formkey,
    required this.fileNameController,
  });

  final GlobalKey<FormFieldState> formkey;
  final TextEditingController fileNameController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialButton(
      onPressed: () {
        if (formkey.currentState!.validate()) {
          ref
              .read(fileNameProvider.notifier)
              .update((state) => fileNameController.text.trimRight());
          Navigator.of(context).pop();
          fileNameController.clear();
        }
      },
      child: const Text('Confirm'),
    );
  }
}
