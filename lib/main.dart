import 'package:flutter/material.dart';
import 'package:maestros/src/model/aria2_peer.dart';
import 'package:maestros/src/model/aria2_service.dart';
import 'package:maestros/src/value_stream/value_stream.dart';
import 'package:maestros/src/view/download_list.dart';
import 'package:maestros/src/view/store.dart';
import 'package:maestros/src/view_model/download_store.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

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
    final theme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.deepPurple[600],
      accentColor: Colors.tealAccent[700],
      backgroundColor: Colors.deepPurple,
      canvasColor: const Color(0xFF1F1F1F),
      unselectedWidgetColor: Colors.blue,

      // Define the default Font Family
      fontFamily: 'Montserrat',

      textTheme: TextTheme(
        headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    );
    return Store(
        store,
        MaterialApp(
          title: 'Flutter Demo',
          theme: theme,
          // theme: ThemeData(
          //   primarySwatch: Colors.deepPurple,
          // ),
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
          final selected = snap.data ?? false;
          return Stack(children: [
            Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: DownloadList(),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endDocked,
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                backgroundColor: Colors.deepPurple,
                onPressed: () {},
              ),
              bottomNavigationBar: DownloadsBottomBar(show: selected),
            ),
          ]);
        });
  }
}

class DownloadsBottomBar extends StatelessWidget {
  final bool show;

  const DownloadsBottomBar({Key key, @required this.show}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.tealAccent[100];
    final backgroundColor = Colors.deepPurple;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      transform:
          Matrix4.translation(show ? Vector3.zero() : Vector3(0, 100, 0)),
      child: BottomAppBar(
        color: backgroundColor,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 100),
          child: Row(children: <Widget>[
            BottomBarButton(
              color: color,
              backgroundColor: backgroundColor,
              icon: Icons.delete,
              label: 'Delete',
              onPressed: () {},
            ),
            BottomBarButton(
              color: color,
              backgroundColor: backgroundColor,
              icon: Icons.pause,
              label: 'Pause',
              onPressed: () {},
            ),
          ]),
        ),
      ),
    );
  }
}

class BottomBarButton extends StatelessWidget {
  const BottomBarButton({
    Key key,
    @required this.icon,
    @required this.label,
    @required this.onPressed,
    @required this.color,
    @required this.backgroundColor,
  }) : super(key: key);

  final Color color;
  final Color backgroundColor;
  final IconData icon;
  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onPressed,
        splashColor: Colors.teal,
        highlightColor: Colors.teal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: color,
                size: 36,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(label, style: TextStyle(color: color)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
