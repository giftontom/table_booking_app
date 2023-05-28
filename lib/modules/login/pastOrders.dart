import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import '../../main.dart';
import 'package:http/http.dart' as http;
import '../../controllers/apiController.dart';
import '../../appTheme.dart';
import '../../models/orderListData.dart';
import '../../sharedPreference.dart';
import '../../widgets/customAppBar.dart';

class PastorderScreen extends StatefulWidget {
  @override
  _PastorderScreenState createState() => _PastorderScreenState();
}

class _PastorderScreenState extends State<PastorderScreen>
    with TickerProviderStateMixin {
  final apiController = Get.put(APIController());
  var hotelList;
  AnimationController animationController;

  @override
  void initState() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    hotelList = getPastOrders(apiController.id.value, apiController.key.value);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<OrderListData>> getPastOrders(
      String driverId, String driverKey) async {
    var dataIn = new Map<String, dynamic>();
    dataIn['pageNo'] = 0;
    dataIn['pageSize'] = 400;

    log('api call start >> completed order');
    final response = await http.post(
      Uri.parse(
          'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/getPastOrders/' +
              driverId +
              "/" +
              driverKey),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataIn),
    );

    if (response.statusCode == 200) {
      var tagObjsJson = jsonDecode(response.body)['content'] as List;
      return tagObjsJson
          .map((tagJson) => OrderListData.fromJson(tagJson))
          .toList();
      //return OrderListData.fromJson(jsonDecode(response.body.content));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to load food order');
      log('Could you make sure your network connection is stable.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40, left: 8),
        child: Container(
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.hasData == false) {
                //print('project snapshot data is: ${projectSnap.data}');
                return Container();
              }
              if (snapshot.data.length == 0) {
                animationController.forward();
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                            bottom: 24),
                        child: Text(
                          'No record(s) found',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.8)),
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
                                      hotelList = getPastOrders(
                                          apiController.id.value,
                                          apiController.key.value);
                                    });
                                  },
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                padding: EdgeInsets.only(top: 21, bottom: 16),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  var count = orderList.length > 10 ? 10 : orderList.length;
                  var animation = Tween(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn)));
                  animationController.forward();
                  return HotelListView(
                    callback: () {},
                    hotelData: orderList[index],
                    animation: animation,
                    animationController: animationController,
                    isShowDate: true,
                  );
                },
              );
            },
            future: hotelList,
          ),
        ));
  }
}

class HotelListView extends StatelessWidget {
  final bool isShowDate;
  final VoidCallback callback;
  final OrderListData hotelData;
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
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  child: AspectRatio(
                    aspectRatio: 3.7,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 0.20,
                              child: Container(
                                width: 100,
                                height: 100,
                                color: hotelData.status == 'CANCELLED'
                                    ? Colors.red
                                    : Colors.teal,
                              ),
                            ),
                            AspectRatio(
                              aspectRatio: 0.40,
                              child: Icon(
                                hotelData.status == 'CANCELLED'
                                    ? Icons.cancel_outlined
                                    : Icons.done_all,
                                color: Colors.black,
                                size: 40,
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
                                    Text(
                                      hotelData.id,
                                      maxLines: 2,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      hotelData.storeName +
                                          ',\n' +
                                          hotelData.formatDate,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black.withOpacity(0.8)),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Text(
                                                hotelData.status,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
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
