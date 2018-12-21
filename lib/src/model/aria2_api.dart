import 'package:maestros/src/model/download_status.dart';
import "package:json_rpc_2/json_rpc_2.dart" as json_rpc;

const _updateFieldNames = [
  'gid',
  'status',
  'uploadLength',
  'completedLength',
  'errorCode',
  'errorMessage',
];

class Aria2Api {
  Aria2Api(this._client, String secret) : _secret = 'token:$secret';

  final String _secret;
  final json_rpc.Client _client;

  Future<List<DownloadStatus>> tellActive([List<String> keys]) async {
    List<dynamic> response = await _sendRequest('aria2.tellActive', keys);
    return response.map((json) => DownloadStatus.fromJson(json)).toList();
  }

  Future<List<DownloadUpdate>> tellActiveUpdates() async {
    List<dynamic> response =
        await _sendRequest('aria2.tellActive', _updateFieldNames);
    return response.map((json) => DownloadUpdate.fromJson(json)).toList();
  }

  Future<dynamic> _sendRequest(String method, [List parameters]) async {
    return await _client.sendRequest(
        method, [_secret as dynamic]..addAll(removeNulls(parameters)));
  }
}

Iterable<A> removeNulls<A>(Iterable<A> list) =>
    list.where((item) => item != null);
