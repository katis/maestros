import 'package:maestros/src/model/download_status.dart';
import 'package:maestros/src/value_stream/value_stream.dart';

class Download {
  Download(this._initial)
      : _updates = ValueSubject<DownloadUpdate>(seedValue: _initial);

  final DownloadStatus _initial;

  Gid get gid => _initial.gid;

  String get name => _initial.name;

  int get totalLength => _initial.totalLength;

  final ValueSubject<DownloadUpdate> _updates;

  ValueStream<DownloadUpdate> get updates => _updates;

  ValueStream<Status> get status => _updates.map((update) => update.status);

  ValueStream<int> get completedLength =>
      _updates.map((update) => update.completedLength);

  ValueStream<int> get uploadLength =>
      _updates.map((update) => update.uploadLength);

  ValueStream<DownloadError> get error => _updates
      .map((update) => DownloadError(update.errorCode, update.errorMessage));

  void update(DownloadStatus status) => _updates.add(status);

  Future close() => _updates.close();
}

class DownloadError {
  final ErrorCode code;
  final String message;

  DownloadError(this.code, this.message);
}
