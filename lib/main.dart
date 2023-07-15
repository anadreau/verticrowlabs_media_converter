import 'package:creator/creator.dart';
import 'package:ffmpeg_converter/ffmpeg_install_helper/ffmpeg_verify_install.dart';
import 'package:ffmpeg_converter/screens/converter_screen.dart';
import 'package:ffmpeg_converter/screens/installer_screen.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(CreatorGraph(child: const ConverterApp()));
}

class ConverterApp extends StatelessWidget {
  const ConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Resoration scope in place so that non debug shows correctly
      //instead of all blank
      restorationScopeId: 'bugFix',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Watcher((context, ref, child) {
          ref.watch(verifyFfmpegInstallCreator);
          var ffmpegInstalled = ref.watch(ffmpegInstallStatusCreator);
          if (ffmpegInstalled == InstallStatus.installed) {
            return const ConverterScreen();
          } else {
            return const InstallerScreen();
          }
        }),
      ),
    );
  }
}
