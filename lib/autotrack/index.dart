
import 'package:flutter/widgets.dart';

import 'click/pointer_event_listener.dart';
import 'config/config.dart';
import 'config/manager.dart';
import 'log/logger.dart';

class RangersApplogAutoTrack {
  static RangersApplogAutoTrack _instance = RangersApplogAutoTrack._();
  RangersApplogAutoTrack._();

  factory RangersApplogAutoTrack({ RangersApplogAutoTrackConfig? config }) {
    _instance.config(config);
    return _instance;
  }

  RangersApplogAutoTrack config(RangersApplogAutoTrackConfig? config) {
    if (config != null) {
      AutoTrackConfigManager.instance.updateConfig(config);
    }
    return _instance;
  }

  RangersApplogAutoTrack pageConfigs(List<RangersApplogAutoTrackPageConfig>? pageConfigs) {
    if (pageConfigs != null) {
      AutoTrackConfigManager.instance.updatePageConfigs(pageConfigs);
    }
    return _instance;
  }

  /// 推荐使用 [RangersApplogElementKey]
  RangersApplogAutoTrack ignoreElementKeys(List<Key>? ignoreElementKeys) {
    if (ignoreElementKeys != null) {
      AutoTrackConfigManager.instance.updateIgnoreElementKeys(ignoreElementKeys);
    }
    return _instance;
  }

  RangersApplogAutoTrack ignoreElementStringKeys(List<String>? ignoreElementStringKeys) {
    if (ignoreElementStringKeys != null) {
      AutoTrackConfigManager.instance.updateIgnoreElementStringKeys(ignoreElementStringKeys);
    }
    return _instance;
  }

  RangersApplogAutoTrack enablePageView() {
    AutoTrackConfigManager.instance.enablePageView(true);
    return _instance;
  }

  RangersApplogAutoTrack disablePageView() {
    AutoTrackConfigManager.instance.enablePageView(false);
    return _instance;
  }

  RangersApplogAutoTrack enablePageLeave() {
    AutoTrackConfigManager.instance.enablePageLeave(true);
    return _instance;
  }

  RangersApplogAutoTrack disablePageLeave() {
    AutoTrackConfigManager.instance.enablePageLeave(false);
    return _instance;
  }

  RangersApplogAutoTrack enableClick() {
    AutoTrackConfigManager.instance.enableClick(true);
    return _instance;
  }

  RangersApplogAutoTrack disableClick() {
    AutoTrackConfigManager.instance.enableClick(false);
    return _instance;
  }

  RangersApplogAutoTrack enable() {
    AutoTrackConfigManager.instance.enableAutoTrack(true);
    PointerEventListener.instance.start();
    return _instance;
  }

  RangersApplogAutoTrack disable() {
    AutoTrackConfigManager.instance.enableAutoTrack(false);
    PointerEventListener.instance.stop();
    return _instance;
  }

  RangersApplogAutoTrack enableLog() {
    final logger = RangersApplogLogger.getInstance();
    if (!logger.hasHandler) {
      logger.setHandler((level, message) {
        print('RangersApplog[$level] - $message');
      });
    }
    return _instance;
  }
}
