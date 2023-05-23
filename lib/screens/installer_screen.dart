import 'package:creator/creator.dart';
import 'package:flutter/material.dart';

class InstallerScreen extends StatelessWidget {
  const InstallerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        const Text('Ffmpeg is not installed on this device.'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Watcher((context, ref, child) => MaterialButton(
                  onPressed: () {},
                  child: const Text('Install'),
                )),
            const SizedBox(width: 15),
            const CircularProgressIndicator()
          ],
        ),
      ],
    ));
  }
}
