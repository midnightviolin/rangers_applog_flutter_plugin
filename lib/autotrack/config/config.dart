import 'package:flutter/widgets.dart';

class RangersApplogAutoTrackConfig {
  RangersApplogAutoTrackConfig({
    this.pageConfigs = const [],
    this.useCustomRoute = false,
    this.ignoreElementKeys = const [],
    this.ignoreElementStringKeys = const [],
    this.enablePageView = true,
    this.enablePageLeave = false,
    this.enableClick = true,
  });

  List<RangersApplogAutoTrackPageConfig> pageConfigs;

  /// 如果使用 MaterialPageRoute/PageRoute/ModalRoute 之外的 Route，
  /// 请打开该开关，并保证所有页面都配置在 pageConfigs 中
  bool useCustomRoute;

  /// 推荐使用 [RangersApplogElementKey]
  List<Key> ignoreElementKeys;

  List<String> ignoreElementStringKeys;

  Set<Key> getIgnoreElementKeySet() => Set.from(ignoreElementKeys);

  Set<String> getIgnoreElementStringKeySet() => Set.from(ignoreElementStringKeys);

  bool enablePageView;

  bool enablePageLeave;

  bool enableClick;
}

class RangersApplogAutoTrackPageConfig<T extends Widget> {
  RangersApplogAutoTrackPageConfig({
    this.pageID,
    this.pagePath,
    this.ignore = false,
    this.pageTitle,
  });

  String? pageID;
  String? pagePath;
  bool ignore;
  String? pageTitle;

  bool isPageWidget(Widget pageWidget) => pageWidget is T;
}
