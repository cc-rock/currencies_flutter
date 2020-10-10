import 'package:async/async.dart';

class CompositeCancellableOperation {

  List<CancelableOperation> _operations = List();

  Future<T> add<T>(Future<T> future) {
    CancelableOperation<T> operation = CancelableOperation.fromFuture(
      future,
      onCancel: () => throw CancellationException()
    );
    _operations.add(operation);
    return operation.valueOrCancellation();
  }

  void cancel() {
    _operations.forEach((op) { op.cancel(); });
    _operations.clear();
  }

}

class CancellationException implements Exception {}