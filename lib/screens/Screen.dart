import 'package:flutter/cupertino.dart';
import 'dart:developer' as developer;

import 'ViewModel.dart';

abstract class Screen<VS> {

  StreamBuilder<VS> get widget {
    developer.log("StreamBuilder built");
    return StreamBuilder(
        initialData: _viewModel.currentState,
        stream: _viewModel.stream,
        builder: buildWidget
    );
  }

  final ViewModel<VS> _viewModel;

  Screen(this._viewModel);

  Widget buildWidget(BuildContext context, AsyncSnapshot<VS> snapshot);

}