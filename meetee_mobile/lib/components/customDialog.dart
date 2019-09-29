import 'package:flutter/material.dart';
import 'package:meetee_mobile/pages/history.dart';
import 'package:meetee_mobile/pages/selectFacility.dart';

class CustomDialog extends StatelessWidget {
  final String title, buttonTextLeft, buttonTextRight;
  final int colorCode;

  CustomDialog({
    @required this.colorCode,
    @required this.title,
    @required this.buttonTextLeft,
    @required this.buttonTextRight,
  });

  dialogContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          IconTheme(
            data: IconThemeData(color: Colors.green),
            child: Icon(
              Icons.check_circle_outline,
              size: 112.0,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  borderSide: BorderSide(
                    color: Colors.grey[600],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectFacilityType(),
                      ),
                    );
                  },
                  child: Text(
                    buttonTextLeft,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Flexible(
                child: RaisedButton(
                  elevation: 0.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: Color(colorCode),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryPage(),
                      ),
                    );
                  },
                  child: Text(
                    buttonTextRight,
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }
}
