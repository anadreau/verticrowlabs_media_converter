import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/features/file_parsing/file_parsing_barrel.dart';

///Alert dialog that sets the String from textController to filename
class FileNameEditingDialog extends StatefulWidget {
  ///Implementation of [FileNameEditingDialog]
  const FileNameEditingDialog({super.key});

  @override
  State<FileNameEditingDialog> createState() => _FileNameEditingDialogState();
}

class _FileNameEditingDialogState extends State<FileNameEditingDialog> {
  final formkey = GlobalKey<FormFieldState<dynamic>>();
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
          formkey: formkey,
          fileNameController: fileNameController,
        ),
      ],
    );
  }
}

///ConsumerWidget that gives access to [fileNameProvider]
class EditButtonConsumer extends ConsumerWidget {
  ///Implementation of [EditButtonConsumer]
  const EditButtonConsumer({
    required this.formkey,
    required this.fileNameController,
    super.key,
  });

  ///FormKey for [EditButtonConsumer]
  final GlobalKey<FormFieldState<dynamic>> formkey;

  ///[TextEditingController] for [EditButtonConsumer]
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
