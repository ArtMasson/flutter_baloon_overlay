import 'package:flutter/material.dart';

import 'triangle_painter.dart';

enum ParentPosition {
  left,
  center,
  right,
}

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
  static double calculateTopOffset({
    required BuildContext context,
    required Rect widgetRect,
    required Size screenSize,
    required double width,
    required double height,
    required double arrowHeight,
  }) {
    double dy = widgetRect.top - height;
    if (dy <= MediaQuery.of(context).padding.top + 50) {
      dy = arrowHeight + widgetRect.height + widgetRect.top;
    } else {
      dy -= arrowHeight;
    }

    return dy;
  }

  /// Returns whether the container has space to be on top of the parent
  static bool isArrowDown({
    required BuildContext context,
    required double arrowHeight,
    required Rect widgetRect,
    required double height,
  }) {
    bool haveEnoughtHeight = false;
    double dy = widgetRect.top - height;

    // not enough space above, show popup under the widget.
    if (dy <= MediaQuery.of(context).padding.top + 50) {
      haveEnoughtHeight = false;
    } else {
      haveEnoughtHeight = true;
    }
    return haveEnoughtHeight;
  }

  /// Returns calculated vertical offset using [context]
  static List<double> calculateVerticalOffset({
    required GlobalKey widgetKey,
    required Rect widgetRect,
    required Size screenSize,
    required bool haveOffsetRight,
    required bool isInCenter,
  }) {
    double offsetLeft, offsetRight;
    RenderBox renderBox =
        widgetKey.currentContext!.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset.zero);
    if (isInCenter) {
      offsetLeft = offset.dx - 7.5;

      offsetRight = screenSize.width - (offset.dx + renderBox.size.width);
    }
    if (haveOffsetRight) {
      offsetLeft = offset.dx / 2;

      offsetRight = screenSize.width - (offset.dx + renderBox.size.width);
    } else {
      offsetLeft = offset.dx;

      offsetRight = 0;
    }

    return [offsetLeft, offsetRight];
  }

  /// Builds popup for specific [offset]
  static Widget buildPopupLayout({
    required BuildContext context,
    required Color backgroundColor,
    required BorderRadius borderRadius,
    required double height,
    required double width,
    required Rect parentRect,
    required bool isArrowDown,
    required double arrowHeight,
    required double offsetTop,
    required double offsetLeft,
    required double offsetRight,
    required ParentPosition position,
    required Function dismiss,
    required EdgeInsetsGeometry padding,
    required String text,
    required TextStyle textStyle,
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
              top: isArrowDown ? offsetTop + height : offsetTop - arrowHeight,
              child: CustomPaint(
                size: Size(15.0, arrowHeight),
                painter: TrianglePainter(
                  isArrowDown: isArrowDown,
                  color: backgroundColor,
                ),
              ),
            ),
            // popup content
            _buildPopup(
              context: context,
              position: position,
              backgroundColor: backgroundColor,
              borderRadius: borderRadius,
              height: height,
              width: width,
              padding: padding,
              text: text,
              textStyle: textStyle,
              offsetTop: offsetTop,
              offsetLeft: offsetLeft,
              offsetRight: offsetRight,
            ),
          ],
        ),
      ),
    );
  }

  static _buildPopup({
    required BuildContext context,
    required Color backgroundColor,
    required BorderRadius borderRadius,
    required EdgeInsetsGeometry padding,
    required double height,
    required double width,
    required String text,
    required TextStyle textStyle,
    required double offsetTop,
    required double offsetLeft,
    required double offsetRight,
    required ParentPosition position,
  }) {
    Padding child;
    switch (position) {
      case ParentPosition.center:
        child = Padding(
          padding: EdgeInsets.only(
            top: offsetTop,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBaloon(
                context: context,
                backgroundColor: backgroundColor,
                borderRadius: borderRadius,
                height: height,
                padding: padding,
                text: text,
                textStyle: textStyle,
                width: width,
              ),
            ],
          ),
        );
        break;
      case ParentPosition.right:
        child = Padding(
          padding: EdgeInsets.only(
            top: offsetTop,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              _buildBaloon(
                context: context,
                backgroundColor: backgroundColor,
                borderRadius: borderRadius,
                height: height,
                padding: padding,
                text: text,
                textStyle: textStyle,
                width: width,
              ),
              Flexible(
                child: SizedBox(
                  width: offsetRight,
                ),
              )
            ],
          ),
        );
        break;
      default:
        child = Padding(
          padding: EdgeInsets.only(
            top: offsetTop,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: SizedBox(
                  width: offsetLeft,
                ),
              ),
              _buildBaloon(
                context: context,
                backgroundColor: backgroundColor,
                borderRadius: borderRadius,
                height: height,
                padding: padding,
                text: text,
                textStyle: textStyle,
                width: width,
              ),
              const Spacer(),
            ],
          ),
        );
        break;
    }
    return child;
  }

  static _buildBaloon({
    required BuildContext context,
    required Color backgroundColor,
    required BorderRadius borderRadius,
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
}
