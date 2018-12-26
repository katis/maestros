import 'package:flutter/widgets.dart';
import 'package:maestros/src/view_model/download_store.dart';

class Store extends InheritedWidget {
  Store(this._store, Widget child) : super(child: child);

  final DownloadStore _store;

  static DownloadStore of(BuildContext context) {
    final store = context.inheritFromWidgetOfExactType(Store) as Store;
    return store._store;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    if (oldWidget is Store) {
      return _store != oldWidget._store;
    }
    return true;
  }
}
