import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_baloon_overlay/tooltip/overlay/baloon_overlay.dart';

class IconPopupTooltipWidget extends StatelessWidget {
  final GlobalKey? tooltipKey;
  final String tooltipText;
  final Icon icon;
  final double height;
  final EdgeInsets padding;

  const IconPopupTooltipWidget({
    Key? key,
    required this.tooltipKey,
    required this.tooltipText,
    required this.icon,
    required this.height,
    required this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: tooltipKey != null,
      child: GestureDetector(
        key: tooltipKey,
        child: icon,
        onTap: () {
          BaloonOverlay popup = BaloonOverlay(
            context: context,
            text: tooltipText,
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            height: height,
            backgroundColor: const Color(0xCC3A3A48),
            padding: padding,
            borderRadius: BorderRadius.circular(4),
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
