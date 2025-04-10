
import 'dart:collection';
import 'dart:core';

import 'package:flutter/widgets.dart';

import '../track/track.dart';
import 'page_info.dart';

class PageStack with WidgetsBindingObserver {
  static final PageStack instance = PageStack._();
  PageStack._() {
    WidgetsBinding.instance?.addObserver(this);
  }

  LinkedList<_Page> _stack = LinkedList<_Page>();
  _PageTask _task = _PageTask();

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _stack.forEach((page) => page.pageInfo.timer.resume());
    } else if (state == AppLifecycleState.paused) {
      _stack.forEach((page) => page.pageInfo.timer.pause());
    }
  }
  
  push(Route route, Element element, Route? previousRoute) {
    // print('push -> $pageElement, route: $route, preRoute: $previousRoute');
    _Page page = _Page(route, element);
    _stack.add(page);
    _task.addPush(page, page.previous);
  }

  pop(Route route, Route? previousRoute) {
    if (_stack.isEmpty) {
      return;
    }

    _Page? page = _findPage(route);
    if (page != null) {
      _task.addPop(page, page.previous);
    }
    _removeAllAfter(page);
  }

  remove(Route route, Route? previousRoute) {
    if (_stack.isEmpty) {
      return;
    }

    _Page? page = _findPage(route);
    if (page != null) {
      _stack.remove(page);
    }
  }

  replace(Route newRoute, Element newElement, Route? oldRoute) {
    _Page newPage = _Page(newRoute, newElement);
    _Page? oldPage;
    if (oldRoute != null) {
      oldPage = _findPage(oldRoute);
      _removeAllAfter(oldPage);
    }
    _stack.add(newPage);
    _task.addReplace(newPage, oldPage);
  }

  _Page? _findPage(Route route) {
    if (_stack.isEmpty) {
      return null;
    }

    _Page? page = _stack.last;
    while (page != null) {
      if (page.route == route) {
        return page;
      }
      page = page.previous;
    }
    return null;
  }

  _removeAllAfter(_Page? page) {
    while (page != null) {
      _stack.remove(page);
      page = page.next;
    }
  }

  _Page? getCurrentPage() {
    if (_stack.isEmpty) {
      return null;
    }
    return _stack.last;
  }
}

class _Page extends LinkedListEntry<_Page> {
  _Page._({
    required this.pageInfo,
    required this.route,
    required this.element,
  });
  factory _Page(Route route, Element element) {
    return _Page._(
      pageInfo: PageInfo.fromElement(element, route),
      route: route,
      element: element,
    );
  }

  final PageInfo pageInfo;
  final Route route;
  final Element element;

  @override
  String toString() => 'pageInfo: $pageInfo, route: $route';
}

class _PageTask {
  List<_PageTaskData> _list = [];
  bool _taskRunning = false;

  addPush(_Page page, _Page? prevPage) {
    _PageTaskData taskData = _PageTaskData(_PageTaskType.Push, page);
    taskData.prevPage = prevPage;
    _list.add(taskData);
    _triggerTask();
  }

  addPop(_Page page, _Page? prevPage) {
    _PageTaskData taskData = _PageTaskData(_PageTaskType.Pop, page);
    taskData.prevPage = prevPage;
    _list.add(taskData);
    _triggerTask();
  }

  addReplace(_Page page, _Page? prevPage) {
    _PageTaskData taskData = _PageTaskData(_PageTaskType.Replace, page);
    taskData.prevPage = prevPage;
    _list.add(taskData);
    _triggerTask();
  }

  _triggerTask() {
    if (_taskRunning) {
      return;
    }

    _taskRunning = true;
    /** 
     * 这里不使用 addPostFrameCallback 是因为连续路由切换，如 popAndPushNamed 时，
     * 用户从视觉上感受不出来，但路由变更会切换多次，导致抓取的埋点与视觉效果对应不上。
     * 
     * 选取 30ms 的延时是考虑到最低 30fps 时，连续路由切换场景下，超过一帧则用户可能感受到页面在连续变化。
     * 所以这里取个折中，在 30ms 内的连续页面变化被合并，超过 30ms 则当作多次变化处理。
     * */
    // SchedulerBinding.instance?.addPostFrameCallback((_) => _executeTask());
    Future.delayed(Duration(milliseconds: 30)).then((_) => _executeTask());
  }

  _executeTask() {
    if (_list.isEmpty) {
      _taskRunning = false;
      return;  
    }

    List list = _list.sublist(0);
    _Page? enterPage, leavePage;
    _list.clear();
    for (_PageTaskData taskData in list) {
      if (taskData.type == _PageTaskType.Push) {
        if (leavePage == null) {
          leavePage = taskData.prevPage;
        }
        enterPage = taskData.page;
      } else if (taskData.type == _PageTaskType.Pop) {
        if (leavePage == null) {
          leavePage = taskData.page;
        }
        if (enterPage == null || enterPage == taskData.page) {
          enterPage = taskData.prevPage;
          enterPage?.pageInfo.isBack = true;
        }
      } else if (taskData.type == _PageTaskType.Replace) {
        if (leavePage == null) {
          leavePage = taskData.prevPage;
        }
        if (enterPage == null || enterPage == taskData.prevPage) {
          enterPage = taskData.page;
        }
      }
    }
    // print('${enterPage?.pageInfo}, ${leavePage?.pageInfo}');
    if (enterPage != leavePage) {
      if (enterPage != null && !enterPage.pageInfo.ignore) {
        enterPage.pageInfo.timer.start();
        Track.instance.pageview(enterPage.pageInfo);
      }
      if (leavePage != null && !leavePage.pageInfo.ignore) {
        leavePage.pageInfo.timer.end();
        Track.instance.pageleave(leavePage.pageInfo);
      }
    }
    _taskRunning = false;
  }
}

class _PageTaskData {
  _PageTaskData(this.type, this.page);
  final _PageTaskType type;
  final _Page page;
  _Page? prevPage;
}

enum _PageTaskType {
  Push,
  Pop,
  Replace,
}
