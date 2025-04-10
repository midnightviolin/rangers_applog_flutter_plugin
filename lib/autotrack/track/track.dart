import '../../rangers_applog_flutter_plugin.dart';
import '../click/click_info.dart';
import '../config/manager.dart';
import '../log/logger.dart';
import '../pageview/page_info.dart';

class Track {
  static final Track instance = Track._();
  Track._();

  Map<String, dynamic> _appendPageInfo(Map<String, dynamic> params, PageInfo pageInfo) {
    params['page_key'] = pageInfo.pageKey;
    params['page_title'] = pageInfo.pageTitle;
    params['page_manual_key'] = pageInfo.pageManualKey;
    params['page_path'] = pageInfo.pagePath;
    params['is_back'] = pageInfo.isBack ? 1 : 0;
    return params;
  }
  
  void pageview(PageInfo pageInfo) {
    if (!AutoTrackConfigManager.instance.autoTrackEnable) {
      return;
    }
    if (!AutoTrackConfigManager.instance.pageViewEnabled) {
      return;
    }

    Map<String, dynamic> params = _appendPageInfo(Map(), pageInfo);
    _TrackPlugin.pageview(params);
    RangersApplogLogger.getInstance().debug('track pageview => $params');
  }

  void pageleave(PageInfo pageInfo) {
    if (!AutoTrackConfigManager.instance.autoTrackEnable) {
      return;
    }
    if (!AutoTrackConfigManager.instance.pageLeaveEnable) {
      return;
    }

    Map<String, dynamic> params = _appendPageInfo(Map(), pageInfo);
    params['\$page_duration'] = pageInfo.timer.duration.inMilliseconds;
    _TrackPlugin.pageleave(params);
    RangersApplogLogger.getInstance().debug('track pageleave => $params');
  }

  void click(ClickInfo clickInfo) {
    if (!AutoTrackConfigManager.instance.autoTrackEnable) {
      return;
    }
    if (!AutoTrackConfigManager.instance.clickEnable) {
      return;
    }

    Map<String, dynamic> params = Map();
    params['touch_x'] = clickInfo.touchX;
    params['touch_y'] = clickInfo.touchY;
    params['element_width'] = clickInfo.elementWidth;
    params['element_height'] = clickInfo.elementHeight;
    params['element_type'] = clickInfo.elementType;
    params['element_manual_key'] = clickInfo.elementManualKey;
    params['element_path'] = clickInfo.elementPath;
    params['texts'] = clickInfo.texts;
    _appendPageInfo(params, clickInfo.pageInfo);
    _TrackPlugin.click(params);
    RangersApplogLogger.getInstance().debug('track click => $params');
  }
}

class _TrackPlugin {
  static const String _isFlutterKey = '\$is_flutter';
  static Map<String, dynamic> _appendCommon(Map<String, dynamic> params) {
    params[_isFlutterKey] = 1;
    return params;
  }

  static void pageview(Map<String, dynamic> params) {
    RangersApplogFlutterPlugin.onEventV3('bav2b_page', _appendCommon(params));
    // print(params);
  }

  static void pageleave(Map<String, dynamic> params) {
    RangersApplogFlutterPlugin.onEventV3('\$bav2b_page_leave', _appendCommon(params));
    // print(params);
  }

  static void click(Map<String, dynamic> params) {
    RangersApplogFlutterPlugin.onEventV3('bav2b_click', _appendCommon(params));
    // print(params);
  }
}