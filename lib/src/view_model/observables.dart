import 'dart:collection';
import 'dart:math';

import 'package:collection/collection.dart';
// ignore: implementation_imports
import 'package:mobx/src/core/base_types.dart';

class ObservableList<T> with IterableMixin<T> implements List<T> {
  ObservableList.wrap(this._list, [Atom atom]) {
    this.atom = atom ?? Atom('ObservableList<$T>(${_idCounter++})');
  }

  factory ObservableList() => ObservableList.wrap(List());

  static int _idCounter = 0;

  Atom atom;

  final List<T> _list;

  @override
  void add(T value) {
    _list.add(value);
    atom.reportChanged();
  }

  @override
  void addAll(Iterable<T> iterable) {
    _list.addAll(iterable);
    atom.reportChanged();
  }

  @override
  void setAll(int index, Iterable<T> iterable) {
    _list.setAll(index, iterable);
    atom.reportChanged();
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _list.setRange(start, end, iterable, skipCount);
    atom.reportChanged();
  }

  @override
  void sort([int Function(T a, T b) compare]) {
    _list.sort(compare);
    atom.reportChanged();
  }

  @override
  T operator [](int index) {
    atom.reportObserved();
    return _list[index];
  }

  @override
  void operator []=(int index, T value) {
    _list[index] = value;
    atom.reportChanged();
  }

  List<T> operator +(List<T> other) {
    atom.reportObserved();
    return ObservableList<T>.wrap(_list + other);
  }

  @override
  Iterator<T> get iterator => _ListIterator<T>(this);

  @override
  Map<int, T> asMap() {
    // TODO: implement asMap
    return _list.asMap();
  }

  @override
  void clear() {
    if (_list.length > 0) {
      _list.clear();
      atom.reportChanged();
    }
  }

  @override
  void fillRange(int start, int end, [T fillValue]) {
    if (end - start == 1) {
      _list.fillRange(start, end);
      atom.reportChanged();
    }
  }

  @override
  void set first(T value) {
    _list.first = value;
    atom.reportChanged();
  }

  @override
  Iterable<T> getRange(int start, int end) {}

  @override
  int indexOf(T element, [int start = 0]) {
    // TODO: implement indexOf
    return null;
  }

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) {
    // TODO: implement indexWhere
    return null;
  }

  @override
  void insert(int index, T element) {
    _list.insert(index, element);
    atom.reportChanged();
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _list.insertAll(index, iterable);
    atom.reportChanged();
  }

  @override
  set last(T value) {
    _list.last = value;
    atom.reportChanged();
  }

  @override
  int lastIndexOf(T element, [int start]) {
    atom.reportObserved();
    return _list.lastIndexOf(element, start);
  }

  @override
  int lastIndexWhere(bool Function(T element) test, [int start]) {
    atom.reportObserved();
    return _list.lastIndexWhere(test, start);
  }

  @override
  set length(int newLength) {
    if (_list.length != newLength) {
      _list.length = newLength;
      atom.reportChanged();
    }
  }

  @override
  bool remove(Object value) {
    final removed = remove(value);
    if (removed) {
      atom.reportChanged();
    } else {
      atom.reportObserved();
    }
    return removed;
  }

  @override
  T removeAt(int index) {
    final value = _list.removeAt(index);
    atom.reportChanged();
    return value;
  }

  @override
  T removeLast() {
    final oldLen = _list.length;
    final value = _list.removeLast();
    if (oldLen != _list.length) {
      atom.reportChanged();
    }
    return value;
  }

  @override
  void removeRange(int start, int end) {
    if (end - start > 0) {
      _list.removeRange(start, end);
      atom.reportChanged();
    }
  }

  @override
  void removeWhere(bool Function(T element) test) {
    final oldLength = _list.length;
    _list.removeWhere(test);
    if (_list.length != oldLength) {
      atom.reportChanged();
    } else {
      atom.reportObserved();
    }
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacement) {
    // TODO: implement replaceRange
  }

  @override
  void retainWhere(bool Function(T element) test) {
    final oldLength = _list.length;
    _list.retainWhere(test);
    if (oldLength != _list.length) {
      atom.reportChanged();
    } else {
      atom.reportObserved();
    }
  }

  @override
  Iterable<T> get reversed => _list.reversed;

  @override
  void shuffle([Random random]) {
    _list.shuffle();
    atom.reportChanged();
  }

  @override
  List<T> sublist(int start, [int end]) {
    final newList = _list.sublist(start, end);
    return ObservableList.wrap(newList, atom);
  }
}

class _ListIterator<T> implements Iterator<T> {
  _ListIterator(this._list) : _length = _list.length;

  int _position = -1;

  final int _length;

  final List<T> _list;

  @override
  T get current => _position < _length ? _list[_position] : null;

  @override
  bool moveNext() {
    _position++;
    return _position < _length;
  }

  List<T> get asUnobservable => List.unmodifiable(_list);
}
