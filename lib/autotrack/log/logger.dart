import 'package:flutter/widgets.dart';

typedef RangersApplogLoggerHandler = void Function(RangersApplogLoggerLevel level, String message);

class RangersApplogLogger {
  static RangersApplogLogger _instance = RangersApplogLogger();
  static RangersApplogLogger getInstance() => _instance;

  List<_LoggerData> _data = [];
  RangersApplogLoggerHandler? _handler;
  bool _isPrinting = false;
  bool get hasHandler => _handler != null;

  void info(String message) {
    _print(RangersApplogLoggerLevel.Info, message);
  }

  void debug(String message) {
    _print(RangersApplogLoggerLevel.Debug, message);
  }

  void error(Object e) {
    String message = Error.safeToString(e);
    if (e is FlutterError) {
      message = e.message;
    } else if (e is Error) {
      message = e.stackTrace.toString();
    }
    _print(RangersApplogLoggerLevel.Error, message);
  }
  
  void setHandler(RangersApplogLoggerHandler handler) {
    _handler = handler;
  }

  void _print(RangersApplogLoggerLevel level, String message) {
    if (_handler == null) {
      return;
    }

    _data.add(_LoggerData(level, message));
    if (_isPrinting) {
      return;
    }

    _isPrinting = true;
    Future.delayed(Duration(milliseconds: 300)).then((_) {
      List<_LoggerData> data = _data;
      _data = [];
      if (_handler != null) {
        data.forEach((log) => _handler!(log.level, log.message));
      }
      _isPrinting = false;
    });
  }
}

enum RangersApplogLoggerLevel {
  Info,
  Debug,
  Error,
}

class _LoggerData {
  const _LoggerData(this.level, this.message);
  final RangersApplogLoggerLevel level;
  final String message;
}
