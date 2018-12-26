import 'package:json_annotation/json_annotation.dart';

part 'download_status.g.dart';

class Gid {
  const Gid(this.string);

  final String string;

  bool operator ==(Object o) => o is Gid && o.string == string;
  int get hashCode => string.hashCode;

  @override
  String toString() => 'Gid($string)';
}

class _GidConverter implements JsonConverter<Gid, String> {
  const _GidConverter();

  @override
  Gid fromJson(String json) => Gid(json);

  @override
  String toJson(Gid gid) => gid.string;
}

@JsonSerializable(createToJson: false)
@_GidConverter()
class DownloadStatus {
  DownloadStatus(
      {this.gid,
      this.status,
      this.completedLength,
      this.uploadLength,
      this.totalLength,
      this.downloadSpeed,
      this.uploadSpeed,
      this.errorCode,
      this.errorMessage,
      this.bittorrent,
      this.files});

  final Gid gid;
  @JsonKey(fromJson: int.tryParse)
  final int completedLength;
  @JsonKey(fromJson: int.tryParse)
  final int uploadLength;
  @JsonKey(fromJson: int.tryParse)
  final int totalLength;
  @JsonKey(fromJson: int.tryParse)
  final int downloadSpeed;
  @JsonKey(fromJson: int.tryParse)
  final int uploadSpeed;
  final Status status;
  final ErrorCode errorCode;
  final String errorMessage;
  final BittorrentStatus bittorrent;
  final List<DownloadFile> files;

  String get name => bittorrent?.info?.name ?? files.first.name;

  factory DownloadStatus.fromJson(Map<String, dynamic> json) =>
      _$DownloadStatusFromJson(json);
}

@JsonSerializable(createToJson: false)
class DownloadFile {
  DownloadFile({this.index, this.path, this.length})
      : name = Uri.parse(path).pathSegments.last;

  @JsonKey(fromJson: int.tryParse)
  final int index;

  final String path;

  @JsonKey(fromJson: int.tryParse)
  final int length;

  final String name;

  factory DownloadFile.fromJson(Map<String, dynamic> json) =>
      _$DownloadFileFromJson(json);
}

enum Status { active, waiting, paused, error, complete, removed }

enum ErrorCode {
  allSuccessful,
  unknownError,
  timeout,
  resourceNotFound,
  countOfResourceNotFound,
  downloadSpeedTooSlow,
  networkProblem,
  unfinishedDownloads,
  resumeNotSupported,
  notEnoughDiskSpace,
  pieceLengthWasDifferent,
  alreadyDownloading,
  downloadingShameInfoHash,
  fileAlreadyExists,
  couldNotRename,
  couldNotOpenFile,
  couldNotCreateFile,
  fileIOError,
  couldNotCreateDirectory,
  nameResolutionFailed,
  couldNotParseMetalink,
  fptCommandFailed,
  badOrUnexpectedHttpHeader,
  tooManyRedirects,
  httpAuthFailed,
  bencodeParseFailed,
  badMagnetUri,
  badOption,
  temporaryMaintenanceOrOverload,
  jsonRpcParseFailed,
  reserved,
  checksumValidationFailed,
}

@JsonSerializable(nullable: false, createToJson: false)
@_GidConverter()
class BittorrentStatus {
  final BittorrentStatusInfo info;

  BittorrentStatus({this.info});

  factory BittorrentStatus.fromJson(Map<String, dynamic> json) =>
      _$BittorrentStatusFromJson(json);
}

@JsonSerializable(nullable: false, createToJson: false)
class BittorrentStatusInfo {
  final String name;

  BittorrentStatusInfo({this.name});

  factory BittorrentStatusInfo.fromJson(Map<String, dynamic> json) =>
      _$BittorrentStatusInfoFromJson(json);
}

enum NotificationKind {
  downloadStart,
  downloadPause,
  downloadStop,
  downloadComplete,
  downloadError,
  btDownloadComplete,
}

NotificationKind stringToNotificationKind(String json) {
  const mapping = {
    'aria2.onDownloadStart': NotificationKind.downloadStart,
    'aria2.onDownloadPause': NotificationKind.downloadPause,
    'aria2.onDownloadStop': NotificationKind.downloadStop,
    'aria2.onDownloadComplete': NotificationKind.downloadComplete,
    'aria2.onDownloadError': NotificationKind.downloadError,
    'aria2.onBtDownloadComplete': NotificationKind.btDownloadComplete,
  };
  return mapping[json];
}

class Aria2Notification {
  final NotificationKind kind;
  final Gid gid;

  Aria2Notification({this.kind, this.gid});

  factory Aria2Notification.fromJson(Map<String, dynamic> json) {
    final kind = stringToNotificationKind(json['method']);
    final event = json['params'][0];
    return Aria2Notification(kind: kind, gid: Gid(event['gid']));
  }
}
