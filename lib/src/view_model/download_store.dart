import 'dart:async';
import 'package:built_collection/built_collection.dart';

import 'package:maestros/src/model/aria2_api.dart';
import 'package:maestros/src/model/download_status.dart';
import 'package:maestros/src/value_stream/value_stream.dart';
import 'package:maestros/src/view_model/download.dart';

const _updateInterval = Duration(seconds: 5);

class DownloadStore {
  DownloadStore(this._api)
      : _downloadsSubject = ValueSubject(seedValue: BuiltMap()) {
    _updateSubscription = Stream.periodic(_updateInterval)
        .asyncMap((_) => _api.tellActiveUpdates())
        .listen((updates) => updates.forEach(_updateDownload));
  }

  final Aria2Api _api;

  StreamSubscription _updateSubscription;

  final ValueSubject<BuiltMap<Gid, Download>> _downloadsSubject;

  ValueStream<BuiltMap<Gid, Download>> get downloads => _downloadsSubject;

  void _updateDownload(DownloadUpdate update) {
    final download = _downloadsSubject.value[update.gid];
    download?.update(update);
  }

  void _addDownload(DownloadStatus status) {
    final download = Download(status);
    _updateDownloads((builder) => builder[download.gid] = download);
  }

  void _removeDownload(Gid gid) {
    _updateDownloads((builder) => builder.remove(gid));
  }

  void _updateDownloads(dynamic Function(MapBuilder<Gid, Download>) builder) {
    final downloads = _downloadsSubject.value.rebuild(builder);
    _downloadsSubject.add(downloads);
  }

  Future close() => Future.wait([
        _updateSubscription.cancel(),
        _downloadsSubject.close(),
      ]);
}
