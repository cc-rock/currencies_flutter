import 'package:currencies/screens/CurrencyConverter/CurrencyConverterViewState.dart';
import 'package:currencies/screens/CurrencyConverter/CurrencyConverterViewModel.dart';
import 'package:flutter/material.dart';

import '../Screen.dart';

class CurrencyConverterScreen extends Screen<CurrencyConverterViewState> {

  final CurrencyConverterViewModel _viewModel;

  CurrencyConverterScreen(this._viewModel) : super(_viewModel);

  Widget buildWidget(BuildContext context, AsyncSnapshot<CurrencyConverterViewState> snapshot) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Currency Converter'),
        ),
        body: _buildBody(snapshot)
    );
  }

  Widget _buildBody(AsyncSnapshot<CurrencyConverterViewState> snapshot) {
    if (snapshot.hasError) {
      return _buildBodyForError(snapshot.error);
    } else if (snapshot.hasData && snapshot.data.errorMessage != null) {
      return _buildBodyForError(snapshot.data.errorMessage);
    } else if (snapshot.hasData && !snapshot.data.loading) {
      return _buildBodyForState(snapshot.data);
    } else {
      return _buildBodyForLoading();
    }
  }

  Widget _buildBodyForError(Object error) {
    return Center(
      child: Text("ERROR: ${error.toString()}"),
    );
  }

  Widget _buildBodyForLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }


  Widget _buildBodyForState(CurrencyConverterViewState state) {
    return Column(
      children: <Widget>[
        Expanded(child: Container()),
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.6,
            child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(state.inputTextLabel, textAlign: TextAlign.center),
                  ),
                  Expanded(child: TextField(
                      textAlign: TextAlign.center,
                      onChanged: (text) {
                        _viewModel.onAmountTextChanged(text);
                      },
                  ))
                ]
            ),
          ),
        ),
        Expanded(child: Container()),
        FractionallySizedBox(
          widthFactor: 0.7,
          child: Container(
            decoration: BoxDecoration(border: Border.all(width: 1.0)),
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
                thickness: 1.0,
                height: 1.0,
              ),
              itemCount: state.rows.length,
              itemBuilder: (context, index) {
                var row = state.rows[index];
                return Row(
                    children: [
                      Expanded(
                          child: Text(
                              row.currencyLabel, textAlign: TextAlign.center)
                      ),
                      SizedBox(
                        height: 24,
                        child: VerticalDivider(
                          color: Colors.black,
                          thickness: 1.0,
                        ),
                      ),
                      Expanded(
                          child: Text(row.amount, textAlign: TextAlign.center)
                      ),
                    ]
                );
              },
            ),
          ),
        ),
        Expanded(child: Container()),
        RaisedButton(
            child: Text("Compare")
        )
      ],
    );
  }

}