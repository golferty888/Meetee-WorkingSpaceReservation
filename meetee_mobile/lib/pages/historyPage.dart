import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:meetee_mobile/main.dart';
import 'package:meetee_mobile/model/history.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final String historyUrl = 'http://18.139.12.132:9000/user/history';

  @override
  void initState() {
    getHistoryByUserId();
    super.initState();
  }

  HistoriesList historiesList;
//  List historiesList;

  Future<dynamic> getHistoryByUserId() async {
    final response = await http.post(
      historyUrl,
      body: {
        "userId": '1',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = (json.decode(response.body))['data']['historyList'];
      print('get');
      print(jsonData);
      setState(() {
        historiesList = HistoriesList.fromJson(jsonData);
      });

      print(historiesList);
    } else {
      print('400');
      throw Exception('Failed to load post');
    }
  }

  Widget _buildHistory(int index) {
    DateTime now = DateTime.now();
    DateTime startDate =
        DateTime.parse(historiesList.histories[index].startTime).toLocal();
    String formattedStartDate = DateFormat('d MMMM yyyy').format(startDate);
    String formattedStartTime = DateFormat('HH:00:00').format(startDate);

    DateTime endDate =
        DateTime.parse(historiesList.histories[index].endTime).toLocal();
    String formattedEndTime = DateFormat('HH:00:00').format(endDate);
    Duration diffTime = startDate.difference(DateTime.now());
    return Container(
      margin: EdgeInsets.only(
        top: 8.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey[100],
        ),
      ),
      child: ListTile(
        isThreeLine: true,
        leading: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: Text('${historiesList.histories[index].id.toString()}'),
        ),
        title:
            Text('facId: ${historiesList.histories[index].facId.toString()}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('$formattedStartDate'),
            Text('$formattedStartTime - $formattedEndTime'),
          ],
        ),
        trailing: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          child: Text(
            historiesList.histories[index].status,
            style: TextStyle(
                color: historiesList.histories[index].status == 'Booked'
                    ? Colors.green
                    : Colors.red),
          ),
        ),
//        trailing: Text(
//            '${diffTime.inHours}:${diffTime.inMinutes}:${diffTime.inMilliseconds}'),
//        trailing: Text('${now}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
          },
        ),
        title: Text(
          'History',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
//          color: Color(widget.colorCode),
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(
              'images/noise.png',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:
                  historiesList == null ? 0 : historiesList.histories.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildHistory(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
