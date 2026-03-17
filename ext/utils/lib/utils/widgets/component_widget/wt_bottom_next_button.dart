import 'package:flutter/material.dart';

class WtBottomNavigationBar extends StatelessWidget {
  const WtBottomNavigationBar({Key? key, required this.child, this.content}) : super(key: key);
  final Widget child;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (content != null) ...[
              content!,
              const Padding(padding: EdgeInsets.only(bottom: 16)),
            ],
            child,
          ],
        ),
      ),
    );
  }
}
