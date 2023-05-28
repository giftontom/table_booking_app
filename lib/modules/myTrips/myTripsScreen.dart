import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cleanup_worker/controllers/apiController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../appTheme.dart';
import '../myTrips/favoritesListView.dart';
import '../myTrips/finishTripView.dart';
import '../../models/authData.dart';

class MyTripsScreen extends StatefulWidget {
  final AnimationController animationController;
  final AuthData authData;

  const MyTripsScreen({Key key, this.animationController, this.authData})
      : super(key: key);
  @override
  _MyTripsScreenState createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen>
    with TickerProviderStateMixin {
  final apiController = Get.put(APIController());
  AnimationController tabAnimationController;

  Widget indexView = Container();
  TopBarType topBarType = TopBarType.Favorites;

  @override
  void initState() {
    tabAnimationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    indexView = FavoritesListView(
      animationController: tabAnimationController,
    );
    tabAnimationController..forward();
    widget.animationController.forward();

    super.initState();
  }

  Future<bool> reportApi(String message) async {
    String driverId = apiController.id.value;
    String driverKey = apiController.key.value;

    var minDataInfo = new Map<String, dynamic>();
    minDataInfo['description'] = message;

    log('api call start >> log data');
    final response = await http.post(
      Uri.parse(
          'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/addLoggerData/' +
              driverId +
              "/" +
              driverKey),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(minDataInfo),
    );
    log('api log data call done');

    if (response.statusCode == 200) {
      log('log data sent was successful');
      return null;
    }

    return false;
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    tabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animationController,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 40 * (1.0 - widget.animationController.value), 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Container(child: appBar()),
                ),
                tabViewUI(topBarType),
                Expanded(
                  child: indexView,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void tabClick(TopBarType tabType) {
    if (tabType != topBarType) {
      topBarType = tabType;
      tabAnimationController.reverse().then((f) {
        if (tabType == TopBarType.Favorites) {
          setState(() {
            indexView = FavoritesListView(
              animationController: tabAnimationController,
            );
          });
        } else if (tabType == TopBarType.Finished) {
          setState(() {
            indexView = FinishTripView(
              animationController: tabAnimationController,
            );
          });
        }
      });
    }
  }

  Widget tabViewUI(TopBarType tabType) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          color: AppTheme.getTheme().dividerColor.withOpacity(0.05),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      highlightColor: Colors.transparent,
                      splashColor:
                          AppTheme.getTheme().primaryColor.withOpacity(0.2),
                      onTap: () {
                        tabClick(TopBarType.Favorites);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16, top: 16),
                        child: Center(
                          child: Text(
                            "Active",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: tabType == TopBarType.Favorites
                                    ? AppTheme.getTheme().primaryColor
                                    : AppTheme.getTheme().disabledColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                      highlightColor: Colors.transparent,
                      splashColor:
                          AppTheme.getTheme().primaryColor.withOpacity(0.2),
                      onTap: () {
                        tabClick(TopBarType.Finished);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16, top: 16),
                        child: Center(
                          child: Text(
                            "Messages",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: tabType == TopBarType.Finished
                                    ? AppTheme.getTheme().primaryColor
                                    : AppTheme.getTheme().disabledColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 24 + 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Tasks",
            style: new TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

enum TopBarType {
  Favorites,
  Upcomming,
  Finished,
}
