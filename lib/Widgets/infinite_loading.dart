import 'package:flutter/material.dart';

class InfiniteLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Center(
              child: Text(
            'Obteniendo datos',
            textAlign: TextAlign.center,
          )),
        ),
        Center(child: CircularProgressIndicator())
      ],
    );
  }
}
