import 'package:flutter/material.dart';

class Summary extends StatefulWidget {
  final int colorCode;

  Summary({
    Key key,
    @required this.colorCode,
  }) : super(key: key);
  @override
  _SummaryState createState() => _SummaryState();
}

class _SummaryState extends State<Summary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          //`true` if you want Flutter to automatically add Back Button when needed,
          //or `false` if you want to force your own back button every where
          title: Text('Summary'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Container(
        color: Color(widget.colorCode),
        child: Center(
          child: Text(
            "Sumaary page",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
