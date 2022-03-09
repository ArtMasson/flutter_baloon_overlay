import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_baloon_overlay/tooltip/overlay/baloon_overlay.dart';

class IconPopupTooltipWidget extends StatelessWidget {
  final GlobalKey? tooltipKey;
  final String tooltipText;
  final Icon icon;
  final double height;
  final EdgeInsets padding;

  final Color? backgroundColor;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;

  const IconPopupTooltipWidget({
    Key? key,
    required this.tooltipKey,
    required this.tooltipText,
    required this.icon,
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
      child: MaterialButton(
        padding: const EdgeInsets.all(0),
        minWidth: 0,
        key: tooltipKey,
        child: icon,
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
      ),
    );
  }
}
