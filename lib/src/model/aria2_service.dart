import 'package:built_collection/built_collection.dart';
import 'package:maestros/src/model/aria2_peer.dart';
import 'package:maestros/src/model/download_status.dart';
import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;
import 'package:rxdart/rxdart.dart';

const _updateFieldNames = [
  'gid',
  'status',
  'uploadLength',
  'completedLength',
  'errorCode',
  'errorMessage',
  'downloadSpeed',
  'uploadSpeed',
];

Gid _notificationGid(json_rpc.Parameters params) => Gid(params[0].asMap['gid']);

class Aria2Service {
  Aria2Service(this._peer);

  final Aria2Peer _peer;

  void onAdded(added(Gid gid)) {
    _peer.registerMethod('aria2.onDownloadStart', (json_rpc.Parameters params) {
      final gid = _notificationGid(params);
      added(gid);
    });
  }

  ValueObservable<ConnectionStatus> get connectionStatus =>
      _peer.connectionStatus;

  Future listen() => _peer.listen();

  Stream<BuiltList<DownloadStatus>> subscribeActive(Duration interval) {
    return Stream.periodic(interval)
        .where(
            (_) => _peer.connectionStatus.value == ConnectionStatus.connected)
        .asyncMap((_) => tellActive());
  }

  Future<DownloadStatus> tellStatus(Gid gid) async {
    final response = await _peer.sendRequest('aria2.tellStatus', [gid.string]);
    return DownloadStatus.fromJson(response);
  }

  Future<BuiltList<DownloadStatus>> tellStatuses(Iterable<Gid> gids) async {
    List<Future<dynamic>> futures;
    _peer.withBatch(() {
      futures = gids
          .map((gid) => _peer.sendRequest('aria2.tellStatus', [gid.string]))
          .toList();
    });
    final results = await Future.wait(futures);
    return BuiltList(results.map((result) => DownloadStatus.fromJson(result)));
  }

  Future<BuiltList<DownloadStatus>> tellActive([List<String> keys]) async {
    List<dynamic> response = await _peer.sendRequest(
        'aria2.tellActive', keys == null ? const [] : [keys]);
    return BuiltList<DownloadStatus>(
        response.map((json) => DownloadStatus.fromJson(json)));
  }

  Future<BuiltList<DownloadStatus>> tellActiveUpdates() async {
    List<dynamic> response =
        await _peer.sendRequest('aria2.tellActive', [_updateFieldNames]);
    return BuiltList<DownloadStatus>(
        response.map((json) => DownloadStatus.fromJson(json)));
  }

  Future close() => _peer.close();
}

Iterable<A> removeNulls<A>(Iterable<A> list) =>
    list == null ? [] : list.where((item) => item != null);
