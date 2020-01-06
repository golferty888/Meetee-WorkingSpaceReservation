import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetee_mobile/components/css.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final int userId;

  HomePage({
    Key key,
    this.userName,
    this.userId,
  }) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _isLargeScreen = false;

  AnimationController _mostBookingController;

  @override
  void initState() {
    _mostBookingController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _mostBookingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.height > 700) {
      setState(() {
        _isLargeScreen = true;
      });
    } else {
      setState(() {
        _isLargeScreen = false;
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        right: false,
        left: false,
        bottom: false,
        child: CustomScrollView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0.0,
              centerTitle: false,
              floating: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.grey[100],
              title: Text(
                '${DateFormat("EEEE d MMMM").format(DateTime.now())}',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: _isLargeScreen ? fontSizeH2[0] : fontSizeH2[1],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16.0,
                  0.0,
                  0.0,
                  16.0,
                ),
                child: Text(
                  'Welcome, ${widget.userName}',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: _isLargeScreen ? fontSizeH1[0] : fontSizeH1[1],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

//            SliverToBoxAdapter(
//              child: Padding(
//                padding: EdgeInsets.only(top: 8.0, bottom: 24),
//                child: Divider(
//                  indent: 16.0,
//                  endIndent: 16.0,
//                  color: Colors.grey[400],
//                ),
//              ),
//            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16.0,
                  0.0,
                  16.0,
                  0.0,
                ),
                child: AnimatedBuilder(
                  animation: _mostBookingController,
                  child: GestureDetector(
                    onTapDown: (d) {
                      _mostBookingController.forward().whenComplete(() {
                        _mostBookingController.reverse();
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 2 / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[500],
                            blurRadius:
                                8.0, // has the effect of softening the shadow
                            spreadRadius:
                                -2, // has the effect of extending the shadow
                            offset: Offset(
                              8.0, // horizontal, move right 10
                              8.0, // vertical, move down 10
                            ),
                          )
                        ],
                        image: DecorationImage(
                          image: AssetImage(
                            'images/single_chair.jpg',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              20.0,
                              0.0,
                              0.0,
                              18.0,
                            ),
                            child: Text(
                              'Most\nBooking',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  builder: (BuildContext context, Widget child) {
                    return Transform.scale(
                      scale: 1 - (0.02 * _mostBookingController.value),
                      child: child,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
