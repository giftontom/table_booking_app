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
import '../../sharedPreference.dart';

class ChangepasswordScreen extends StatefulWidget {
  @override
  _ChangepasswordScreenState createState() => _ChangepasswordScreenState();
}

class _ChangepasswordScreenState extends State<ChangepasswordScreen> {
  final apiController = Get.put(APIController());
  final TextEditingController confirmPasswordController =
      new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Future<String> updatePassword(
      String id, String key, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      normalDialog('Password should match', true);
      return null;
    }
    log('api call start');
    var dataIn = new Map<String, dynamic>();
    dataIn['newPassword'] = password;
    var url =
        'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/updatePassword/' +
            id +
            "/" +
            key;
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
          'You will be logged off to login again using the new password.',
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
                              "Enter your new password and\nconfirm your password",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.getTheme().disabledColor,
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
                                    hintText: "New Password",
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
                      SizedBox(
                        height: 16,
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
                                    hintText: "Confirm Password",
                                    hintStyle: TextStyle(
                                        color:
                                            AppTheme.getTheme().disabledColor),
                                  ),
                                  controller: confirmPasswordController,
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
                                //Navigator.pop(context);
                                updatePassword(
                                        apiController.id.value,
                                        apiController.key.value,
                                        passwordController.text,
                                        confirmPasswordController.text)
                                    .then((String dataOut) {
                                  if (dataOut != null) {
                                    apiController.id.value = '';
                                    apiController.key.value = '';
                                    apiController.fcmToken.value = '';
                                    SharedPreference.removeClientInfo();
                                    MyApp.restartApp(context);
                                  }
                                });
                              },
                              child: Center(
                                child: Text(
                                  "Apply",
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
            "Change Password",
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
