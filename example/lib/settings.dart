import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _Page2State();
}

class _Page2State extends State<Settings> {
  String _appId = '';
  String _channel = '';
  String _host = '';
  String _region = 'cn';
  String _serviceVendor = '';
  bool _enableAb = false;
  bool _enableLog = false;
  bool _enableEncrypt = false;
  bool _auto_start = true;
  bool _auto_track_enable = true;
  bool _page_view_enable = true;
  bool _page_leave_enable = false;
  bool _click_enable = true;

  void loadFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _appId = prefs.getString('finder_app_id') ?? '10000000';
      _channel = prefs.getString('finder_channel') ?? '';
      _host = prefs.getString('finder_host') ?? 'https://sdk168-6-52finder.datarangers-onpremise.volces.com';
      _region = prefs.getString('finder_region') ?? '';
      _serviceVendor = prefs.getString('finder_service_vendor') ?? '';
      _enableAb = prefs.getBool('finder_enable_ab') ?? false;
      _enableLog = prefs.getBool('finder_enable_log') ?? false;
      _enableEncrypt = prefs.getBool('finder_enable_encrypt') ?? false;
      _auto_start = prefs.getBool('finder_auto_start') ?? true;
      _auto_track_enable = prefs.getBool('auto_track_enable') ?? true;
      _page_view_enable = prefs.getBool('page_view_enable') ?? true;
      _page_leave_enable = prefs.getBool('page_leave_enable') ?? false;
      _click_enable = prefs.getBool('click_enable') ?? true;
    });
  }

  void setStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('finder_app_id', _appId);
    prefs.setString('finder_channel', _channel);
    prefs.setString('finder_host', _host);
    prefs.setString('finder_region', _region);
    prefs.setString('finder_service_vendor', _serviceVendor);
    prefs.setBool('finder_enable_ab', _enableAb);
    prefs.setBool('finder_enable_log', _enableLog);
    prefs.setBool('finder_enable_encrypt', _enableEncrypt);
    prefs.setBool('finder_auto_start', _auto_start);
    prefs.setBool('auto_track_enable', _auto_track_enable);
    prefs.setBool('page_view_enable', _page_view_enable);
    prefs.setBool('page_leave_enable', _page_leave_enable);
    prefs.setBool('click_enable', _click_enable);
  }

  @override
  void initState() {
    super.initState();
    loadFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController appIdController = new TextEditingController();
    TextEditingController channelController = new TextEditingController();
    TextEditingController hostController = new TextEditingController();
    TextEditingController regionController = new TextEditingController();
    TextEditingController serviceVendorController = new TextEditingController();
    appIdController.value = appIdController.value.copyWith(text: _appId);
    channelController.value = channelController.value.copyWith(text: _channel);
    hostController.value = hostController.value.copyWith(text: _host);
    regionController.value = regionController.value.copyWith(text: _region);
    serviceVendorController.value = regionController.value.copyWith(text: _serviceVendor);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: const Text('设置'),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print('123');
            },
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
          IconButton(
            onPressed: () {
              print('456');
            },
            icon: Icon(
              Icons.access_alarm_rounded,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('appId'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: -10, horizontal: -10),
                      hintText: '请输入appId',
                    ),
                    style: TextStyle(fontSize: 15, color: Colors.red),
                    onChanged: (value) {
                      _appId = value;
                    },
                    controller: appIdController,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('channel'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: -10, horizontal: -10),
                      hintText: '请输入channel',
                    ),
                    style: TextStyle(fontSize: 15, color: Colors.red),
                    onChanged: (value) => {_channel = value},
                    controller: channelController,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('host'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: -10, horizontal: -10),
                      hintText: '请输入host',
                    ),
                    style: TextStyle(fontSize: 15, color: Colors.red),
                    onChanged: (value) => {_host = value},
                    controller: hostController,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('region'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: -10, horizontal: -10),
                      hintText: '请输入region',
                    ),
                    style: TextStyle(fontSize: 15, color: Colors.red),
                    onChanged: (value) => {_region = value},
                    controller: regionController,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('serviceVendor'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: -10, horizontal: -10),
                      hintText: '海外(sg/va)，国内可不填',
                    ),
                    style: TextStyle(fontSize: 15, color: Colors.red),
                    onChanged: (value) => {_serviceVendor = value},
                    controller: serviceVendorController,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('enableAb'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                    child: Switch(
                  value: _enableAb,
                  onChanged: (bool value) {
                    setState(() => {_enableAb = value});
                  },
                )),
              ],
            ),
          ),
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('enableLog'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                    child: Switch(
                  value: _enableLog,
                  onChanged: (bool value) {
                    setState(() => {_enableLog = value});
                  },
                )),
              ],
            ),
          ),
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('enableEncrypt'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                    child: Switch(
                  value: _enableEncrypt,
                  onChanged: (bool value) {
                    setState(() => {_enableEncrypt = value});
                  },
                )),
              ],
            ),
          ),
          Container(
            height: 60,
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('autoStart'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                    child: Switch(
                      value: _auto_start,
                      onChanged: (bool value) {
                        setState(() => {_auto_start = value});
                      },
                    )),
              ],
            ),
          ),
          Container(
            height: 60,
            padding:
            const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('auto_track_enable'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                    child: Switch(
                      value: _auto_track_enable,
                      onChanged: (bool value) {
                        setState(() => {_auto_track_enable = value});
                      },
                    )),
              ],
            ),
          ),
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('page_view'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                    child: Switch(
                  value: _page_view_enable,
                  onChanged: (bool value) {
                    setState(() => {_page_view_enable = value});
                  },
                )),
              ],
            ),
          ),
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('page_leave'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                    child: Switch(
                  value: _page_leave_enable,
                  onChanged: (bool value) {
                    setState(() => {_page_leave_enable = value});
                  },
                )),
              ],
            ),
          ),
          Container(
            height: 60,
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Text('click_enable'),
                  margin: const EdgeInsets.only(right: 20),
                ),
                Expanded(
                    child: Switch(
                  value: _click_enable,
                  onChanged: (bool value) {
                    setState(() => {_click_enable = value});
                  },
                )),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setStorage();
            },
            child: Text('保存'),
            style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(double.infinity, 50))),
          ),
        ],
        padding: EdgeInsets.only(bottom: 50),
      ),
      // bottomSheet: Positioned(
      //   child: ElevatedButton(
      //       onPressed: () {
      //         setStorage();
      //       },
      //       child: Text('保存'),
      //       style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(double.infinity, 50))),
      //   ),
      //   left: 10,
      //   right: 10,
      //   bottom: 0,
      //   height: 50,
      // ),
    );
  }
}
