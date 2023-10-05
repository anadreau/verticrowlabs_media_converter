import 'package:ffmpeg_converter/ffmpeg_install_helper/ffmpeg_install_helper.dart';
import 'package:ffmpeg_converter/ffmpeg_install_helper/ffmpeg_verify_install.dart';
import 'package:ffmpeg_converter/global_variables/common_variables.dart';
import 'package:ffmpeg_converter/screens/converter_screen.dart';
import 'package:ffmpeg_converter/screens/installer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: ConverterApp()));
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
        body: const InstallScreen(),
      ),
    );
  }
}

class InstallScreen extends ConsumerWidget {
  const InstallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(verifyFfmpegInstallProvider);
    final ffmpegInstalled = ref.watch(ffmpegInstallStatusProvider);
    switch (ffmpegInstalled) {
      case InstallStatus.notInstalled:
        return const InstallerScreen();
      case InstallStatus.installed:
        return const ConverterScreen();
      default:
        return const InstallScreen();
    }
  }
}
