import 'dart:async';

import 'package:currencies/utils/cancellables.dart';
import 'package:flutter/foundation.dart';

abstract class ViewModel<VS> {

  final StreamController<VS> _streamController;

  Stream<VS> get stream => _streamController.stream;

  VS currentState;
  bool _pendingState = false;

  @protected
  CompositeCancellableOperation compCanc = CompositeCancellableOperation();

  ViewModel(StreamController<VS> Function() streamControllerFactory): _streamController = streamControllerFactory() {
    _streamController.onListen = () {
      if (_pendingState) {
        pushState(currentState);
      }
    };
    _streamController.onResume = () {
      if (_pendingState) {
        pushState(currentState);
      }
    };
  }

  @protected
  void pushState(VS newState) {
    currentState = newState;
    if (_streamController.hasListener && !_streamController.isClosed && !_streamController.isPaused) {
      _streamController.add(newState);
      _pendingState = false;
    } else {
      _pendingState = true;
    }
  }

}