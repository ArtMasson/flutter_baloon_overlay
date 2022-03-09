import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_baloon_overlay/tooltip/overlay/triangle_painter.dart';

import 'baloon_overlay_helper.dart';

enum parentPosition {
  left,
  center,
  right,
}

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
  late double _width;

  late bool _isInCenter;

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
    var widgetRect =
        rect ?? BaloonOverlayHelper.getWidgetGlobalRect(widgetKey!);
    var screenSize = window.physicalSize / window.devicePixelRatio;
    _width = screenSize.width;

    var offset = BaloonOverlayHelper.calculateOffset(
      context: context,
      arrowHeight: arrowHeight,
      height: height,
      screenSize: screenSize,
      widgetRect: widgetRect,
      width: _width,
    );

    var _isArrowDown = BaloonOverlayHelper.isArrowDown(
      context: context,
      arrowHeight: arrowHeight,
      widgetRect: widgetRect,
      height: height,
    );

    var _haveOffsetRight = BaloonOverlayHelper.widgetHaveRightOffset(
      key: widgetKey!,
      width: _width,
    );
    _isInCenter = BaloonOverlayHelper.widgetIsInCenter(
      key: widgetKey,
      width: _width,
    );

    var verticalOffsets = BaloonOverlayHelper.calculateVerticalOffset(
      widgetKey: widgetKey,
      haveOffsetRight: _haveOffsetRight,
      isInCenter: _isInCenter,
      offsetLeft: _offsetLeft,
      offsetRight: _offsetRight,
      screenSize: screenSize,
      widgetRect: widgetRect,
    );

    _offsetLeft = verticalOffsets[0];
    _offsetRight = verticalOffsets[1];

    _entry = OverlayEntry(
      builder: (context) {
        return buildPopupLayout(
          offset: offset,
          parentRect: widgetRect,
          isArrowDown: _isArrowDown,
          arrowHeight: arrowHeight,
          haveOffsetRight: _haveOffsetRight,
        );
      },
    );

    Overlay.of(context)!.insert(_entry);
    _isVisible = true;
  }

  /// Builds popup for specific [offset]
  Widget buildPopupLayout({
    required Offset offset,
    required Rect parentRect,
    required bool isArrowDown,
    required double arrowHeight,
    required bool haveOffsetRight,
  }) {
    var centerWidgetFather = parentRect.left + parentRect.width / 2.0 - 7.5;

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
              top: isArrowDown ? offset.dy + height : offset.dy - arrowHeight,
              child: CustomPaint(
                size: Size(15.0, arrowHeight),
                painter: TrianglePainter(
                  isDownArrow: isArrowDown,
                  color: backgroundColor,
                ),
              ),
            ),
            // popup content
            _buildPopup(
              offset: offset,
              height: height,
              padding: padding,
              text: text,
              textStyle: textStyle,
              width: _width,
              haveOffsetRight: haveOffsetRight,
            ),
          ],
        ),
      ),
    );
  }

  _buildPopup({
    required Offset offset,
    required EdgeInsetsGeometry padding,
    required double height,
    required double width,
    required String text,
    required TextStyle textStyle,
    required bool haveOffsetRight,
  }) {
    if (_isInCenter) {
      return Padding(
        padding: EdgeInsets.only(
          top: offset.dy,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBaloon(
              height: height,
              padding: padding,
              text: text,
              textStyle: textStyle,
              width: width,
            ),
          ],
        ),
      );
    } else if (haveOffsetRight) {
      return Padding(
        padding: EdgeInsets.only(
          top: offset.dy,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            _buildBaloon(
              height: height,
              padding: padding,
              text: text,
              textStyle: textStyle,
              width: width,
            ),
            SizedBox(
              width: _offsetRight,
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(
          top: offset.dy,
          left: _offsetLeft,
          right: _offsetRight,
        ),
        child: _buildBaloon(
          height: height,
          padding: padding,
          text: text,
          textStyle: textStyle,
          width: _width,
        ),
      );
    }
  }

  _buildBaloon({
    required EdgeInsetsGeometry padding,
    required double height,
    required double width,
    required String text,
    required TextStyle textStyle,
  }) {
    return Container(
      padding: padding,
      height: height,
      constraints: BoxConstraints(
        maxWidth: width,
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
    );
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
