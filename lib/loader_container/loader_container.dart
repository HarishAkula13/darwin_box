import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'loader_indicator.dart';

class LoaderContainer extends StatelessWidget {
  final Stream<bool>? stream;
  final initialValue;
  final child;

  LoaderContainer({this.stream, this.initialValue = false, this.child});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: stream,
      initialData: initialValue,
      builder: (c, s) {
        return Stack(
          children: <Widget>[
            if (child != null) ...[child],
            Positioned.fill(child: _getIndicator(s.data ?? false))
          ],
        );
      },
    );
  }

  _getIndicator(bool isLoading) {
    if (isLoading) {
      return Container(
        color: Colors.red,
        child: Center(
          child: LoaderIndicator(),
        ),
      );
    } else {
      return Container();
    }
  }
}