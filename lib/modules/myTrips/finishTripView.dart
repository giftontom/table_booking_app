import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../controllers/apiController.dart';
import '../../models/msgListData.dart';
import '../../appTheme.dart';

class FinishTripView extends StatefulWidget {
  final AnimationController animationController;

  const FinishTripView({Key key, this.animationController}) : super(key: key);

  @override
  _FinishTripViewState createState() => _FinishTripViewState();
}

class _FinishTripViewState extends State<FinishTripView> {
  final apiController = Get.put(APIController());
  var hotelList;
  Timer timer1;

  @override
  void initState() {
    widget.animationController.forward();
    hotelList = getMessages(apiController.id.value, apiController.key.value);

    super.initState();
    timer1 =
        Timer.periodic(Duration(seconds: 10), (Timer t) => fetchMessages());
  }

  void fetchMessages() {
    setState(() {
      hotelList = getMessages(apiController.id.value, apiController.key.value);
    });
  }

  @override
  void dispose() {
    timer1.cancel();
    super.dispose();
  }

  Future<List<MsgListData>> getMessages(
      String driverId, String driverKey) async {
    var dataIn = new Map<String, dynamic>();
    dataIn['pageNo'] = 0;
    dataIn['pageSize'] = 0;

    log('api call start >> messages');
    final response = await http.post(
      Uri.parse(
          'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/getMessages/' +
              driverId +
              "/" +
              driverKey),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataIn),
    );

    log('api call done');

    if (response.statusCode == 200) {
      var tagObjsJson = jsonDecode(response.body)['content'] as List;
      return tagObjsJson
          .map((tagJson) => MsgListData.fromJson(tagJson))
          .toList();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to fetch from the server'),
        duration: Duration(seconds: 7),
      ));
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.hasData == false) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container();
          }
          if (snapshot.data.length == 0) {
            //print('project snapshot data is: ${projectSnap.data}');
            widget.animationController.forward();
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top, bottom: 24),
                    child: Text(
                      'No record(s) found',
                      style: TextStyle(
                          fontSize: 21, color: Colors.black.withOpacity(0.8)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.getTheme().primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: AppTheme.getTheme().dividerColor,
                                  offset: Offset(4, 4),
                                  blurRadius: 8.0),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  hotelList = getMessages(
                                      apiController.id.value,
                                      apiController.key.value);
                                });
                              },
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.refresh_outlined,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'Refresh',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ]);
          }
          List<MsgListData> orderList = snapshot.data ?? [];
          return ListView.builder(
            itemCount: orderList.length,
            padding: EdgeInsets.only(top: 8, bottom: 16),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var count = orderList.length > 10 ? 10 : orderList.length;
              var animation = Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn)));
              widget.animationController.forward();
              return HotelListView(
                callback: () {},
                hotelData: orderList[index],
                animation: animation,
                animationController: widget.animationController,
                isShowDate: true,
              );
            },
          );
        },
        future: hotelList,
      ),
    );
  }
}

class HotelListView extends StatelessWidget {
  final bool isShowDate;
  final VoidCallback callback;
  final MsgListData hotelData;
  final AnimationController animationController;
  final Animation animation;

  const HotelListView(
      {Key key,
      this.hotelData,
      this.animationController,
      this.animation,
      this.callback,
      this.isShowDate: false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 1, bottom: 3),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color.fromRGBO(228, 242, 240, 1)),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: AspectRatio(
                    aspectRatio: 4.0,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width >= 360
                                        ? 12
                                        : 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(hotelData.orderId,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        )),
                                    Flexible(
                                        child: Text(
                                      hotelData.message,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black.withOpacity(0.8)),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: AppTheme.getTheme()
                                .primaryColor
                                .withOpacity(0.1),
                            onTap: () {
                              try {
                                callback();
                              } catch (e) {}
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
