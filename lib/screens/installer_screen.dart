import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/ffmpeg_install_helper/ffmpeg_install_helper.dart';
import 'package:ffmpeg_converter/ffmpeg_install_helper/ffmpeg_verify_install.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:flutter/material.dart';

class InstallerScreen extends StatelessWidget {
  const InstallerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Ffmpeg is not installed on this device.'),
            )),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Watcher((context, ref, child) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        ref.read(ffmpegInstallCreator);
                      },
                      child: const Row(
                        children: [
                          Text('Install'),
                          SizedBox(width: 8),
                          Icon(Icons.install_desktop),
                        ],
                      ),
                    ),
                  ),
                )),
            const SizedBox(
              width: 15,
            ),
            Watcher((context, ref, child) {
              if (ref.watch(ffmpegInstallStatusCreator) !=
                  InstallStatus.installed) {
                return CircularProgressIndicator(
                  value: ref.watch(ffmpegInstallStatusTrackerCreator),
                );
              }
              return const SizedBox();
            }),
          ],
        ),
      ],
    ));
  }
}
