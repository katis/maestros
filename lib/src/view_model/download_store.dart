import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:maestros/src/model/aria2_peer.dart';

import 'package:maestros/src/model/aria2_service.dart';
import 'package:maestros/src/model/download_status.dart';
import 'package:maestros/src/view_model/download.dart';
import 'package:rxdart/rxdart.dart';

const _updateInterval = Duration(seconds: 5);

class DownloadStore {
  DownloadStore(this._aria2)
      : _downloadsSubject = BehaviorSubject(seedValue: BuiltMap());

  final Aria2Service _aria2;
  final BehaviorSubject<BuiltMap<Gid, Download>> _downloadsSubject;
  StreamSubscription _updateSubscription;

  ValueObservable<BuiltMap<Gid, Download>> get downloads => _downloadsSubject;

  Future init() async {
    _aria2.onAdded((gid) async {
      final status = await _aria2.tellStatus(gid);
      _addDownload(status);
    });

    _updateSubscription = _aria2
        .subscribeActive(_updateInterval)
        .listen((updates) => updates.forEach(_updateDownload));

    _aria2.listen();

    _aria2.connectionStatus
        .distinct()
        .where((c) => c == ConnectionStatus.connected)
        .asyncMap((_) => _aria2.tellActive())
        .listen(_setDownloads);
  }

  ValueObservable<bool> get anySelected {
    final selected =
        _downloadsSubject.value.values.any((dl) => dl.selected.value);
    return _downloadsSubject
        .asyncExpand((downloads) => Observable.combineLatest<bool, bool>(
            downloads.values.map((download) => download.selected),
            (selecteds) => selecteds.any((s) => s)))
        .shareValue(seedValue: selected);
  }

  void _updateDownload(DownloadStatus update) {
    _downloadsSubject.value[update.gid]?.update(update);
  }

  void _setDownloads(BuiltList<DownloadStatus> statuses) =>
      _updateDownloads((builder) {
        final downloads = _downloadsSubject.value;
        final removedGids = downloads.values
            .map((dl) => dl.gid)
            .where((gid) => !statuses.any((s) => s.gid == gid))
            .toSet();

        for (final status in statuses) {
          final download = downloads[status.gid];
          if (download == null) {
            builder[status.gid] = Download(status);
          } else {
            download.update(status);
          }
        }
        for (final gid in removedGids) {
          final removed = downloads[gid];
          removed.close();
          builder.remove(gid);
        }
      });

  void _addDownload(DownloadStatus status) =>
      _updateDownloads((builder) => builder[status.gid] = Download(status));

  void _removeDownload(Gid gid) =>
      _updateDownloads((builder) => builder.remove(gid));

  void _updateDownloads(Function(MapBuilder<Gid, Download>) builder) {
    final downloads = _downloadsSubject.value.rebuild(builder);
    _downloadsSubject.add(downloads);
  }

  Future close() => Future.wait([
        _updateSubscription.cancel(),
        _downloadsSubject.close(),
      ]);
}
