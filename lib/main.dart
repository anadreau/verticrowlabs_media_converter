import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:verticrowlabs_media_converter/ffmpeg_install_helper/ffmpeg_install_helper.dart';
import 'package:verticrowlabs_media_converter/ffmpeg_install_helper/ffmpeg_verify_install.dart';
import 'package:verticrowlabs_media_converter/global_variables/common_variables.dart';
import 'package:verticrowlabs_media_converter/screens/converter_screen.dart';
import 'package:verticrowlabs_media_converter/screens/installer_screen.dart';

void main() {
  runApp(const ProviderScope(child: ConverterApp()));
}

///Root of application
class ConverterApp extends StatelessWidget {
  ///Implementation of [ConverterApp]
  const ConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Resoration scope in place so that non debug shows correctly
      //instead of all blank
      restorationScopeId: 'bugFix',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      //[SelectionArea] Allows text in app to be selectable. Used for copy and
      //paste functionality.
      home: SelectionArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: const DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/GlobeBackground.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: InstallScreen(),
          ),
        ),
      ),
    );
  }
}

///ConsumerWidget that returns either ConverterScreen or InstallScreen
///based on [ffmpegInstallStatusProvider] status
class InstallScreen extends ConsumerWidget {
  ///Implementation of [InstallScreen]
  const InstallScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(verifyFfmpegInstallProvider);
    final ffmpegInstalled = ref.watch(ffmpegInstallStatusProvider);
    return switch (ffmpegInstalled) {
      InstallStatus.notInstalled => const InstallerScreen(),
      InstallStatus.installed => const ConverterScreen(),
      _ => const InstallerScreen()
    };
  }
}
