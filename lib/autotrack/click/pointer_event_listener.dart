
import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
// import 'package:rangers_applog_flutter_plugin/rangers_applog_flutter_plugin.dart';

import '../log/logger.dart';
import '../pageview/page_info.dart';
import '../pageview/page_stack.dart';
import '../track/track.dart';
import '../utils/element_util.dart';
import 'click_info.dart';

class PointerEventListener {
  static PointerEventListener instance = PointerEventListener._();
  PointerEventListener._();

  bool _started = false;
  _MyTapGestureRecognizer _gestureRecognizer = _MyTapGestureRecognizer();

  void start() {
    if (!_started) {
      GestureBinding.instance?.pointerRouter.addGlobalRoute(_pointerRoute);
      _gestureRecognizer = _MyTapGestureRecognizer();
      _gestureRecognizer.onTap = (){};
      _started = true;
    }
  }

  void stop() {
    if (_started) {
      GestureBinding.instance?.pointerRouter.removeGlobalRoute(_pointerRoute);
      _gestureRecognizer.dispose();
      _started = false;
    }
  }

  void _pointerRoute(PointerEvent event) {
    try {
      if (event is PointerDownEvent) {
        _gestureRecognizer.addPointer(event);
      } else if (event is PointerUpEvent) {
        _gestureRecognizer.checkPointerUp(event);
        PointerDownEvent? pointerDownEvent = _gestureRecognizer.lastPointerDownEvent;
        if (event.pointer != _gestureRecognizer.rejectPointer && pointerDownEvent != null) {
          _checkTapElementAndTrack(pointerDownEvent, event);
        }
      }
    } catch (e) {
      RangersApplogLogger.getInstance().error(e);
    }
  }

  void _checkTapElementAndTrack(PointerDownEvent event, PointerUpEvent upEvent) {
    // int startTime = DateTime.now().millisecondsSinceEpoch;

    final page = PageStack.instance.getCurrentPage();
    if (page == null) {
      return;
    }

    // print(upEvent.position);
    LinkedList<_HitEntry> hits = LinkedList();
    ElementUtil.walkElement(page.element, (child, _) {
      if (child is RenderObjectElement && child.renderObject is RenderBox) {
        RenderBox renderBox = child.renderObject as RenderBox;
        if (!renderBox.hasSize) {
          return false;
        }
        
        Offset localPosition = renderBox.globalToLocal(upEvent.position);
        if (!renderBox.size.contains(localPosition)) {
          // print('!! => $renderBox, ${renderBox.paintBounds}');
          return false;
        }

        if (renderBox is RenderPointerListener) {
          hits.add(_HitEntry(child));
        }
      }
      return true;
    });

    if (hits.isEmpty) {
      return;
    }

    _HitEntry? entry = hits.last;
    Element? gestureElement;
    while (entry != null) {
      gestureElement = ElementUtil.findAncestorElementOfWidgetType<GestureDetector>(entry.element);
      if (gestureElement != null) {
        break;
      }
      entry = entry.previous;
    }

    // int midTime = DateTime.now().millisecondsSinceEpoch;
    // print('hitTest - ${midTime - startTime}');

    if (gestureElement != null) {
      _trackClick(gestureElement, event, page.element, page.pageInfo);
    }
    
    // print('--------------------------');
    // testHit(upEvent);

    // int endTime = DateTime.now().millisecondsSinceEpoch;
    // RangersApplogFlutterPlugin.onEventV3('mydebugger', {
    //   'hitTest': '${midTime - startTime}',
    //   'clickinfo': '${endTime - midTime}',
    // });
    // print('clickinfo - ${endTime - midTime}');
  }

  void _trackClick(Element gestureElement, PointerDownEvent event, Element pageElement, PageInfo pageInfo) {
    ClickInfo clickInfo = ClickInfo.from(
      gestureElement: gestureElement,
      event: event,
      pageElement: pageElement,
      pageInfo: pageInfo,
    );
    if (!clickInfo.ignore) {
      Track.instance.click(clickInfo);
    }
  }
}

class _MyTapGestureRecognizer extends TapGestureRecognizer {
  _MyTapGestureRecognizer({ Object? debugOwner }) : super(debugOwner: debugOwner);

  PointerDownEvent? lastPointerDownEvent;
  int rejectPointer = 0;

  void checkPointerUp(PointerUpEvent upEvent) {
    // print('checkPointerUp - ${upEvent.pointer} - $upEvent');
    if (lastPointerDownEvent == null) {
      return;
    }

    Offset downPosition = lastPointerDownEvent!.position;
    Offset upPosition = upEvent.position;
    double offset = (downPosition.dx - upPosition.dx).abs() + (downPosition.dy - upPosition.dy).abs();
    if (offset > 30) {
      rejectGesture(upEvent.pointer);
    }
  }

  @override
  void addPointer(PointerDownEvent event) {
    lastPointerDownEvent = event;
    super.addPointer(event);
    // print('addPointer - ${event.pointer} - $event');
  }

  @override
  void rejectGesture(int pointer) {
    if (lastPointerDownEvent?.pointer == pointer) {
      lastPointerDownEvent = null;
    }
    rejectPointer = pointer;
    super.rejectGesture(pointer);
    // print('rejectGesture - $pointer');
  }
}

class _HitEntry extends LinkedListEntry<_HitEntry> {
  _HitEntry(this.element);
  final Element element;
}
