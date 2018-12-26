import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:maestros/src/model/download_status.dart';
import 'package:maestros/src/value_stream/value_stream.dart';
import 'package:maestros/src/view/store.dart';
import 'package:maestros/src/view_model/download.dart';

class DownloadList extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      ValueObservableBuilder<BuiltMap<Gid, Download>>(
        observable: Store.of(context).downloads,
        builder: _buildList,
      );

  Widget _buildList(
      BuildContext context, AsyncSnapshot<BuiltMap<Gid, Download>> snapshot) {
    final downloads = snapshot.data.values.toList();
    return ListView.builder(
      padding: EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8.0),
      itemCount: downloads.length,
      itemBuilder: (context, index) =>
          DownloadListItem(download: downloads[index]),
    );
  }
}

class DownloadListItem extends StatelessWidget {
  final Download download;

  const DownloadListItem({Key key, this.download}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: <Widget>[
          ItemCheckbox(download: download),
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ProgressBar(download: download),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: Text(download.name,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCheckbox extends StatelessWidget {
  final Download download;

  const ItemCheckbox({Key key, this.download}) : super(key: key);

  @override
  Widget build(BuildContext context) => ValueObservableBuilder(
      observable: download.selected, builder: _buildCheckbox);

  Widget _buildCheckbox(BuildContext context, AsyncSnapshot<bool> snapshot) {
    return Checkbox(onChanged: _onChanged, value: snapshot.data);
  }

  void _onChanged(bool value) {
    download.selected.add(value);
  }
}

class ProgressBar extends StatelessWidget {
  final Download download;

  const ProgressBar({Key key, @required this.download}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueObservableBuilder<Progress>(
        observable: download.progress,
        builder: (context, snapshot) {
          final progress = snapshot.data;
          return CustomPaint(
              painter: _ProgressBarPainter(
            donePct: progress.donePct,
            velocityPct: progress.velocityPct,
            backgroundColor: Colors.teal[50],
            foregroundColor: Colors.teal[300],
            velocityColor: Colors.orange[200],
          ));
        });
  }
}

class _ProgressBarPainter extends CustomPainter {
  _ProgressBarPainter(
      {@required this.donePct,
      @required this.velocityPct,
      @required this.backgroundColor,
      @required this.foregroundColor,
      @required this.velocityColor});

  final double donePct;
  final double velocityPct;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color velocityColor;
  Paint get _foreGroundPaint => Paint()..color = foregroundColor;
  Paint get _backgroundPaint => Paint()..color = backgroundColor;
  Paint get _velocityPaint => Paint()..color = velocityColor;

  static const Radius radius = const Radius.circular(5.0);

  @override
  void paint(Canvas canvas, Size size) {
    final doneBarWidth = size.width * donePct;
    final velocityBarWidth = doneBarWidth + (size.width * velocityPct * 5);

    drawBar(canvas, _backgroundPaint, size, size.width);
    drawBar(canvas, _velocityPaint, size, velocityBarWidth);
    drawBar(canvas, _foreGroundPaint, size, doneBarWidth);
  }

  void drawBar(Canvas canvas, Paint paint, Size area, double width) {
    final rect = Rect.fromLTWH(0, 0, width, area.height);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
  }

  @override
  bool shouldRepaint(_ProgressBarPainter old) =>
      donePct != old.donePct ||
      velocityPct != old.velocityPct ||
      backgroundColor != old.backgroundColor ||
      foregroundColor != old.foregroundColor ||
      velocityColor != old.velocityColor;
}
