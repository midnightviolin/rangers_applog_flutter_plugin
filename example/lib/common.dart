import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:rangers_applog_flutter_plugin/rangers_applog_flutter_plugin.dart';

toast(String msg) {
  if (Platform.operatingSystem == 'ohos') {
    RangersApplogFlutterPlugin.toast(msg);
  } else {
    Fluttertoast.showToast(msg: msg);
  }
}
