import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rangers_applog_flutter_plugin/autotrack.dart';
import 'package:rangers_applog_flutter_plugin/rangers_applog_flutter_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'common.dart';
import 'home.dart';
import 'page2.dart';
import 'page3.dart';
import 'settings.dart';
import 'profile.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initAppLog();
    initAutoTrack();
    super.initState();
  }

  void initAppLog() async {
    print('初始化开始');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String appId = prefs.getString('finder_app_id') ?? '';
      String channel = prefs.getString('finder_channel') ?? '';
      String? host = prefs.getString('finder_host');
      String region = prefs.getString('finder_region') ?? '';
      String serviceVendor = prefs.getString('finder_service_vendor') ?? '';
      bool enableAb = prefs.getBool('finder_enable_ab') ?? false;
      bool enableLog = prefs.getBool('finder_enable_log') ?? false;
      bool enableEncrypt = prefs.getBool('finder_enable_encrypt') ?? false;
      bool autoStart = prefs.getBool('finder_auto_start') ?? true;
      Map<String, dynamic> initParams = {
        'region': region,
        'autoStart': autoStart,
        'service_vendor':serviceVendor
      };
      RangersApplogFlutterPlugin.addInitParams(initParams);
      RangersApplogFlutterPlugin.initRangersAppLog(
          appId, channel, enableAb, enableEncrypt, enableLog, host);
      print('初始化成功');
      toast('初始化成功，参数为：appid=$appId,channel=$channel,host=$host,region=$region,serviceVendor=$serviceVendor,enableAb=$enableAb,enableLog=$enableLog,enableEncrypt=$enableEncrypt,autoStart=$autoStart');
    } catch (e) {
      print('初始化异常');
      toast('初始化异常');
    }
  }

  void initAutoTrack() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool autoTrackEnable = prefs.getBool('auto_track_enable') ?? true;
      bool pageViewEnable = prefs.getBool('page_view_enable') ?? true;
      bool pageLeaveEnable = prefs.getBool('page_leave_enable') ?? false;
      bool clickEnable = prefs.getBool('click_enable') ?? true;
      RangersApplogAutoTrack instance = RangersApplogAutoTrack()
          .config(RangersApplogAutoTrackConfig(
            pageConfigs: [
              RangersApplogAutoTrackPageConfig<Home>(
                pageID: 'home-id',
                pagePath: '/home-custom',
                ignore: false,
              ),
              RangersApplogAutoTrackPageConfig<Page2>(
                pageID: 'page2-id',
              ),
              RangersApplogAutoTrackPageConfig<Page3>(
                pageID: 'page3-id',
              ),
            ],
            ignoreElementKeys: [],
          ))
          .enableLog();
      if(autoTrackEnable){
        instance.enable();
      }else{
        instance.disable();
      }
      if (pageViewEnable) {
        instance.enablePageView();
      } else {
        instance.disablePageView();
      }
      if (pageLeaveEnable) {
        instance.enablePageLeave();
      } else {
        instance.disablePageLeave();
      }
      if (clickEnable) {
        instance.enableClick();
      } else {
        instance.disableClick();
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: RangersApplogNavigationObserver.wrap([]),
      initialRoute: '/',
      routes: {
        '/': ((context) => Home()),
        '/page2': ((context) => Page2()),
        '/page3': ((context) => Page3()),
        '/page-settings': ((context) => Settings()),
        '/profile': ((context) => Profile())
      },
    );
  }
}
