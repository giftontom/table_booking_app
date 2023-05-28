import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../controllers/apiController.dart';
import '../../appTheme.dart';
import '../../models/orderListData.dart';
import '../explore/titleView.dart';
import '../hotelDetailes/hotelDetailes.dart';
import '../../models/authData.dart';
import '../myTrips/favoritesListView.dart';

class HomeExploreScreen extends StatefulWidget {
  final AnimationController animationController;
  final AuthData authData;

  const HomeExploreScreen({Key key, this.animationController, this.authData})
      : super(key: key);
  @override
  _HomeExploreScreenState createState() => _HomeExploreScreenState();
}

class _HomeExploreScreenState extends State<HomeExploreScreen>
    with TickerProviderStateMixin {
  final apiController = Get.put(APIController());
  var hotelList;
  ScrollController controller;
  AnimationController _animationController;
  var sliderImageHieght = 0.0;
  @override
  void initState() {
    hotelList = getTodayOrder(apiController.id.value, apiController.key.value);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    widget.animationController.forward();
    controller = ScrollController(initialScrollOffset: 0.0);

    controller.addListener(() {
      if (context != null) {
        if (controller.offset < 0) {
          // we static set the just below half scrolling values
          _animationController.animateTo(0.0);
        } else if (controller.offset > 0.0 &&
            controller.offset < sliderImageHieght) {
          // we need around half scrolling values
          if (controller.offset < ((sliderImageHieght / 1.5))) {
            _animationController
                .animateTo((controller.offset / sliderImageHieght));
          } else {
            // we static set the just above half scrolling values "around == 0.64"
            _animationController
                .animateTo((sliderImageHieght / 1.5) / sliderImageHieght);
          }
        }
      }
    });
    super.initState();
  }

  Future<List<OrderListData>> getTodayOrder(
      String driverId, String driverKey) async {
    var dataIn = new Map<String, dynamic>();
    dataIn['pageNo'] = 0;
    dataIn['pageSize'] = 0;

    log('api call start');
    final response = await http.post(
      Uri.parse('https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/getTodaysOrders/' +
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
          .map((tagJson) => OrderListData.fromJson(tagJson))
          .toList();
      //return OrderListData.fromJson(jsonDecode(response.body.content));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to load food order');
      showMyDialog();
      return null;
    }
  }

  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Oops! Error!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Something went wrong!'),
                Text(
                    'Could you make sure your mobile number and password matches'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    sliderImageHieght = MediaQuery.of(context).size.width * 1.3;
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animationController,
          // FadeTransition and Transform : just for screen loading animation on fistTime
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 40 * (1.0 - widget.animationController.value), 0.0),
            child: Scaffold(
              backgroundColor: AppTheme.getTheme().backgroundColor,
              body: Stack(
                children: <Widget>[
                  Container(
                    color: AppTheme.getTheme().backgroundColor,
                    child: ListView.builder(
                      controller: controller,
                      itemCount: 4,
                      // padding on top is only for we need spec for sider
                      padding: EdgeInsets.only(top: 64, bottom: 16),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        // some list UI
                        var count = 4;
                        var animation = Tween(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                            parent: widget.animationController,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn),
                          ),
                        );
                        if (index == 0) {
                          return TitleView(
                            titleTxt: 'Terms',
                            animation: animation,
                            isLeftButton: false,
                            animationController: widget.animationController,
                          );
                        } else {
                          return getDealListView(index);
                        }
                      },
                    ),
                  ),
                  // sliderUI with 3 images are moving
                  //_sliderUI(),

                  // viewHotels Button UI for click event
                  //_viewHotelsButton(_animationController),

                  //just gradient for see the time and battry Icon on "TopBar"
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          AppTheme.getTheme().backgroundColor.withOpacity(0.4),
                          AppTheme.getTheme().backgroundColor.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getDealListView(int index) {
    var hotelListData =
        getTodayOrder(apiController.id.value, apiController.key.value);
    List<Widget> list = List<Widget>();
    hotelListData.then((List<OrderListData> hotelList) {
      hotelList.forEach((f) {
        var animation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn),
          ),
        );
        list.add(
          HotelListView(
            callback: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HotelDetailes(
                          hotelData: f,
                        ),
                    fullscreenDialog: true),
              );
            },
            hotelData: f,
            animation: animation,
            animationController: widget.animationController,
          ),
        );
      });
    });

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: list,
      ),
    );
  }
}
