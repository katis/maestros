// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadStatus _$DownloadStatusFromJson(Map<String, dynamic> json) {
  return DownloadStatus(
      gid: const _GidConverter().fromJson(json['gid'] as String),
      completedLength: intFromJson(json['completedLength'] as String));
}
