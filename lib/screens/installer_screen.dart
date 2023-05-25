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
        Watcher((context, ref, child) {
          if (ref.watch(ffmpegInstallStatusCreator) ==
              InstallStatus.notInstalled) {
            return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Ffmpeg is not installed on this device.'),
                ));
          } else {
            return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(ref.watch(ffmpegInstallStatusCreator).message),
                ));
          }
        }),
        const SizedBox(
          height: 15,
        ),
        Watcher((context, ref, _) {
          if (ref.watch(ffmpegInstallStatusCreator) !=
                  InstallStatus.installed &&
              ref.watch(ffmpegInstallStatusCreator) !=
                  InstallStatus.notInstalled) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(100, 0, 100, 15),
              //TODO: #16 Smooth out animation of indicator. @anadreau
              child: LinearProgressIndicator(
                value: ref.watch(ffmpegInstallStatusTrackerCreator),
              ),
            );
          } else {
            return const SizedBox();
          }
        }),
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
          ],
        ),
      ],
    ));
  }
}
