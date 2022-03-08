import 'package:flutter/material.dart';

class BaloonOverlayHelper {
  /// Returns globalRect of widget with key [key]
  static Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  /// Returns if the widget with key [key] must have offset right
  static bool widgetHaveRightOffset({required GlobalKey key, required width}) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return offset.dx > width / 2;
  }

  /// Returns if the widget with key [key] must have offset right
  static bool widgetIsInCenter({
    required GlobalKey key,
    required width,
  }) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    var xWidget = offset.dx + renderBox.size.width;
    return xWidget >= width / 2 && xWidget <= width / 1.5;
  }

  /// Returns calculated widget offset using [context]
  static Offset calculateOffset({
    required BuildContext context,
    required Rect widgetRect,
    required Size screenSize,
    required double width,
    required double height,
    required double arrowHeight,
    required bool isArrowDown,
  }) {
    double dx = widgetRect.left + widgetRect.width / 2.0 - width / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx > screenSize.width && dx > 10.0) {
      double tempDx = screenSize.width - width - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = widgetRect.top - height;
    if (dy <= MediaQuery.of(context).padding.top + 50) {
      // not enough space above, show popup under the widget.
      dy = arrowHeight + widgetRect.height + widgetRect.top;
      isArrowDown = false;
    } else {
      dy -= arrowHeight;
      isArrowDown = true;
    }

    return Offset(dx, dy);
  }

  static void calculateVerticalOffset({
    required GlobalKey widgetKey,
    required Rect widgetRect,
    required Size screenSize,
    required double offsetLeft,
    required double offsetRight,
    required double width,
    required bool haveOffsetRight,
    required bool isInCenter,
  }) {
    RenderBox renderBox =
        widgetKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    var centerWidgetFather = widgetRect.left + widgetRect.width / 2.0 - 7.5;
    haveOffsetRight = widgetHaveRightOffset(key: widgetKey, width: width);
    isInCenter = widgetIsInCenter(key: widgetKey, width: width);

    if (isInCenter) {
      offsetLeft = centerWidgetFather - 7.5;

      offsetRight = screenSize.width - (offset.dx + renderBox.size.width);
    }
    if (haveOffsetRight) {
      offsetLeft = centerWidgetFather / 2;

      offsetRight = screenSize.width - (offset.dx + renderBox.size.width);
    } else {
      offsetLeft = centerWidgetFather - 7.5;

      offsetRight = 0;
    }
  }
}