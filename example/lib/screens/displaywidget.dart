// Packages
import 'package:flutter/material.dart';

class DisplayWidget extends StatelessWidget {
  final String title;
  final Widget customwidget;

  const DisplayWidget(
      {super.key, required this.title, required this.customwidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child: customwidget)
    );
  }
}
