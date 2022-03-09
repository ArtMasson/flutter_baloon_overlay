import 'package:flutter/material.dart';
import 'package:flutter_baloon_overlay/tooltip/button_tooltip_widget.dart';

import 'tooltip/icon_tooltip_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baloon Overlay Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Baloon Overlay Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconPopupTooltipWidget(
                    tooltipKey: GlobalKey(),
                    tooltipText:
                        'This container will adjust the text size according to text lenght',
                    height: 52,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color: Colors.blue.shade500,
                      size: 26,
                    ),
                  ),
                  IconPopupTooltipWidget(
                    tooltipKey: GlobalKey(),
                    tooltipText: 'This is the medium text',
                    height: 52,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color: Colors.blue.shade500,
                      size: 26,
                    ),
                  ),
                  IconPopupTooltipWidget(
                    tooltipKey: GlobalKey(),
                    tooltipText: 'Mini text',
                    height: 52,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color: Colors.blue.shade500,
                      size: 26,
                    ),
                  ),
                ],
              ),
              ButtonTooltipWidget(
                tooltipKey: GlobalKey(),
                tooltipText: 'This is the button popup widget',
                height: 52,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                title: 'See more info',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
