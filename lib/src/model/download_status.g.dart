// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadStatus _$DownloadStatusFromJson(Map<String, dynamic> json) {
  return DownloadStatus(
      gid: json['gid'] == null
          ? null
          : const _GidConverter().fromJson(json['gid'] as String),
      status: _$enumDecodeNullable(_$StatusEnumMap, json['status']),
      completedLength: json['completedLength'] == null
          ? null
          : int.tryParse(json['completedLength'] as String),
      uploadLength: json['uploadLength'] == null
          ? null
          : int.tryParse(json['uploadLength'] as String),
      totalLength: json['totalLength'] == null
          ? null
          : int.tryParse(json['totalLength'] as String),
      downloadSpeed: json['downloadSpeed'] == null
          ? null
          : int.tryParse(json['downloadSpeed'] as String),
      uploadSpeed: json['uploadSpeed'] == null
          ? null
          : int.tryParse(json['uploadSpeed'] as String),
      errorCode: _$enumDecodeNullable(_$ErrorCodeEnumMap, json['errorCode']),
      errorMessage: json['errorMessage'] as String,
      bittorrent: json['bittorrent'] == null
          ? null
          : BittorrentStatus.fromJson(
              json['bittorrent'] as Map<String, dynamic>),
      files: (json['files'] as List)
          ?.map((e) => e == null
              ? null
              : DownloadFile.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$StatusEnumMap = <Status, dynamic>{
  Status.active: 'active',
  Status.waiting: 'waiting',
  Status.paused: 'paused',
  Status.error: 'error',
  Status.complete: 'complete',
  Status.removed: 'removed'
};

const _$ErrorCodeEnumMap = <ErrorCode, dynamic>{
  ErrorCode.allSuccessful: 'allSuccessful',
  ErrorCode.unknownError: 'unknownError',
  ErrorCode.timeout: 'timeout',
  ErrorCode.resourceNotFound: 'resourceNotFound',
  ErrorCode.countOfResourceNotFound: 'countOfResourceNotFound',
  ErrorCode.downloadSpeedTooSlow: 'downloadSpeedTooSlow',
  ErrorCode.networkProblem: 'networkProblem',
  ErrorCode.unfinishedDownloads: 'unfinishedDownloads',
  ErrorCode.resumeNotSupported: 'resumeNotSupported',
  ErrorCode.notEnoughDiskSpace: 'notEnoughDiskSpace',
  ErrorCode.pieceLengthWasDifferent: 'pieceLengthWasDifferent',
  ErrorCode.alreadyDownloading: 'alreadyDownloading',
  ErrorCode.downloadingShameInfoHash: 'downloadingShameInfoHash',
  ErrorCode.fileAlreadyExists: 'fileAlreadyExists',
  ErrorCode.couldNotRename: 'couldNotRename',
  ErrorCode.couldNotOpenFile: 'couldNotOpenFile',
  ErrorCode.couldNotCreateFile: 'couldNotCreateFile',
  ErrorCode.fileIOError: 'fileIOError',
  ErrorCode.couldNotCreateDirectory: 'couldNotCreateDirectory',
  ErrorCode.nameResolutionFailed: 'nameResolutionFailed',
  ErrorCode.couldNotParseMetalink: 'couldNotParseMetalink',
  ErrorCode.fptCommandFailed: 'fptCommandFailed',
  ErrorCode.badOrUnexpectedHttpHeader: 'badOrUnexpectedHttpHeader',
  ErrorCode.tooManyRedirects: 'tooManyRedirects',
  ErrorCode.httpAuthFailed: 'httpAuthFailed',
  ErrorCode.bencodeParseFailed: 'bencodeParseFailed',
  ErrorCode.badMagnetUri: 'badMagnetUri',
  ErrorCode.badOption: 'badOption',
  ErrorCode.temporaryMaintenanceOrOverload: 'temporaryMaintenanceOrOverload',
  ErrorCode.jsonRpcParseFailed: 'jsonRpcParseFailed',
  ErrorCode.reserved: 'reserved',
  ErrorCode.checksumValidationFailed: 'checksumValidationFailed'
};

DownloadFile _$DownloadFileFromJson(Map<String, dynamic> json) {
  return DownloadFile(
      index:
          json['index'] == null ? null : int.tryParse(json['index'] as String),
      path: json['path'] as String,
      length: json['length'] == null
          ? null
          : int.tryParse(json['length'] as String));
}

BittorrentStatus _$BittorrentStatusFromJson(Map<String, dynamic> json) {
  return BittorrentStatus(
      info:
          BittorrentStatusInfo.fromJson(json['info'] as Map<String, dynamic>));
}

BittorrentStatusInfo _$BittorrentStatusInfoFromJson(Map<String, dynamic> json) {
  return BittorrentStatusInfo(name: json['name'] as String);
}
