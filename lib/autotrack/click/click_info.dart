import 'package:flutter/widgets.dart';

import '../config/manager.dart';
import '../pageview/page_info.dart';
import '../utils/element_util.dart';
import 'element_key.dart';
import 'xpath.dart';

class ClickInfo {
  ClickInfo._(this.pageInfo);

  factory ClickInfo.from({
    required Element gestureElement,
    required PointerDownEvent event,
    required Element pageElement,
    required PageInfo pageInfo,
  }) {
    ClickInfo clickInfo = ClickInfo._(pageInfo);
    clickInfo._touchX = event.position.dx.round();
    clickInfo._touchY = event.position.dy.round();

    XPath xpath = XPath.createBy(element: gestureElement, pageElement: pageElement);
    Element element = xpath.targetElement;
    clickInfo._elementType = element.widget.runtimeType.toString();
    clickInfo._elementWidth = element.size?.width.round() ?? 0;
    clickInfo._elementHeight = element.size?.height.round() ?? 0;
    clickInfo._elementPath = xpath.toString();
    clickInfo._texts = ElementUtil.findTexts(element);
    // print(clickInfo._elementPath);

    Key? key = element.widget.key;
    clickInfo._elementManualKey = key?.toString() ?? '';
    clickInfo._ignore = AutoTrackConfigManager.instance.isIgnoreElement(key);
    if (key is RangersApplogElementKey && !clickInfo._ignore) {
      clickInfo._ignore = key.ignore;
    }

    return clickInfo;
  }

  int _touchX = 0;
  int get touchX => _touchX;

  int _touchY = 0;
  int get touchY => _touchY;

  int _elementWidth = 0;
  int get elementWidth => _elementWidth;

  int _elementHeight = 0;
  int get elementHeight => _elementHeight;

  String _elementType = '';
  String get elementType => _elementType;

  String _elementManualKey = '';
  String get elementManualKey => _elementManualKey;

  String _elementPath = '';
  String get elementPath => _elementPath;

  bool _ignore = false;
  bool get ignore => _ignore;

  List<String> _texts = [];
  List<String> get texts => _texts;

  final PageInfo pageInfo;

  @override
  String toString() {
    return [
      'elementType: $elementType',
      'elementManualKey: $elementManualKey',
      'elementPath: $elementPath',
      'touchX: $touchX',
      'touchY: $touchY',
      'elementWidth: $elementWidth',
      'elementHeight: $elementHeight',
      'texts: ${texts.join(";")}',
      'pageInfo: $pageInfo',
    ].join(', ');
  }
}