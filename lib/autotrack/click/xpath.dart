import 'dart:collection';

import 'package:flutter/material.dart';
// import 'package:rangers_applog_flutter_plugin/autotrack/log/logger.dart';

class XPath {
  XPath._(this._targetElement);

  factory XPath.createBy({
    required Element element,
    required Element pageElement,
  }) {
    // int startTime = DateTime.now().millisecondsSinceEpoch;

    XPath xpath = XPath._(element);
    xpath._targetElement = element;

    final highLevelSet = _PathConst.highLevelSet;
    LinkedList<_ElementEntry> origalPath = LinkedList();
    origalPath.add(_ElementEntry(element));

    bool lookforTarget = true;
    element.visitAncestorElements((parent) {
      if (parent.widget is GestureDetector) {
        lookforTarget = false;
      }
      if (lookforTarget && highLevelSet.contains(parent.widget.runtimeType)) {
        xpath._targetElement = parent;
      }
      origalPath.add(_ElementEntry(parent));
      if (pageElement == parent) {
        return false;
      }
      return true;
    });

    LinkedList<_PathNode> path = xpath._buildFromOrigal(xpath._targetElement, origalPath);
    xpath._shortPath(path);

    if (path.isNotEmpty) {
      path.first.isPage = true;
    }
    path.forEach((node) => node.computeIndex());
    xpath._path = path;

    // int endTime = DateTime.now().millisecondsSinceEpoch;
    // RangersApplogLogger.getInstance().info('clickInfo - ${endTime - startTime}');
    
    return xpath;
  }

  Element _targetElement;
  Element get targetElement => _targetElement;

  LinkedList<_PathNode> _path = LinkedList();
  LinkedList<_PathNode> get path => _path;

  LinkedList<_PathNode> _buildFromOrigal(Element targetElement, LinkedList<_ElementEntry> origalPath) {
    LinkedList<_PathNode> path = LinkedList();
    if (origalPath.isEmpty) {
      return path;
    }

    _ElementEntry? entry = origalPath.last;
    while (entry != null) {
      _PathNode node = _PathNode(entry.element);
      if (!node.ignore) {
        node.formatName();
        path.add(node);
      }
      if (entry.element == targetElement) {
        break;
      }
      entry = entry.previous;
    }
    return path;
  }

  void _shortPath(LinkedList<_PathNode> path) {
    if (path.isEmpty) {
      return;
    }

    final shortWidgetMap = _PathConst.shortWidgetMap;
    _PathNode? node = path.first;
    while (node != null) {
      if (shortWidgetMap.containsKey(node.name)) {
        _ShortWidgetConfig short = shortWidgetMap[node.name]!;
        node = _removeInteral(path, node, short);
      } else {
        node = node.next;
      }
    }
  }

  _PathNode? _removeInteral(LinkedList<_PathNode> path, _PathNode node, _ShortWidgetConfig short) {
    _PathNode? interalNode = node.next;
    Element? indexElement;
    for (String intertalWidgetName in short.interalWidgets) {
      if (interalNode == null) {
        return null;
      }

      if (interalNode.name != intertalWidgetName) {
        return interalNode;
      }
      if (intertalWidgetName == short.indexWidget) {
        indexElement = interalNode.indexElement;
      }
      _PathNode tmpNode = interalNode;
      interalNode = interalNode.next;
      path.remove(tmpNode);
    }
    if (indexElement != null) {
      interalNode?.indexElement = indexElement;
    }
    return interalNode;
  }

  @override
  String toString() {
    return path.join('/');
  }
}

class _ElementEntry extends LinkedListEntry<_ElementEntry> {
  _ElementEntry(this.element);
  final Element element;
}

class _PathNode extends LinkedListEntry<_PathNode> {
  _PathNode(this.indexElement) {
    _name = indexElement.widget.runtimeType.toString();
    _checkIgnore(indexElement);
  }

  String _name = '';
  String get name => _name;

  int _index = 0;
  int get index => _index;

  bool _ignore = false;
  bool get ignore => _ignore;

  bool isPage = false;
  Element indexElement;

  void formatName() {
    String widgetName = _name;
    int index = widgetName.indexOf('\<');
    if (index > -1) {
      _name = widgetName.substring(0, index);
    }
  }

  void _checkIgnore(Element element) {
    Widget widget = element.widget;
    if (!(widget is StatelessWidget) && !(widget is StatefulWidget)) {
      _ignore = true;
      return;
    }

    if (_name[0] == '_') {
      _ignore = true;
      return;
    }
  }

  void computeIndex() {
    Element? parent;
    indexElement.visitAncestorElements((element) {
      parent = element;
      return false;
    });
    if (parent == null) {
      isPage = true;
      return;
    }

    bool found = false;
    _index = 0;
    parent!.visitChildElements((element) {
      if (element == indexElement) {
        found = true;
      }
      if (!found) {
        _index++;
      }
    });
  }

  @override
  String toString() {
    if (isPage) {
      return _name;
    }
    return '$_name[$_index]';
  }
}

class _PathConst {
  static final Set<Type> highLevelSet = Set.from([
    InkWell,
    ElevatedButton,
    IconButton,
    TextButton,
    ListTile,
  ]);
  /// key: Widget Name, value: Widget Name who handle child/children
  static final Map<String, _ShortWidgetConfig> shortWidgetMap = {
    'Scaffold': _ShortWidgetConfig([
      'ScrollNotificationObserver',
      'Material',
      'AnimatedPhysicalModel',
      'AnimatedDefaultTextStyle',
      'AnimatedBuilder',
      'Actions'
    ]),
    'AppBar': _ShortWidgetConfig([
      'Material',
      'AnimatedPhysicalModel',
      'AnimatedDefaultTextStyle',
      'SafeArea',
      'Builder',
      'NavigationToolbar',
    ]),
    'BottomNavigationBar': _ShortWidgetConfig([
      'Material',
      'AnimatedPhysicalModel',
      'AnimatedDefaultTextStyle',
      'Material',
      'AnimatedDefaultTextStyle',
      'Builder',
    ]),
    'ListView': _ShortWidgetConfig([
      'Scrollable',
      'RawGestureDetector',
      'KeyedSubtree',
      'AutomaticKeepAlive',
    ], indexWidget: 'KeyedSubtree'),
    'PageView': _ShortWidgetConfig([
      'Scrollable',
      'RawGestureDetector',
      'SliverFillViewport',
      'KeyedSubtree',
      'AutomaticKeepAlive',
    ], indexWidget: 'KeyedSubtree'),
    'Card': _ShortWidgetConfig([
      'Container',
      'Material',
      'AnimatedDefaultTextStyle',
    ]),
    'IconButton': _ShortWidgetConfig([
      'InkResponse',
      'Actions',
      'Focus',
      'GestureDetector',
      'RawGestureDetector',
    ]),
    'InkResponse': _ShortWidgetConfig([
      'Actions',
      'Focus',
      'GestureDetector',
    ]),
  };
}

class _ShortWidgetConfig {
  _ShortWidgetConfig(this.interalWidgets, { this.indexWidget });
  final List<String> interalWidgets;
  final String? indexWidget;
}
