import 'package:flutter/material.dart';

class AutomaticKeepAliveScreen extends StatefulWidget {
  const AutomaticKeepAliveScreen({
    super.key,
    required Widget child,
  // ignore: prefer_initializing_formals
  })  : child = child;

  final Widget child;

  @override
  AutomaticKeepAliveScreenState createState() => AutomaticKeepAliveScreenState();
}

class AutomaticKeepAliveScreenState extends State<AutomaticKeepAliveScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.child;
  }
}