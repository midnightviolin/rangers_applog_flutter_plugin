package com.bytedance.rangers_applog_flutter_plugin_example;

import android.os.Bundle;

import com.bytedance.applog.AppLog;
import com.bytedance.applog.InitConfig;
import com.bytedance.applog.devtools.AppLogDevTools;

import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    AppLogDevTools.setFloatingButtonVisible(true);

//    InitConfig initConfig = new InitConfig("159486", "local_test");
//    initConfig.setAutoStart(true);
//    initConfig.setAbEnable(true);
//    initConfig.setLogger((s, throwable) -> android.util.Log.d("AppLog", s, throwable));
//    AppLog.init(this, initConfig);
//    initConfig.setRegion()
  }
}
