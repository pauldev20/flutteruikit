// Packages
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Screens
import 'screens/displaywidget.dart';

// Library
import 'package:flutteruikit/flutteruikit.dart';


void main() {
  runApp(const MyApp());
}

class WidgetListTile extends StatelessWidget {
  final Widget widget;

  const WidgetListTile({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.toString()),
      leading: const Icon(Icons.widgets_outlined, size: 30),
      trailing: const Icon(Icons.chevron_right, size: 32),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DisplayWidget(
            title: widget.toString(),
            customwidget: widget,
          ))
        );
      },
    );
  }
}

class ScreenListTile extends StatelessWidget {
  final Widget screen;

  const ScreenListTile({super.key, required this.screen});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(screen.toString()),
      leading: const Icon(Icons.widgets_outlined, size: 30),
      trailing: const Icon(Icons.chevron_right, size: 32),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen)
        );
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BuildContext? buildcontext;
  String _platformVersion = 'Unknown';
  final _flutteruikitPlugin = Flutteruikit();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion =
          await _flutteruikitPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    buildcontext = context;

    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green
        ),
        useMaterial3: true
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: FractionallySizedBox(
            heightFactor: 1.0,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Running on: $_platformVersion\n')],
                ),
                const WidgetListTile(
                  widget: IcnButton(
                    icondata: Icons.abc,
                    size: 60,
                  )
                ),
                const WidgetListTile(
                  widget: LinkButton(
                    labelText: "CustomLinkButton",
                  )
                ),
                ScreenListTile(
                  screen: BarcodeScannerScreen(
                    onScan: (barcode) {
                      print(barcode);
                    },
                  )
                )
              ],
            ),
          )
        ),
      )
    );
  }
}
