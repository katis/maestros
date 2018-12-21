import 'package:flutter/material.dart';
import 'package:maestros/src/view_model/download.dart';

class DownloadList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(""),
    );
  }
}

class DownloadListItem extends StatelessWidget {
  final Download download;

  const DownloadListItem({Key key, this.download}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(download.name);
  }
}
