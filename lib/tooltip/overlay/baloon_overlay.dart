import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_baloon_overlay/tooltip/overlay/triangle_painter.dart';

class BaloonOverlay {
  final Color closeIconColor;

  final BuildContext context;
  final double arrowHeight = 10;
  final double height;
  final String text;
  final TextStyle textStyle;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  late OverlayEntry _entry;
  late Offset _offset;
  late Rect _showRect;
  late Size _screenSize;
  late double _width;
  late bool _haveOffsetRight;
  late bool _isInCenter;

  bool _isArrowDown = true;
  VoidCallback? dismissCallback;
  bool _isVisible = false;

  double _offsetLeft = 0;
  double _offsetRight = 0;

  BaloonOverlay({
    required this.context,
    required this.backgroundColor,
    required this.borderRadius,
    required this.height,
    required this.text,
    required this.textStyle,
    required this.closeIconColor,
    this.dismissCallback,
    this.padding = EdgeInsets.zero,
  });

  /// Shows a popup near a widget with key [widgetKey] or [rect].
  void show({
    required GlobalKey? widgetKey,
    Rect? rect,
  }) {
    _showRect = rect ?? _getWidgetGlobalRect(widgetKey!);
    _screenSize = window.physicalSize / window.devicePixelRatio;
    _width = _screenSize.width;

    _offset = _calculateOffset(context);

    _calculateVerticalOffset(widgetKey!);

    _entry = OverlayEntry(builder: (context) {
      return buildPopupLayout(_offset);
    });

    Overlay.of(context)!.insert(_entry);
    _isVisible = true;
  }

  // void show({
  //   required GlobalKey? widgetKey,
  //   Rect? rect,
  // }) {
  //   _showRect = rect ?? BaloonOverlayHelper.getWidgetGlobalRect(widgetKey!);
  //   _screenSize = window.physicalSize / window.devicePixelRatio;
  //   _width = _screenSize.width;

  //   _offset = BaloonOverlayHelper.calculateOffset(
  //     context: context,
  //     arrowHeight: arrowHeight,
  //     height: height,
  //     isArrowDown: _isArrowDown,
  //     screenSize: _screenSize,
  //     widgetRect: _showRect,
  //     width: _width,
  //   );

  //   BaloonOverlayHelper.calculateVerticalOffset(
  //     widgetKey: widgetKey!,
  //     haveOffsetRight: _haveOffsetRight,
  //     isInCenter: _isInCenter,
  //     offsetLeft: _offsetLeft,
  //     offsetRight: _offsetRight,
  //     screenSize: _screenSize,
  //     widgetRect: _showRect,
  //     width: _width,
  //   );

  //   _entry = OverlayEntry(builder: (context) {
  //     return buildPopupLayout(_offset);
  //   });

  //   Overlay.of(context)!.insert(_entry);
  //   _isVisible = true;
  // }

  /// Returns globalRect of widget with key [key]
  Rect _getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  /// Returns if the widget with key [key] must have offset right
  bool _widgetHaveRightOffset(GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    return offset.dx > _width / 2;
  }

  /// Returns if the widget with key [key] must have offset right
  bool _widgetIsInCenter(GlobalKey key) {
    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    var xWidget = offset.dx + renderBox.size.width;
    return xWidget >= _width / 2 && xWidget <= _width / 1.5;
  }

  /// Returns calculated widget offset using [context]
  Offset _calculateOffset(
    BuildContext context,
  ) {
    double dx = _showRect.left + _showRect.width / 2.0 - _width / 2.0;
    if (dx < 10.0) {
      dx = 10.0;
    }

    if (dx > _screenSize.width && dx > 10.0) {
      double tempDx = _screenSize.width - _width - 10;
      if (tempDx > 10) dx = tempDx;
    }

    double dy = _showRect.top - height;
    if (dy <= MediaQuery.of(context).padding.top + 50) {
      // not enough space above, show popup under the widget.
      dy = arrowHeight + _showRect.height + _showRect.top;
      _isArrowDown = false;
    } else {
      dy -= arrowHeight;
      _isArrowDown = true;
    }

    return Offset(dx, dy);
  }

  void _calculateVerticalOffset(GlobalKey widgetKey) {
    RenderBox renderBox =
        widgetKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);

    var centerWidgetFather = _showRect.left + _showRect.width / 2.0 - 7.5;
    _haveOffsetRight = _widgetHaveRightOffset(widgetKey);
    _isInCenter = _widgetIsInCenter(widgetKey);

    if (_isInCenter) {
      _offsetLeft = centerWidgetFather - 7.5;

      _offsetRight = _screenSize.width - (offset.dx + renderBox.size.width);
    }
    if (_haveOffsetRight) {
      _offsetLeft = centerWidgetFather / 2;

      _offsetRight = _screenSize.width - (offset.dx + renderBox.size.width);
    } else {
      _offsetLeft = centerWidgetFather - 7.5;

      _offsetRight = 0;
    }
  }

  /// Builds Layout of popup for specific [offset]
  LayoutBuilder buildPopupLayout(Offset offset) {
    var centerWidgetFather = _showRect.left + _showRect.width / 2.0 - 7.5;

    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dismiss();
        },
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: <Widget>[
              // triangle arrow
              Positioned(
                left: centerWidgetFather,
                top:
                    _isArrowDown ? offset.dy + height : offset.dy - arrowHeight,
                child: CustomPaint(
                  size: Size(15.0, arrowHeight),
                  painter: TrianglePainter(
                    isDownArrow: _isArrowDown,
                    color: backgroundColor,
                  ),
                ),
              ),
              // popup content
              if (_isInCenter)
                Padding(
                  padding: EdgeInsets.only(
                    top: offset.dy,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: padding,
                        height: height,
                        constraints: BoxConstraints(
                          maxWidth: _width,
                        ),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: borderRadius,
                        ),
                        child: FittedBox(
                          child: Row(
                            children: [
                              Text(
                                text,
                                style: textStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (!_isInCenter && _haveOffsetRight)
                Padding(
                  padding: EdgeInsets.only(
                    top: offset.dy,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Container(
                        padding: padding,
                        height: height,
                        constraints: BoxConstraints(
                          maxWidth: _width,
                        ),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: borderRadius,
                        ),
                        child: FittedBox(
                          child: Row(
                            children: [
                              Text(
                                text,
                                style: textStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _offsetRight,
                      )
                    ],
                  ),
                ),
              if (!_isInCenter && !_haveOffsetRight)
                Padding(
                  padding: EdgeInsets.only(
                    top: offset.dy,
                    left: _offsetLeft,
                    right: _offsetRight,
                  ),
                  child: Container(
                    padding: padding,
                    height: height,
                    constraints: BoxConstraints(
                      maxWidth: _width,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: borderRadius,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF808080),
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    child: FittedBox(
                      child: Row(
                        children: [
                          Text(
                            text,
                            style: textStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  /// Dismisses the popup
  void dismiss() {
    if (!_isVisible) {
      return;
    }
    _entry.remove();
    _isVisible = false;
    dismissCallback?.call();
  }
}
