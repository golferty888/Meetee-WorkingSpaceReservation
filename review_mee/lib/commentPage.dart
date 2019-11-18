import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  _buildComment(String comment) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () {
          Navigator.pop(context, comment);
        },
        color: Colors.orange,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Text(
            comment,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 48),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.black,
                iconSize: 60,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.black,
                iconSize: 60,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.black,
                iconSize: 60,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.black,
                iconSize: 60,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 600,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildComment('Slow performance'),
                  _buildComment('Testing needed'),
                  _buildComment('Bad ideas'),
                  _buildComment('Nope, I just love orange.'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
