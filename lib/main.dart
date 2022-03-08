import 'package:flutter/material.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconPopupTooltipWidget(
              tooltipKey: GlobalKey(),
              tooltipText:
                  'Just 1 baby per adult is possible (carrying on the lap).\nFor more than 1, please contact us.',
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
            Align(
              alignment: Alignment.centerLeft,
              child: IconPopupTooltipWidget(
                tooltipKey: GlobalKey(),
                tooltipText:
                    'Crianças não podem viajar sem um adulto.\nPara exceções, entre em contato conosco.',
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
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconPopupTooltipWidget(
                tooltipKey: GlobalKey(),
                tooltipText:
                    'Só é possível reservar voo para o máximo de 9 passageiros',
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
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconPopupTooltipWidget(
                tooltipKey: GlobalKey(),
                tooltipText: 'Voo de volta',
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 200),
                    child: IconPopupTooltipWidget(
                      tooltipKey: GlobalKey(),
                      tooltipText: 'Bem no lado',
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
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 200),
                    child: IconPopupTooltipWidget(
                      tooltipKey: GlobalKey(),
                      tooltipText: 'Bem no lado',
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
                  ),
                ),
              ],
            ),
            IconPopupTooltipWidget(
              tooltipKey: GlobalKey(),
              tooltipText: 'Voo de ida',
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
      ),
    );
  }
}
