import 'package:flutter/foundation.dart';

class ProfileData extends ChangeNotifier {
  String id;
  String key;
  String email;
  String firstName;
  String lastName;
  String phone;
  String driverLicenseNumber;
  bool notify;

  ProfileData(this.email, this.firstName, this.lastName,
      this.driverLicenseNumber, this.phone, this.notify);

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
        json['email'],
        json['firstName'] == null ? 'NA' : json['firstName'],
        json['lastName'],
        json['driverLicenseNumber'],
        json['phoneNumber'],
        json['notify']);
  }

  void update(String email, String firstName, String lastName,
      String driverLicenseNumber) {
    email = email;
    firstName = firstName;
    lastName = lastName;
    driverLicenseNumber = driverLicenseNumber;
    // This line tells [Model] that it should rebuild the widgets that
    // depend on it.
    notifyListeners();
  }

  String get getDisplayText => firstName + " " + lastName;
  String get getUserId => id;
  String get getUserKey => key;
}
