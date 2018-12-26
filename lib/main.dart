import 'package:flutter/material.dart';
import 'package:maestros/src/model/aria2_peer.dart';
import 'package:maestros/src/model/aria2_service.dart';
import 'package:maestros/src/value_stream/value_stream.dart';
import 'package:maestros/src/view/download_list.dart';
import 'package:maestros/src/view/store.dart';
import 'package:maestros/src/view_model/download_store.dart';

void main() {
  runApp(MaestrosApp());
}

class MaestrosApp extends StatefulWidget {
  @override
  MaestrosAppState createState() => new MaestrosAppState();
}

class MaestrosAppState extends State<MaestrosApp> {
  DownloadStore store;

  @override
  void initState() {
    super.initState();
    final peer = Aria2Peer(Uri.parse('ws://10.0.2.2:6800/jsonrpc'), 'passu');
    final aria2 = Aria2Service(peer);
    store = DownloadStore(aria2);
    store.init().catchError((error, stack) {
      print('STORE ERROR: $error, $stack');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Store(
        store,
        MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: DownloadsPage(title: 'Maestros'),
        ));
  }
}

class DownloadsPage extends StatelessWidget {
  DownloadsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final store = Store.of(context);
    return ValueObservableBuilder<bool>(
        observable: store.anySelected,
        builder: (context, snap) {
          final selected = snap.data;
          return Stack(children: [
            Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: DownloadList(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Padding(
                padding: EdgeInsets.all(selected ? 0.0 : 8.0),
                child: FloatingActionButton.extended(
                  icon: const Icon(Icons.add),
                  label: const Text('Add download'),
                  onPressed: () {},
                ),
              ),
              bottomNavigationBar: snap.data ? DownloadsBottomBar() : null,
            ),
            Positioned(
              bottom: 10.0,
              left: MediaQuery.of(context).size.width * 0.5,
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {},
              ),
            )
          ]);
        });
  }
}

class DownloadsBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 4.0,
      child: Row(children: <Widget>[
        IconButton(icon: Icon(Icons.delete), onPressed: () => {})
      ]),
    );
  }
}
