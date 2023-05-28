import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/apiController.dart';
import 'introductionScreen.dart';
import 'appTheme.dart';
import 'main.dart';
import 'sharedPreference.dart';

import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final apiController = Get.put(APIController());

  @override
  void initState() {
    handleSession();
    super.initState();
  }

  handleSession() async {
    bool isLoggedIn = await SharedPreference.isLoggedIn();
    if (isLoggedIn) {
      String clientId = await SharedPreference.getClientId();
      String clientKey = await SharedPreference.getClientKey();

      apiController.id.value = clientId;
      apiController.key.value = clientKey;

      updateToken(clientId, clientKey, apiController.fcmToken.value);

      Navigator.pushNamedAndRemoveUntil(
          context, Routes.TabScreen, (Route<dynamic> route) => false);
    }
  }

  Future<String> updateToken(
      String driverId, String driverKey, String fcmToken) async {
    var deviceType = 'iOS';
    if (Platform.isAndroid) {
      deviceType = 'android';
    }
    var deviceInfo = new Map<String, dynamic>();
    deviceInfo['deviceToken'] = fcmToken;
    deviceInfo['deviceType'] = deviceType;

    log('api call start >> update device token');

    final response = await http.post(
      Uri.parse(
          'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/addMobileDeviceData/' +
              driverId +
              "/" +
              driverKey),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(deviceInfo),
    );

    log('api call done');

    if (response.statusCode == 200) {
      return 'worked';
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to load food order');
      log('Failed to update token');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              foregroundDecoration: !AppTheme.isLightTheme
                  ? BoxDecoration(
                      color:
                          AppTheme.getTheme().backgroundColor.withOpacity(0.4))
                  : null,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Center(
                  child: Container(
                    width: 240,
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    )),
                    child: ClipRRect(
                      child: Image.asset('assets/images/appIcon.jpg'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Clean up",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  "App",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 48, right: 48, bottom: 8, top: 8),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.getTheme().primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(24.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppTheme.getTheme().dividerColor,
                          blurRadius: 8,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(24.0)),
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IntroductionScreen()),
                          );
                        },
                        child: Center(
                          child: Text(
                            "Get started",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 24.0 + MediaQuery.of(context).padding.bottom,
                      top: 16),
                  child: Text(
                    "",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
