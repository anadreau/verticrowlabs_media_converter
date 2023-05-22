///Enum for conversion status
enum Status {
  notStarted('Not Started'),
  inProgress('In Progress'),
  done('Done'),
  error('Error');

  final String message;
  const Status(this.message);
}

///Enum for Resolution quality
enum MediaScale {
  medium('720'),
  low('480'),
  high('1080');

  final String resolution;
  const MediaScale(this.resolution);
}

///ENum for Container type
enum MediaContainerType {
  mp4('mp4'),
  mkv('mkv'),
  mov('mov'),
  avi('avi'),
  flv('flv');

  final String containerType;
  const MediaContainerType(this.containerType);
}

enum FfmpegInstallStatus { notInstalled, installed }
