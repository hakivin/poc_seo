import 'package:flutter/material.dart';

class WidgetWrapper extends StatelessWidget {
  final Widget child;

  const WidgetWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.3,
        maxHeight: MediaQuery.sizeOf(context).height,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: child,
      ),
    );
  }
}
