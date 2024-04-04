import 'package:test/test.dart';
import 'package:verticrowlabs_media_converter/features/install_ffmpeg/ffmpeg_installer.dart';

void main() {
  group('Testing FfmpegInstaller:', () {
    test('Creates dir', () {
      FfmpegInstaller().createDir();
    });
  });
}
