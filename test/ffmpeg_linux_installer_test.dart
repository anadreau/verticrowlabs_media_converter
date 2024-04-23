import 'package:flutter_test/flutter_test.dart';
import 'package:verticrowlabs_media_converter/features/install_ffmpeg/ffmpeg_linux_installer.dart';

void main() {
  group('Test Linux installation and verification', () {
    test('Is linux installed', () async {
      await FfmpegLinuxInstaller().verifyInstallation();
    });
  });
}
