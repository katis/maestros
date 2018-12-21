import 'package:rxdart/rxdart.dart';

mixin ValueObservableMixin<A> on ValueObservable<A> {
  ValueConnectableStream<B> mapValue<B>(B Function(A) mapper) =>
      ValueConnectableStream(map(mapper), seedValue: mapper(value));

  ValueStream<C> combineLatest<B, C>(
          ValueObservable<B> other, C Function(A, B) combine) =>
      ValueConnectableStream(withLatestFrom(other, combine),
          seedValue: combine(value, other.value));
}

abstract class ValueStream<T>
    implements ValueObservable<T>, ValueObservableMixin<T> {}

class ValueSubject<T> = BehaviorSubject<T>
    with ValueStream<T>, ValueObservableMixin<T>;

class ValueConnectableStream<T> = ValueConnectableObservable<T>
    with ValueStream<T>, ValueObservableMixin<T>;
