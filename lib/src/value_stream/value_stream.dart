import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

ValueObservable<B> mapValue<A, B>(
        ValueObservable<A> observable, B Function(A) mapper) =>
    observable.map(mapper).shareValue(seedValue: mapper(observable.value));

ValueObservable<C> combine2<A, B, C>(ValueObservable<A> left,
        ValueObservable<B> right, C Function(A, B) combiner) =>
    left
        .withLatestFrom(right, combiner)
        .shareValue(seedValue: combiner(left.value, right.value));

class ValueObservableBuilder<A> extends StreamBuilder<A> {
  ValueObservableBuilder(
      {Key key,
      @required ValueObservable<A> observable,
      @required AsyncWidgetBuilder<A> builder})
      : super(
            key: key,
            initialData: observable.value,
            stream: observable,
            builder: builder);
}
