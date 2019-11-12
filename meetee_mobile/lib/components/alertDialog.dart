import 'package:flutter/material.dart';

class BuildAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String actionLeft;
  final String actionRight;

  BuildAlertDialog({
    Key key,
    @required this.title,
    this.content,
    this.actionLeft,
    this.actionRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          onPressed: () {},
          child: Text(
            actionLeft,
          ),
        ),
        FlatButton(
          onPressed: () {},
          child: Text(
            actionRight,
          ),
        ),
      ],
    );
  }
}
