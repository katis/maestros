import 'package:maestros/src/model/download_status.dart';
import 'package:maestros/src/value_stream/value_stream.dart';
import 'package:rxdart/rxdart.dart';

class Download {
  Download(this._initial)
      : _updates = BehaviorSubject<DownloadStatus>(seedValue: _initial);

  final DownloadStatus _initial;

  Gid get gid => _initial.gid;

  String get name => _initial.name;

  int get totalLength => _initial.totalLength;

  final BehaviorSubject<bool> selected =
      BehaviorSubject<bool>(seedValue: false);

  final BehaviorSubject<DownloadStatus> _updates;

  ValueObservable<DownloadStatus> get updates => _updates;

  ValueObservable<Status> get status => _mapUpdates((update) => update.status);

  ValueObservable<Status> get newStatus =>
      _mapUpdates((update) => update.status).shareValue();

  ValueObservable<int> get completedLength =>
      _mapUpdates((update) => update.completedLength);

  ValueObservable<int> get uploadLength =>
      _mapUpdates((update) => update.uploadLength);

  ValueObservable<int> get downloadSpeed =>
      _mapUpdates((update) => update.downloadSpeed);

  ValueObservable<Progress> get progress => _mapUpdates((update) {
        final donePct =
            update.completedLength.toDouble() / totalLength.toDouble();
        final velocityPct =
            update.downloadSpeed.toDouble() / totalLength.toDouble();
        return Progress(donePct, velocityPct);
      });

  ValueObservable<int> get uploadSpeed =>
      _mapUpdates((update) => update.uploadSpeed);

  ValueObservable<T> _mapUpdates<T>(T Function(DownloadStatus) mapper) =>
      mapValue(_updates, mapper);

  ValueObservable<DownloadError> get error => mapValue(
      _updates,
      (DownloadStatus update) =>
          DownloadError(update.errorCode, update.errorMessage));

  void update(DownloadStatus status) => _updates.add(status);

  Future close() {
    return Future.wait([_updates.close(), selected.close()]);
  }

  @override
  String toString() => 'Download(gid: $gid, name: $name)';
}

class DownloadError {
  final ErrorCode code;
  final String message;

  DownloadError(this.code, this.message);
}

class Progress {
  final double donePct;
  final double velocityPct;

  Progress(this.donePct, this.velocityPct);
}
