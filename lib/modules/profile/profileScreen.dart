import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:cleanup_worker/modules/login/pastOrders.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../controllers/apiController.dart';
import '../../appTheme.dart';
import '../../main.dart';
import '../../models/settingListData.dart';
import '../../models/profileData.dart';
import '../../modules/login/changepassword.dart';
import '../../modules/profile/editProfile.dart';

import '../../sharedPreference.dart';

class ProfileScreen extends StatefulWidget {
  final AnimationController animationController;

  const ProfileScreen({Key key, this.animationController}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final apiController = Get.put(APIController());
  Future<ProfileData> profileDataResponse;
  List<SettingsListData> userSettingsList = SettingsListData.userSettingsList;

  @override
  void initState() {
    widget.animationController.forward();

    profileDataResponse =
        getDriverInfo(apiController.id.value, apiController.key.value);
    super.initState();
  }

  Future<ProfileData> getDriverInfo(String id, String key) async {
    log('api call start');
    String url =
        'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/driverDetails/' +
            id +
            "/" +
            key;
    final response = await http.get(Uri.parse(url));

    log('api call done');

    if (response.statusCode == 200) {
      var responseProfileData = ProfileData.fromJson(jsonDecode(response.body));
      !responseProfileData.notify
          ? MyApp.stopLocationTracker(context)
          : MyApp.startLocationTracker(context);

      return responseProfileData;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to load food order');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to fetch from the server'),
        duration: Duration(seconds: 7),
      ));
      return null;
    }
  }

  Future<String> updateNotifyStatus(String driverId, String driverKey) async {
    log('api call start >> notify');
    final response = await http.get(Uri.parse(
        'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/turnNotification/' +
            driverId +
            '/' +
            driverKey));

    log('update api call done');

    if (response.statusCode == 200) {
      return 'worked';
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to load food order');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to update the server'),
        duration: Duration(seconds: 7),
      ));
      return null;
    }
  }

  Future<String> logout(String driverId, String driverKey) async {
    log('api call start >> logout');
    final response = await http.get(Uri.parse(
        'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/logout/' +
            driverId +
            '/' +
            driverKey));

    log('update api call done');

    if (response.statusCode == 200) {
      return 'worked';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to update the server'),
        duration: Duration(seconds: 7),
      ));
      return 'not worked';
    }
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
            child: Scaffold(
              backgroundColor: AppTheme.getTheme().backgroundColor,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: Container(child: appBar()),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.all(0.0),
                      itemCount: userSettingsList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            if (index == 3) {
                              logout(apiController.id.value,
                                      apiController.key.value)
                                  .then((String dataOut) {
                                if (dataOut != null) {
                                  apiController.id.value = '';
                                  apiController.key.value = '';
                                  apiController.fcmToken.value = '';

                                  SharedPreference.removeClientInfo();
                                  MyApp.restartApp(context);
                                }
                              });
                            }
                            if (index == 2) {
                              updateNotifyStatus(apiController.id.value,
                                      apiController.key.value)
                                  .then((String dataOut) {
                                setState(() {
                                  profileDataResponse = getDriverInfo(
                                      apiController.id.value,
                                      apiController.key.value);
                                });
                              });
                            }
                            if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangepasswordScreen(),
                                  fullscreenDialog: true,
                                ),
                              );
                            }
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PastorderScreen(),
                                  fullscreenDialog: true,
                                ),
                              );
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Visibility(
                                visible: index == 2,
                                child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1.0,
                                                color: Colors.black12))),
                                    child: FutureBuilder<ProfileData>(
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.none ||
                                            snapshot.hasData == false ||
                                            (snapshot.hasData == true &&
                                                snapshot.data.notify ==
                                                    false)) {
                                          return Row(children: <Widget>[
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Text(
                                                  "Go online",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Container(
                                                    child: Icon(
                                                  FontAwesomeIcons.bellSlash,
                                                  color: AppTheme.getTheme()
                                                      .disabledColor,
                                                )))
                                          ]);
                                        }

                                        return Row(children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Text(
                                                "Go offline",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Container(
                                                  child: Icon(
                                                FontAwesomeIcons.solidBell,
                                                color: AppTheme.getTheme()
                                                    .primaryColor,
                                              )))
                                        ]);
                                      },
                                      future: profileDataResponse,
                                    )),
                              ),
                              Visibility(
                                  visible: index != 2,
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 1.0,
                                                color: Colors.black12))),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              userSettingsList[index].titleTxt,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Container(
                                            child: Icon(
                                                userSettingsList[index]
                                                    .iconData,
                                                color: AppTheme.getTheme()
                                                    .primaryColor),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget appBar() {
    return InkWell(
      onTap: () {
        profileDataResponse.then((ProfileData dataOut) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfile(profiledo: dataOut),
              fullscreenDialog: true,
            ),
          );
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: FutureBuilder<ProfileData>(
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none ||
                      snapshot.hasData == false) {
                    //print('project snapshot data is: ${projectSnap.data}');
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Loading ...",
                          style: new TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "View profile",
                          style: new TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    );
                  }
                  // if success
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        snapshot.data.firstName,
                        style: new TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "View profile",
                        style: new TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  );
                },
                future: profileDataResponse,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24, top: 16, bottom: 16),
            child: Container(
              width: 70,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                child: Image.asset("assets/images/profile.png"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
