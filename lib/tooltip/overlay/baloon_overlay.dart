import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'baloon_overlay_helper.dart';

/// #### Example:
///
/// ```dart
/// BaloonOverlay popup = BaloonOverlay(
///   context: context,
///   text: tooltipText,
///   textStyle: textStyle ??
///       const TextStyle(
///         color: Colors.white,
///         fontWeight: FontWeight.bold,
///         fontSize: 12,
///       ),
///   height: height,
///   backgroundColor: backgroundColor ?? const Color(0xCC3A3A48),
///   padding: padding,
///   borderRadius: borderRadius ?? BorderRadius.circular(4),
///   closeIconColor: Colors.white,
/// );
/// popup.show(
///   widgetKey: tooltipKey!,
/// );
///```
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

  VoidCallback? dismissCallback;
  bool _isVisible = false;

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
    var width = screenSize.width;

    var offsetTop = BaloonOverlayHelper.calculateTopOffset(
      context: context,
      arrowHeight: arrowHeight,
      height: height,
      screenSize: screenSize,
      widgetRect: widgetRect,
      width: width,
    );

    var isArrowDown = BaloonOverlayHelper.isArrowDown(
      context: context,
      arrowHeight: arrowHeight,
      widgetRect: widgetRect,
      height: height,
    );

    var haveOffsetRight = BaloonOverlayHelper.widgetHaveRightOffset(
      key: widgetKey!,
      width: width,
    );
    var isInCenter = BaloonOverlayHelper.widgetIsInCenter(
      key: widgetKey,
      width: width,
    );

    var verticalOffsets = BaloonOverlayHelper.calculateVerticalOffset(
      widgetKey: widgetKey,
      haveOffsetRight: haveOffsetRight,
      isInCenter: isInCenter,
      screenSize: screenSize,
      widgetRect: widgetRect,
    );

    var offsetLeft = verticalOffsets[0];
    var offsetRight = verticalOffsets[1];

    ParentPosition position = isInCenter
        ? ParentPosition.center
        : haveOffsetRight
            ? ParentPosition.right
            : ParentPosition.left;

    _entry = OverlayEntry(
      builder: (context) {
        return BaloonOverlayHelper.buildPopupLayout(
          context: context,
          parentRect: widgetRect,
          width: width,
          offsetTop: offsetTop,
          isArrowDown: isArrowDown,
          arrowHeight: arrowHeight,
          offsetLeft: offsetLeft,
          offsetRight: offsetRight,
          position: position,
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          dismiss: dismiss,
          height: height,
          padding: padding,
          text: text,
          textStyle: textStyle,
        );
      },
    );

    Overlay.of(context)!.insert(_entry);
    _isVisible = true;
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
