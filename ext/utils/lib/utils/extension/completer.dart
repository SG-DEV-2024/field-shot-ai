import 'dart:async';

extension CompleterExtension<T> on Completer {
  void completeIf([FutureOr<T>? value]) {
    if (!isCompleted) complete(value);
  }
}
