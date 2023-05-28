import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsListData {
  String titleTxt;
  String subTxt;
  String content;
  IconData iconData;
  bool isSelected;

  SettingsListData({
    this.titleTxt = '',
    this.isSelected = false,
    this.subTxt = '',
    this.content = '',
    this.iconData = Icons.supervised_user_circle,
  });

  List<SettingsListData> getCountryListFromJson(Map<String, dynamic> json) {
    List<SettingsListData> countryList = List<SettingsListData>();
    if (json['countryList'] != null) {
      json['countryList'].forEach((v) {
        SettingsListData data = SettingsListData();
        data.titleTxt = v["name"];
        data.subTxt = v["code"];
        countryList.add(data);
      });
    }
    return countryList;
  }

  static List<SettingsListData> userSettingsList = [
    SettingsListData(
      titleTxt: 'My past tasks',
      isSelected: false,
      iconData: FontAwesomeIcons.docker,
    ),
    SettingsListData(
      titleTxt: 'Change password',
      isSelected: false,
      iconData: FontAwesomeIcons.lock,
    ),
    SettingsListData(
      titleTxt: 'Notifications',
      isSelected: false,
      iconData: FontAwesomeIcons.solidBell,
    ),
    SettingsListData(
      titleTxt: 'Log out',
      isSelected: false,
      iconData: Icons.keyboard_arrow_right,
    )
  ];

  static List<SettingsListData> currencyList = [
    SettingsListData(
      titleTxt: 'Australia Dollar',
      subTxt: "\$ AUD",
    ),
    SettingsListData(
      titleTxt: 'Argentina Peso',
      subTxt: "\$ ARS",
    ),
    SettingsListData(
      titleTxt: 'Indian rupee',
      subTxt: "₹ Rupee",
    ),
    SettingsListData(
      titleTxt: 'United States Dollar',
      subTxt: "\$ USD",
    ),
    SettingsListData(
      titleTxt: 'Chinese Yuan',
      subTxt: "¥ Yuan",
    ),
    SettingsListData(
      titleTxt: 'Belgian Euro',
      subTxt: "€ Euro",
    ),
    SettingsListData(
      titleTxt: 'Brazilian Real',
      subTxt: "R\$ Real",
    ),
    SettingsListData(
      titleTxt: 'Canadian Dollar',
      subTxt: "\$ CAD",
    ),
    SettingsListData(
      titleTxt: 'Cuban Peso',
      subTxt: "₱ PESO",
    ),
    SettingsListData(
      titleTxt: 'French Euro',
      subTxt: "€ Euro",
    ),
    SettingsListData(
      titleTxt: 'Hong Kong Dollar',
      subTxt: "\$ HKD",
    ),
    SettingsListData(
      titleTxt: 'Italian Lira',
      subTxt: "€ Euro",
    ),
    SettingsListData(
      titleTxt: 'New Zealand Dollar',
      subTxt: "\$ NZ",
    ),
  ];

  static List<SettingsListData> helpSearchList = [
    SettingsListData(
      titleTxt: 'FAQs',
      subTxt: "",
      content: "",
    ),
    SettingsListData(
        titleTxt: '',
        subTxt: "How do I accept work orders?",
        content:
            "On successful Login, you will be taken to Tasks page, Take In tab will show if any order is ready for Accept, On click of the Order, you will be shown a details page, where you can Accept the Order"),
    SettingsListData(
      titleTxt: '',
      subTxt: "How do I update my bank account information?",
      content:
          "Currently we only pay using Interac / Cash / Cheque, Supporting paying to your bank account feature is under devlopment",
    ),
    SettingsListData(
        titleTxt: '',
        subTxt: "When am I will get paid?",
        content:
            "You'll be paid on the Same day using our available payment methods."),
    SettingsListData(
        titleTxt: '',
        subTxt: "How do I track my assigned work tasks?",
        content:
            "All the orders are monitored and updated to you using the Notification messages. In addition you can monitor your assigned orders using the 'Assigned' tab and update Each stages of your delivery order."),
    SettingsListData(
        titleTxt: '',
        subTxt: "How do I edit my profile Information?",
        content:
            "Currenly we are in the process of developing of our delivery portal website, The payment / profile changes are possible only by calling us using our contact number 226-781-8535."),
  ];

  static List<SettingsListData> userInfoList = [
    SettingsListData(
      titleTxt: '',
      subTxt: "",
    ),
    SettingsListData(
      titleTxt: 'UserName',
      subTxt: "Amanda Jane",
    ),
    SettingsListData(
      titleTxt: 'Email',
      subTxt: "amanda@gmail.com",
    ),
    SettingsListData(
      titleTxt: 'Phone',
      subTxt: "+65 1122334455",
    ),
    SettingsListData(
      titleTxt: 'Date of birth',
      subTxt: "20, Aug, 1990",
    ),
    SettingsListData(
      titleTxt: 'Address',
      subTxt: "123 Royal Street, New York",
    ),
  ];
}
