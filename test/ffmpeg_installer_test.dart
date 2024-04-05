import 'package:flutter_test/flutter_test.dart';

import 'package:verticrowlabs_media_converter/features/install_ffmpeg/ffmpeg_installer.dart';

void main() {
  group('Testing FfmpegInstaller:', () {
    test('Creates dir', () async {
      expect(await FfmpegInstaller().createDir(), true);
    });

    test(
      'Download Ffmpeg',
      () async {
        expect(await FfmpegInstaller().downloadFfmpeg(), true);
      },
      timeout: const Timeout(Duration(minutes: 5)),
    );
    test('Extract FFmpeg', () async {
      expect(await FfmpegInstaller().extractFfmpeg(), true);
    });
    test('Move Ffmpeg', () async {
      expect(await FfmpegInstaller().moveFfmpeg(), true);
    });
    test('Clean up dir', () async {
      expect(await FfmpegInstaller().cleanFfmpegDir(), true);
    });
    test('Set Path Variable', () async {
      expect(await FfmpegInstaller().setPathVariable(), true);
    });
    test('Update Path Variable', () async {
      expect(await FfmpegInstaller().updatePathVariable(), true);
    });
    test('Update Path Variable', () async {
      expect(await FfmpegInstaller().updatePathVariable(), true);
    });
  });
}
