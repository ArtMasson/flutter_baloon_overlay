import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_baloon_overlay/tooltip/overlay/baloon_overlay.dart';

/// ## ButtonTooltipWidget
///
///
/// [tooltipKey] is used to identify the icon widget,
/// later this will be used to calculate popup position.
/// If [tooltipKey] is null, the icon will be hidden.
///
/// [tooltipText] is the text that will be shown in popup.
///
/// [btnTitle] is the text that will be appear at the button.
///
/// [height] is the popup height.
///
/// [padding] the padding of the popup content.
///
/// [backgroundColor] is the popup backgroundColor.
/// If [backgroundColor] is null the color will be the default.
///
/// [textStyle] is the style of the text inside the popup.
/// If [textStyle] is null the style will be the default.
///
/// [borderRadius] is the radius of the popup border
/// If [borderRadius] is null the borderRadius will be the default.
///
/// #### Example:
///
/// ```dart
///ButtonTooltipWidget(
///  tooltipKey: GlobalKey(),
///  tooltipText: 'This is the button popup widget',
///  height: 52,
///  padding: const EdgeInsets.symmetric(
///    horizontal: 20,
///    vertical: 12,
///  ),
///  title: 'See more info',
///),
///```
class ButtonTooltipWidget extends StatelessWidget {
  final GlobalKey? tooltipKey;
  final String tooltipText;
  final String btnTitle;
  final double height;
  final EdgeInsets padding;

  final Color? backgroundColor;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;

  const ButtonTooltipWidget({
    Key? key,
    required this.tooltipKey,
    required this.tooltipText,
    required this.btnTitle,
    required this.height,
    required this.padding,
    this.backgroundColor,
    this.textStyle,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: tooltipKey != null,
      child: ElevatedButton(
        key: tooltipKey,
        onPressed: () {
          BaloonOverlay popup = BaloonOverlay(
            context: context,
            text: tooltipText,
            textStyle: textStyle ??
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
            height: height,
            backgroundColor: backgroundColor ?? const Color(0xCC3A3A48),
            padding: padding,
            borderRadius: borderRadius ?? BorderRadius.circular(4),
            closeIconColor: Colors.white,
          );
          popup.show(
            widgetKey: tooltipKey!,
          );
        },
        child: Text(
          btnTitle,
        ),
      ),
    );
  }
}
