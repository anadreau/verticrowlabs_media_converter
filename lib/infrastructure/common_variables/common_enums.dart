//TO-DO: #36 Streamline enums using enum.name if all
//that is being used is the string. @anadreau

///Enum for conversion status
enum ConversionStatus {
  ///Conversion has not started
  notStarted('Not Started'),

  ///Conversion is in progress
  inProgress('In Progress'),

  ///Conversion is completed
  done('Done'),

  ///Conversion has returned an error
  error('Error');

  const ConversionStatus(this.message);

  ///Returns [ConversionStatus] as a [String]
  final String message;
}

///Enum for Resolution quality
enum MediaScale {
  ///Resolution quality is 720p
  medium('720'),

  ///Resolution quality is 480p
  low('480'),

  ///Resolution quality is 1280p
  high('1280');

  const MediaScale(this.resolution);

  ///Returns [MediaScale] as a [String]
  final String resolution;
}

///Enum for Container Codec type
enum MediaContainerType {
  ///Container type is .mp4
  mp4('mp4'),

  ///Container type is .mkv
  mkv('mkv'),

  ///Container type is .mov
  mov('mov'),

  ///Container type is .avi
  avi('avi'),

  ///Container type is .flv
  flv('flv');

  const MediaContainerType(this.containerType);

  ///Returns [MediaContainerType] as a [String]
  final String containerType;
}

///Enum for Installation status
enum InstallStatus {
  ///Installation status is not installed
  notInstalled('Not Installed'),

  ///Installation status is create directory
  createDir('Creating Directory'),

  ///Installation status is download package
  downloadPackage('Downloading Package'),

  ///Installation status is extract package
  extractPackage('Extracting Package'),

  ///Installation status is move package
  movePackage('Moving Package'),

  ///Installation status is clean up directory
  cleanUpDir('Cleaning up Directory'),

  ///Installation status is set path variable
  setPathVariable('Setting Path Variable'),

  ///Installation status is update path variable
  updatePathVariable('Updating Path Variable'),

  ///Installation status is installed
  installed('Installation Complete'),

  ///Installation status is returning an error
  error('Installation error');

  const InstallStatus(this.message);

  ///Returns [InstallStatus] as [String]
  final String message;
}
