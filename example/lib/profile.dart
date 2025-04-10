import 'package:flutter/material.dart';
import 'package:rangers_applog_flutter_plugin/rangers_applog_flutter_plugin.dart';
import 'package:rangers_applog_flutter_plugin_example/common.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('profile'),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
                onPressed: () {
                  print('profileSet');
                  const params = {"set1": "value", "set2": "value"};
                  RangersApplogFlutterPlugin.profileSet(params);
                  toast('profileSet\nparams=$params');
                },
                child: Text('profileSet')),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
                onPressed: () {
                  print('profileSetOnce');
                  const params = {"setOnce": "value"};
                  RangersApplogFlutterPlugin.profileSetOnce(params);
                  toast('profileSetOnce\nparams=$params');
                },
                child: Text('profileSetOnce')),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
                onPressed: () {
                  print('profileAppend');
                  const params = {"appendStr": "1", "appendNum": 1};
                  RangersApplogFlutterPlugin.profileAppend(params);
                  toast('profileAppend\nparams=$params');
                },
                child: Text('profileAppend')),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
                onPressed: () {
                  print('profileIncrement');
                  const params = {"increment": 1};
                  RangersApplogFlutterPlugin.profileIncrement(params);
                  toast('profileIncrement\nparams=$params');
                },
                child: Text('profileIncrement')),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
                onPressed: () {
                  print('profileUnset');
                  const params = 'set2';
                  RangersApplogFlutterPlugin.profileUnset(params);
                  toast('profileUnset\nparams=$params');
                },
                child: Text('profileUnset')),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) {
                    return route.settings.name == '/';
                  });
                },
                child: Text('Back Home')),
          ),
        ],
      ),
    );
  }
}
