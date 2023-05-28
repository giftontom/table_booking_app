import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../controllers/apiController.dart';
import 'package:http/http.dart' as http;
import '../../appTheme.dart';
import '../../sharedPreference.dart';
import '../login/forgotPassword.dart';
import '../../models/authData.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final apiController = Get.put(APIController());
  final TextEditingController phoneNumberController =
      new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  _launchURL() async {
    const url = 'https://admin.deliverydeals.com/register';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchURLToTerms() async {
    const url = 'https://admin.deliverydeals.com/privacy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        // backgroundColor: AppTheme.getTheme().backgroundColor,
        body: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: appBar(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "Welcome! Aloha",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.getTheme().backgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(38)),
                            // border: Border.all(
                            //   color: HexColor("#757575").withOpacity(0.6),
                            // ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppTheme.getTheme().dividerColor,
                                blurRadius: 8,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Container(
                              height: 48,
                              child: Center(
                                child: TextField(
                                  maxLines: 1,
                                  onChanged: (String txt) {},
                                  style: TextStyle(
                                    fontSize: 16,
                                    // color: AppTheme.dark_grey,
                                  ),
                                  cursorColor: AppTheme.getTheme().primaryColor,
                                  decoration: new InputDecoration(
                                    errorText: null,
                                    border: InputBorder.none,
                                    hintText: "Your mobile number",
                                    hintStyle: TextStyle(
                                        color:
                                            AppTheme.getTheme().disabledColor),
                                  ),
                                  controller: phoneNumberController,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.getTheme().backgroundColor,
                            borderRadius: BorderRadius.all(Radius.circular(38)),
                            // border: Border.all(
                            //   color: HexColor("#757575").withOpacity(0.6),
                            // ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppTheme.getTheme().dividerColor,
                                blurRadius: 8,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Container(
                              height: 48,
                              child: Center(
                                child: TextField(
                                  maxLines: 1,
                                  obscureText: true,
                                  onChanged: (String txt) {},
                                  style: TextStyle(
                                    fontSize: 16,
                                    // color: AppTheme.dark_grey,
                                  ),
                                  cursorColor: AppTheme.getTheme().primaryColor,
                                  decoration: new InputDecoration(
                                    errorText: null,
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        color:
                                            AppTheme.getTheme().disabledColor),
                                  ),
                                  controller: passwordController,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8, right: 16, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Forgot your password?",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8, left: 16, right: 16, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              onTap: () {
                                _launchURLToTerms();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text.rich(
                                  TextSpan(
                                    text:
                                        'By Logging in our App, you accept our ',
                                    style: TextStyle(fontSize: 14),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '\n Terms & Conditions',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                          )),
                                      TextSpan(
                                          text: ' And Privacy policy',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 8, top: 8),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.getTheme().primaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(24.0)),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                              highlightColor: Colors.transparent,
                              onTap: () {
                                // Validate returns true if the form is valid, otherwise false.
                                validateAuth(phoneNumberController.text,
                                        passwordController.text)
                                    .then((AuthData dataOut) {
                                  if (dataOut != null &&
                                      dataOut.id != '' &&
                                      dataOut.key != '') {
                                    apiController.id.value = dataOut.id;
                                    apiController.key.value = dataOut.key;

                                    SharedPreference.setClientId(dataOut.id);
                                    SharedPreference.setClientKey(dataOut.key);

                                    updateToken(dataOut.id, dataOut.key);

                                    MyApp.startLocationTracker(context);

                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        Routes.TabScreen,
                                        (Route<dynamic> route) => false);
                                  }
                                });
                              },
                              child: Center(
                                child: Text(
                                  "Log me in",
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
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getFTButton({bool isFacebook: true}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: HexColor(isFacebook ? "#3C5799" : "#05A9F0"),
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
          onTap: () {},
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                    isFacebook
                        ? FontAwesomeIcons.facebookF
                        : FontAwesomeIcons.google,
                    size: 20,
                    color: Colors.white),
                SizedBox(
                  width: 4,
                ),
                Text(
                  isFacebook ? "Facebook" : "Google",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> updateToken(String driverId, String driverKey) async {
    var deviceType = 'iOS';
    if (Platform.isAndroid) {
      deviceType = 'android';
    }
    await Firebase.initializeApp();
    FirebaseMessaging _fcm = FirebaseMessaging.instance;
    await _fcm.requestPermission(sound: true, alert: true, badge: true);
    String fcmToken = await _fcm.getToken();
    log("FirebaseMessaging token: $fcmToken");

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
      normalDialog('Failed to update token', true);
      return null;
    }
  }

  Future<AuthData> validateAuth(String phone, String password) async {
    var dataIn = new Map<String, dynamic>();
    dataIn['phoneNumber'] = phone.trim();
    dataIn['password'] = password.trim();

    log('api call start');
    final response = await http.post(
      Uri.parse(
          'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/validateAuth'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataIn),
    );

    log('api call done');

    if (response.statusCode == 200) {
      return AuthData.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to load food order');
      normalDialog(
          'Could you make sure your mobile number and password matches', true);
      return null;
    }
  }

  Future<void> normalDialog(String displayText, bool showError) async {
    return AwesomeDialog(
      context: context,
      dialogType: showError ? DialogType.ERROR : DialogType.SUCCES,
      borderSide: BorderSide(color: Colors.green, width: 2),
      width: MediaQuery.of(context).size.width,
      buttonsBorderRadius: BorderRadius.all(Radius.circular(4)),
      headerAnimationLoop: false,
      animType: AnimType.BOTTOMSLIDE,
      title: showError ? 'Oops!' : 'Hurray!',
      desc: displayText,
      showCloseIcon: true,
      btnOkOnPress: () {},
      btnOkIcon: Icons.check_circle,
    )..show();
  }

  Widget appBar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
            height: AppBar().preferredSize.height,
            child: Padding(
                padding: EdgeInsets.only(top: 8, left: 8),
                child: Container(
                  width: AppBar().preferredSize.height - 8,
                  height: AppBar().preferredSize.height - 8,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.arrow_back),
                      ),
                    ),
                  ),
                ))),
        Padding(
            padding: const EdgeInsets.only(top: 100, left: 24, bottom: 25),
            child: Text(
              "Clean up",
              style: new TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 24),
          child: Text(
            "Log in",
            style: new TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
