import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:json_rpc_2/json_rpc_2.dart' as json_rpc;
import 'package:rxdart/rxdart.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/io.dart';

class Aria2Peer {
  Aria2Peer(Uri url, String secret) : _secretField = 'token:$secret' {
    _channel = ReconnectingStreamChannel(() async {
      // ignore: close_sinks
      final ws = await WebSocket.connect(url.toString());
      return IOWebSocketChannel(ws).cast<String>();
    });
    _peer = json_rpc.Peer(_channel);
  }

  final String _secretField;
  ReconnectingStreamChannel _channel;
  json_rpc.Peer _peer;

  ValueObservable<ConnectionStatus> get connectionStatus =>
      _channel.connectionStatus;

  Future listen() {
    return Future.wait([
      _channel.connect(),
      _peer.listen(),
    ]);
  }

  withBatch(callback()) => _peer.withBatch(callback);

  Future sendRequest(String method, [List params = const []]) async {
    final args = <dynamic>[_secretField]..addAll(params);
    return await _peer.sendRequest(method, removeNulls(args).toList());
  }

  void registerMethod(String method, Function callback) =>
      _peer.registerMethod(method, callback);

  Future close() => _peer.close();
}

Iterable<A> removeNulls<A>(Iterable<A> list) =>
    list.where((item) => item != null);

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
}

typedef Future<StreamChannel<String>> Connect();

class ReconnectingStreamChannel
    with StreamChannelMixin<String>
    implements StreamChannel<String> {
  final BehaviorSubject<ConnectionStatus> _connected =
      BehaviorSubject(seedValue: ConnectionStatus.disconnected);
  final StreamController<String> _responses =
      StreamController<String>.broadcast();
  final StreamController<String> _requests =
      StreamController<String>.broadcast();
  final Connect _connect;

  ReconnectingStreamChannel(this._connect);

  Future connect() async {
    int delay = 0;
    while (true) {
      try {
        await Future.delayed(Duration(seconds: delay));
        _connected.add(ConnectionStatus.connecting);
        print("CONNECTING");
        final socket = await _connect();
        print("CONNECTED");
        _connected.add(ConnectionStatus.connected);
        socket.sink.addStream(_requests.stream);
        await for (final msg in socket.stream) {
          delay = 0;
          _responses.add(msg);
        }
      } catch (ex, stack) {
        print("DISCONNECTED $ex, $stack");
        _connected.add(ConnectionStatus.disconnected);
        delay = min(delay + 1, 5);
      }
    }
  }

  ValueObservable<ConnectionStatus> get connectionStatus => _connected.stream;

  @override
  StreamSink<String> get sink => _requests;

  @override
  Stream<String> get stream => _responses.stream;

  Future close() => Future.wait([
        _responses.close(),
        _requests.close(),
      ]);
}
