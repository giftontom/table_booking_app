import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' show asin, cos, sqrt;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../controllers/apiController.dart';
import '../../appTheme.dart';
import '../../models/orderListData.dart';
import '../hotelDetailes/HotelDetailes.dart';

class FavoritesListView extends StatefulWidget {
  final AnimationController animationController;

  const FavoritesListView({Key key, this.animationController})
      : super(key: key);
  @override
  _FavoritesListViewState createState() => _FavoritesListViewState();
}

class _FavoritesListViewState extends State<FavoritesListView> {
  final apiController = Get.put(APIController());
  var hotelList;

  Timer timer1;

  @override
  void initState() {
    widget.animationController.forward();
    hotelList = getTodayOrders(apiController.id.value, apiController.key.value);
    super.initState();
    timer1 =
        Timer.periodic(Duration(seconds: 5), (Timer t) => fetchTodaysOrder());
  }

  @override
  void dispose() {
    timer1.cancel();
    super.dispose();
  }

  void fetchTodaysOrder() {
    setState(() {
      hotelList =
          getTodayOrders(apiController.id.value, apiController.key.value);
    });
  }

  Future<List<OrderListData>> getTodayOrders(
      String driverId, String driverKey) async {
    var dataIn = new Map<String, dynamic>();
    dataIn['pageNo'] = 0;
    dataIn['pageSize'] = 0;

    log('api (todays) call start >> todays orders');
    final response = await http.post(
      Uri.parse(
          'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/getTodaysOrders/' +
              driverId +
              "/" +
              driverKey),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataIn),
    );

    log('api (todays) call done');

    if (response.statusCode == 200) {
      var tagObjsJson = jsonDecode(response.body)['content'] as List;
      return tagObjsJson
          .map((tagJson) => OrderListData.fromJson(tagJson))
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
            return Container();
          }
          if (snapshot.data.length == 0) {
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
                          fontSize: 21,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.w500),
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
                                  hotelList = getTodayOrders(
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
          List<OrderListData> orderList = snapshot.data ?? [];
          return ListView.builder(
            itemCount: orderList.length,
            padding: EdgeInsets.only(top: 8, bottom: 8),
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
                callback: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HotelDetailes(hotelData: orderList[index]),
                    ),
                  ).then((value) {
                    setState(() {
                      hotelList = getTodayOrders(
                          apiController.id.value, apiController.key.value);
                    });
                  });
                },
                hotelData: orderList[index],
                driverLatitude: 0,
                driverLongitude: 0,
                animation: animation,
                animationController: widget.animationController,
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
  final OrderListData hotelData;
  final double driverLatitude;
  final double driverLongitude;
  final AnimationController animationController;
  final Animation animation;

  String calculateDistance(storeLat, storeLong, myLatitude, myLongitude) {
    if (storeLat == null ||
        storeLat == 0 ||
        myLatitude == null ||
        myLatitude == 0) {
      return "NA";
    }

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((storeLat - myLatitude) * p) / 2 +
        c(myLatitude * p) *
            c(storeLat * p) *
            (1 - c((storeLong - myLongitude) * p)) /
            2;
    return "Store " + (12742 * asin(sqrt(a))).toStringAsFixed(2) + " km";
  }

  const HotelListView(
      {Key key,
      this.hotelData,
      this.driverLatitude,
      this.driverLongitude,
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
              padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.getTheme().backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: AppTheme.getTheme().dividerColor,
                      offset: Offset(4, 4),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  child: AspectRatio(
                    aspectRatio: 3.0,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 0.25,
                              child: Container(
                                width: 100,
                                height: 100,
                                color: Colors.teal,
                              ),
                            ),
                            AspectRatio(
                              aspectRatio: 0.80,
                              child: Icon(
                                hotelData.deliveryStatus == 'DELIVER_ASSIGN'
                                    ? Icons.notifications_active
                                    : hotelData.deliveryStatus ==
                                            'DELIVER_ACCEPT'
                                        ? Icons.check
                                        : hotelData.deliveryStatus ==
                                                'DELIVER_ONTOSTORE'
                                            ? Icons.done_all
                                            : hotelData.deliveryStatus ==
                                                    'DELIVER_REACHEDSTORE'
                                                ? Icons
                                                    .transfer_within_a_station
                                                : hotelData.deliveryStatus ==
                                                        'DELIVER_LEFTSTORE'
                                                    ? Icons.fork_right
                                                    : hotelData.deliveryStatus ==
                                                            'DELIVER_ONTOCLIENT'
                                                        ? Icons.hail
                                                        : Icons.close,
                                color: Colors.black,
                                size: 78,
                              ),
                            ),
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
                                    Flexible(
                                        child: Text(
                                      hotelData.storeName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    )),
                                    Text(
                                      hotelData.id,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Visibility(
                                      visible: true,
                                      child: Flexible(
                                          child: Text(
                                        hotelData.deliveryAddress.addressLine1,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      )),
                                    ),
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
