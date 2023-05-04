import 'package:flutter/material.dart';

Future<void> fileNameEditDialog(BuildContext context) {
  TextEditingController fileNameController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Edit File Name'),
              TextFormField(
                controller: fileNameController,
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
            MaterialButton(
              onPressed: () {},
              child: const Text('Confirm'),
            )
          ],
        );
      });
}
