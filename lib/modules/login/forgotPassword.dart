import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../../controllers/apiController.dart';
import '../../appTheme.dart';
import '../../sharedPreference.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final apiController = Get.put(APIController());
  final TextEditingController phoneNumberController =
      new TextEditingController();

  Future<String> forgotPassword(
      String id, String key, String phoneNumber) async {
    if (phoneNumber == null || phoneNumber == '') {
      normalDialog('Mobile number should be provided', true);
      return null;
    }
    log('api call start');
    var dataIn = new Map<String, dynamic>();
    dataIn['phoneNumber'] = phoneNumber;
    var url =
        'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/forgotPassword';
    final response = await http.post(
        Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(dataIn),
    );

    log('api call done');

    if (response.statusCode == 200) {
      normalDialog(
          'Check your mobile an SMS was sent with a new password to login again',
          false);
      return null;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to load food order');
      log('api error ' + jsonDecode(response.body)['message']);

      var errorMessage = jsonDecode(response.body)['message'];
      var errorMessageToShow = errorMessage;

      normalDialog(errorMessageToShow, true);
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
      btnOkOnPress: () {
        if (!showError) {
          MyApp.restartApp(context);
        }
      },
      btnOkIcon: Icons.check_circle,
    )..show();
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
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, bottom: 16.0, left: 24, right: 24),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Enter your mobile number to receive an SMS so\nwe provide a new password",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, bottom: 16.0, left: 24, right: 24),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Use this feauture cautiously.",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.red,
                              ),
                            ),
                          ],
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
                                  ),
                                  cursorColor: AppTheme.getTheme().primaryColor,
                                  decoration: new InputDecoration(
                                    errorText: null,
                                    border: InputBorder.none,
                                    hintText: "Your Mobile number",
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
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 8, top: 16),
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
                                forgotPassword(
                                        apiController.id.value,
                                        apiController.key.value,
                                        phoneNumberController.text)
                                    .then((String dataOut) {
                                  if (dataOut != null) {
                                    apiController.id.value = '';
                                    apiController.key.value = '';
                                    apiController.fcmToken.value = '';
                                    SharedPreference.removeClientInfo();
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: Center(
                                child: Text(
                                  "Send",
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
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 24),
          child: Text(
            "Forgot Password",
            style: new TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
