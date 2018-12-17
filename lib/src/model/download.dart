import 'package:json_annotation/json_annotation.dart';

part 'download.g.dart';

class Gid {
  const Gid(this.string);

  final String string;

  bool operator ==(o) => o is Gid && o.string == string;
  int get hashCode => string.hashCode;
}

class _GidConverter implements JsonConverter<Gid, String> {
  const _GidConverter();

  @override
  Gid fromJson(String json) => Gid(json);

  @override
  String toJson(Gid gid) => gid.string;
}

int intFromJson(String s) => int.tryParse(s);

@JsonSerializable(nullable: false, createToJson: false)
@_GidConverter()
class DownloadStatus {
  final Gid gid;

  @JsonKey(fromJson: intFromJson)
  final int completedLength;

  DownloadStatus({this.gid, this.completedLength});

  factory DownloadStatus.fromJson(Map<String, dynamic> json) =>
      _$DownloadStatusFromJson(json);
}
