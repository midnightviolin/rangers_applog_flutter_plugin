import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rangers_applog_flutter_plugin/autotrack.dart';
import 'package:rangers_applog_flutter_plugin/rangers_applog_flutter_plugin.dart';

import 'common.dart';

const String RangersAppLogTestAppID = '159486';
const String RangersAppLogTestChannel = 'local_test';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _sdkVersion = 'Unknown';
  String _did = 'Unknown';
  String _listen_text = 'Unknown';
  String _listen_abconfig = 'Unknown';
  String _listen_vidschange = 'Unknown';
  String _device_id = 'Unknown';
  String _ab_sdk_version = 'Unknown';
  dynamic _ab_config_value;
  Map<dynamic, dynamic>? allABConfigs;

  Future<void> _initAppLog() async {
    try {
      // RangersApplogFlutterPlugin.initRangersAppLog("189693", "local_test", true, true, true, null);
      // The ABTest may not be up to date here
      _getABTestConfigValueForKey();
      RangersApplogFlutterPlugin.receiveABTestConfigStream().listen((event) {
        setState(() {
          _listen_text = "receiveABTestConfigStream";
        });
        // You can get the latest ABTest here
        _getABTestConfigValueForKey();
      });
      RangersApplogFlutterPlugin.receiveABVidsChangeStream().listen((event) {
        setState(() {
          _listen_text = "receiveABVidsChangeStream";
        });
      });
    } on Exception {}
  }

  Future<void> _getDid() async {
    String value = 'Unknown';
    try {
      value = await RangersApplogFlutterPlugin.getDeviceId() ?? value;
    } on Exception {}
    setState(() {
      _did = value;
    });
  }

  Future<void> _getDeviceID() async {
    String value = 'Unknown';
    try {
      value = await RangersApplogFlutterPlugin.getDeviceId() ?? value;
    } on Exception {}
    setState(() {
      _device_id = value;
    });
  }

  Future<void> _getAbSdkVersion() async {
    String value = 'Unknown';
    try {
      value = await RangersApplogFlutterPlugin.getAbSdkVersion() ?? value;
    } on Exception {}
    setState(() {
      _ab_sdk_version = value;
    });
  }

  Future<void> _getAllAbTestConfig() async {
    Map<dynamic, dynamic>? value;
    try {
      value = await RangersApplogFlutterPlugin.getAllAbTestConfig();
      print(value);
    } on Exception {}
    setState(() {
      allABConfigs = value;
    });
  }

  Future<void> _getABTestConfigValueForKey() async {
    dynamic value;
    try {
      final dynamic result =
      await RangersApplogFlutterPlugin.getABTestConfigValueForKey(
          'home_style', "ab_default_val");
      value = result;
    } on Exception {}
    setState(() {
      _ab_config_value = value;
    });
  }

  static int uuid = 2020;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('flutter demo'),
          actions: [
            TextButton(
              onPressed: () => {
              Navigator.pushNamed(context, '/page-settings')
            },
              child: const Text(
                '设置', style: TextStyle(fontSize: 16, color: Colors.red),),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    //设置按下时的背景颜色
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.yellow[200];
                    }
                    //默认不使用背景颜色
                    return null;
                  }),
                  minimumSize: MaterialStateProperty.all(Size(100, 100))),
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
                key: RangersApplogElementKey('start'),
                title: Text("SDK start"),
                onTap: () {
                  RangersApplogFlutterPlugin.start();
                }),
            ListTile(
                key: RangersApplogElementKey('Profile'),
                title: Text("Profile相关方法测试"),
                onTap: () {
                  print('Profile相关方法测试');
                  Navigator.pushNamed(context, '/profile');
                }),
            ListTile(
                key: RangersApplogElementKey('test-tap'),
                title: Text("Test Tap"),
                onTap: () {
                  print('tap! tap tap');
                  toast('tap! tap tap');
                }),
            ListTile(
                title: Text("Go to Page2"),
                onTap: () {
                  Navigator.pushNamed(context, '/page2');
                  // Navigator.popAndPushNamed(context, '/page2');
                }),
            ListTile(
                title: Text("Double push to Page3"),
                onTap: () {
                  Navigator.pushNamed(context, '/page2');
                  Navigator.pushNamed(context, '/page3');
                  // Navigator.popAndPushNamed(context, '/page2');
                }),
            ListTile(
                title: Text("init AppLog $_listen_text"),
                onTap: () {
                  _initAppLog();
                }),
            ListTile(
                title: Text("Test get device_id $_device_id"),
                onTap: () {
                  _getDeviceID();
                }),
            ListTile(
                title: Text("Test get ab_sdk_version $_ab_sdk_version"),
                onTap: () {
                  _getAbSdkVersion();
                }),
            ListTile(
                title: Text('getAllAbTestConfig $allABConfigs'),
                onTap: () {
                  _getAllAbTestConfig();
                }),
            ListTile(
                title: Text("Test get abTestConfigValue $_ab_config_value"),
                onTap: () {
                  _getABTestConfigValueForKey();
                }),
            ListTile(
                title: Text("Listen ABTestConfig $_listen_abconfig"),
                onTap: () {
                  RangersApplogFlutterPlugin.receiveABTestConfigStream()
                      .listen((event) {
                    setState(() {
                      _listen_abconfig = "update ${DateTime.now()}";
                    });
                  });
                }),
            ListTile(
                title: Text("Test onEventV3"),
                onTap: () {
                  RangersApplogFlutterPlugin.onEventV3(
                      "event_v3_name", {"key1": "value1", "key2": "value2"});
                }),
            ListTile(
                title: Text("Test setHeaderInfo"),
                onTap: () {
                  RangersApplogFlutterPlugin.setHeaderInfo({
                    "header_key1": "header_value1",
                    "header_key2": "header_value2",
                    // "header_key3": Null  // Invalid argument: Null
                  });
                }),
            ListTile(
                title: Text("Test removeHeaderInfo"),
                onTap: () {
                  RangersApplogFlutterPlugin.removeHeaderInfo("header_key1");
                  RangersApplogFlutterPlugin.removeHeaderInfo("header_key2");
                }),
            ListTile(
                title: Text("Test setUserUniqueId"),
                onTap: () {
                  RangersApplogFlutterPlugin.setUserUniqueId(uuid.toString());
                  uuid++;
                }),
            ListTile(title: Text("RangersApplog SDK Version $_sdkVersion")),
            ListTile(
                title: Text("Test start Track "),
                onTap: () {
                  // RangersApplogFlutterPlugin.startTrack(RangersAppLogTestAppID, "dp_tob_sdk_test2");
                }),
            ListTile(
                title: Text("Test call did $_did "),
                onTap: () {
                  _getDid();
                }),
            // ListTile(
            //     title: Text("Test call ssid $_ssid "),
            //     onTap: () {
            //       _getSSID();
            //     }),
            // ListTile(
            //     title: Text("Test call iid $_iid "),
            //     onTap: () {
            //       _getIid();
            //     }),
            // ListTile(
            //     title: Text("Test call uuid $_uuid "),
            //     onTap: () {
            //       _getUUID();
            //     }),
            ListTile(
                title: Text("Test call eventV3 "),
                onTap: () {
                  RangersApplogFlutterPlugin.onEventV3(
                      "test_event", {"key": "value"});
                }),
            ListTile(
                title: Text("onEventV3混合参数"),
                onTap: () {
                  RangersApplogFlutterPlugin.onEventV3(
                      "event_v3_name", {"key1": "string", "key2": 1,"key3":["item1","item2"],"key4":null});
                }),
            ListTile(
                title: Text("onEventV3参数null"),
                onTap: () {
                  RangersApplogFlutterPlugin.onEventV3(
                      "event_v3_name",null);
                }),
          ],
        ));
  }
}
