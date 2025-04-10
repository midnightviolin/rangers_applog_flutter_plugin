import 'package:flutter/widgets.dart';

class RangersApplogAutoTrackNavigatorKey {
  static RangersApplogAutoTrackNavigatorKey? _instance;
  RangersApplogAutoTrackNavigatorKey._();

  static RangersApplogAutoTrackNavigatorKey _getInstance() {
    if (_instance == null) {
      _instance = RangersApplogAutoTrackNavigatorKey._();
    }
    return _instance!;
  }

  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> navigatorKeyWrap(GlobalKey<NavigatorState>? navigatorKey) {
    if (navigatorKey != null) {
      _getInstance()._navigatorKey = navigatorKey;
    }
    return _getInstance()._navigatorKey;
  }

  static GlobalKey<NavigatorState> get navigatorKey => _getInstance()._navigatorKey;
}
