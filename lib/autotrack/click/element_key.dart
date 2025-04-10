import 'package:flutter/widgets.dart';

class RangersApplogElementKey extends Key {
  RangersApplogElementKey(this.name, {
    this.ignore = false
  }) : super.empty();

  final String name;
  final bool ignore;

  @override
  String toString() {
    return name;
  }
}