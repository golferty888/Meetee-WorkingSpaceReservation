import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:meetee_mobile/components/css.dart';
import 'package:meetee_mobile/model/facilityType.dart';
import 'package:meetee_mobile/pages/customerDemandPage.dart';
import 'package:meetee_mobile/pages/selectFacility.dart';

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

class _HomePageState extends State<HomePage> {
  bool _isLargeScreen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List _menuItems = [
    [
      '/facilityType',
      Icons.airline_seat_recline_normal,
      'Book now',
    ],
    [
      '/facilityType',
      Icons.star,
      'Featured',
    ],
    [
      '/facilityType',
      Icons.assistant_photo,
      'Promotion',
    ],
  ];

  _buildItem(String path, IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: RouteSettings(name: path),
            builder: (context) {
              return SelectFacilityType(
                userId: widget.userId,
                isLargeScreen: _isLargeScreen,
              );
            },
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildRecommendCard(int type, int index, String imageUrl, String headTitle,
      String title, String subtitle) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16.0,
        0.0,
        16.0,
        0.0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: RouteSettings(name: '/customerDemand'),
              builder: (context) {
                return CustomerDemandPage(
                  userId: widget.userId,
                  facilityType: facilityTypeList[type],
                  index: index,
                  subType: type == 0 ? 'Seat' : 'Room',
                  isLargeScreen: _isLargeScreen,
                );
              },
            ),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 3 / 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[500],
                blurRadius: 8.0, // has the effect of softening the shadow
                spreadRadius: -2, // has the effect of extending the shadow
                offset: Offset(
                  8.0, // horizontal, move right 10
                  8.0, // vertical, move down 10
                ),
              )
            ],
//            image: DecorationImage(
//              image: NetworkImage(
//                imageUrl,
//              ),
//              fit: BoxFit.fitWidth,
//            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16.0),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fitWidth,
                    loadingBuilder: (context, child, progress) {
                      return progress == null
                          ? child
                          : Container(
                              color: Colors.grey[50],
                            );
                    },
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      headTitle.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      20.0,
                      12.0,
                      20.0,
                      16.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black87.withOpacity(0.8),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(18.0),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(4.0),
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            color: Color(
                                facilityTypeList[type].secondaryColorCode),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),
                          child: SvgPicture.asset(
                            facilityTypeList[type].imagePath,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                child: Text(
                                  subtitle,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: _isLargeScreen
                                        ? fontSizeH3[0]
                                        : fontSizeH3[1],
//                        fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
      backgroundColor: Colors.grey[50],
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
              backgroundColor: Colors.grey[50],
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
            SliverToBoxAdapter(
              child: Container(
                height: 48.0,
                padding: EdgeInsets.only(left: 16.0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    return _buildItem(
                      _menuItems[index][0],
                      _menuItems[index][1],
                      _menuItems[index][2],
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8),
                child: Divider(
                  indent: 16.0,
                  endIndent: 16.0,
                  color: Colors.grey[400],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: _buildRecommendCard(
                  0,
                  0,
                  'https://storage.googleapis.com/meetee-file-storage/img/fac/single-chair.jpg',
                  'Most\nBooking',
                  'Single Chair',
                  'Just a simple seat you looking for.',
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: _buildRecommendCard(
                  1,
                  1,
                  'https://storage.googleapis.com/meetee-file-storage/img/fac/meet-m.jpg',
                  'Work!\nWork!\nTogether',
                  'Meeting Room',
                  'Cooperate in individual room.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
