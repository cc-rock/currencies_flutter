abstract class Currency {
  String get name;
}

abstract class Amount {
  Currency get currency;
  double get value;
}

abstract class ConversionRate {
  Currency get from;
  Currency get to;
  double get rate;
  DateTime get date;
}