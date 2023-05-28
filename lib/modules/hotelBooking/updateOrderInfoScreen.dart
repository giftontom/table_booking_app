import 'dart:convert';
import 'dart:developer';
import 'package:cleanup_worker/controllers/apiController.dart';
import 'package:cleanup_worker/functions/normalDialog.dart';
import 'package:cleanup_worker/widgets/phoneSearchField.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cleanup_worker/appTheme.dart';
import 'package:cleanup_worker/models/orderListData.dart';
import 'package:cleanup_worker/widgets/customAppBar.dart';
import 'package:cleanup_worker/widgets/customButton.dart';
import 'package:cleanup_worker/widgets/customTextField.dart';
import 'package:flutter/material.dart';

class UpdateOrderInfoScreen extends StatefulWidget {
  UpdateOrderInfoScreen(this.orderData);

  final OrderListData orderData;
  _UpdateOrderInfoScreenState createState() => _UpdateOrderInfoScreenState();
}

class _UpdateOrderInfoScreenState extends State<UpdateOrderInfoScreen> {
  final apiController = Get.put(APIController());
  TextEditingController firstNameController;
  TextEditingController lasttNameController;
  TextEditingController phoneController;
  TextEditingController address1Controller;
  TextEditingController address2Controller;
  TextEditingController cityController;
  TextEditingController postalController;
  TextEditingController deliveryInstructionsController;

  String _chosenAddressTypeValue;

  bool isLoading = false;

  @override
  void initState() {
    firstNameController = TextEditingController(
        text: widget.orderData.deliveryFirstName == 'NA'
            ? ''
            : widget.orderData.deliveryFirstName);
    lasttNameController = TextEditingController(
        text: widget.orderData.deliveryLastName == 'NA'
            ? ''
            : widget.orderData.deliveryLastName);
    phoneController = TextEditingController(
        text: widget.orderData.deliveryMobileNumber == 'NA'
            ? ''
            : widget.orderData.deliveryMobileNumber);
    address1Controller = TextEditingController(
        text: widget.orderData.deliveryAddress.addressLine1);
    address2Controller = TextEditingController(
        text: widget.orderData.deliveryAddress.addressLine2);
    cityController =
        TextEditingController(text: widget.orderData.deliveryAddress.city);
    postalController = TextEditingController(
        text: widget.orderData.deliveryAddress.postalCode);
    deliveryInstructionsController =
        TextEditingController(text: widget.orderData.deliveryNotes);

    setState(() {
      _chosenAddressTypeValue = "HOME";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.getTheme().backgroundColor,
        body: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top, bottom: 2),
                child: CustomAppBar(
                  title: "Drop off Info",
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(children: <Widget>[
                PhoneSearchField(
                  controller: phoneController,
                  hintText: "Mobile no.",
                  onSelectAddress: updateFields,
                ),
                Row(children: [
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Text(
                            "Address : ",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    border: Border.all(
                                        color: AppTheme.primaryColors)),
                                child: Row(children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: DropdownButton<String>(
                                      value: _chosenAddressTypeValue,
                                      icon: const Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 12,
                                      style: TextStyle(color: Colors.black),
                                      items: <String>[
                                        'HOME',
                                        'WORK',
                                        'FRIEND',
                                        'OTHER'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      hint: Text(
                                        "Choose an option",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onChanged: (String value) {
                                        setState(() {
                                          _chosenAddressTypeValue = value;
                                        });
                                      },
                                    ),
                                  ),
                                ])),
                          )
                        ],
                      )),
                ]),
                Row(children: [
                  Expanded(
                      flex: 3,
                      child: Column(children: [
                        CustomTextField(
                            hintText: "Apt / Unit number",
                            controller: address2Controller,
                            leftAlignSize: 10,
                            rightAlignSize: 1),
                      ])),
                  Expanded(
                      flex: 7,
                      child: Column(children: [
                        CustomTextField(
                          hintText: "Address line 1",
                          controller: address1Controller,
                          leftAlignSize: 1,
                          rightAlignSize: 10,
                        )
                      ]))
                ]),
                Row(children: [
                  Expanded(
                      flex: 5,
                      child: Column(children: [
                        CustomTextField(
                          hintText: "City",
                          controller: cityController,
                          leftAlignSize: 10,
                          rightAlignSize: 1,
                        ),
                      ])),
                  Expanded(
                      flex: 5,
                      child: Column(children: [
                        CustomTextField(
                          hintText: "Postal code",
                          controller: postalController,
                          leftAlignSize: 1,
                          rightAlignSize: 10,
                        ),
                      ]))
                ]),
                Row(children: [
                  Expanded(
                      flex: 5,
                      child: Column(children: [
                        CustomTextField(
                          hintText: "First name",
                          controller: firstNameController,
                          leftAlignSize: 10,
                          rightAlignSize: 1,
                        )
                      ])),
                  Expanded(
                      flex: 5,
                      child: Column(children: [
                        CustomTextField(
                          hintText: "Last name",
                          controller: lasttNameController,
                          leftAlignSize: 1,
                          rightAlignSize: 10,
                        )
                      ]))
                ]),
                CustomTextField(
                  hintText: "Delivery instructions",
                  minLines: 1,
                  controller: deliveryInstructionsController,
                  leftAlignSize: 10,
                  rightAlignSize: 10,
                ),
              ]))),
              AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: !isLoading
                      ? CustomButton(
                          text: 'Update',
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            updateDeliveryDetails({
                              "toAdditionalInfo":
                                  deliveryInstructionsController.text,
                              "toAddressLine1": address1Controller.text,
                              "toAddressLine2": address2Controller.text,
                              "toCity": cityController.text,
                              "toFirstName": firstNameController.text,
                              "toLastName": lasttNameController.text,
                              "toMobileNumber": phoneController.text,
                              "toPostalCode": postalController.text,
                              "toAddressType": _chosenAddressTypeValue,
                            }).then((bool completed) {
                              setState(() {
                                isLoading = false;
                              });
                              if (completed) {
                                Navigator.pop(context);
                              }
                            });
                          },
                        )
                      : CircularProgressIndicator()),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Divider(
                  height: 1,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              ),
            ])));
  }

  updateFields(Map<String, dynamic> content) {
    setState(() {
      if (content.isNotEmpty) {
        firstNameController.text = content["deliveryFirstName"];
        lasttNameController.text = content["deliveryLastName"];
        phoneController.text = content["deliveryMobileNumber"];
        final Map<String, dynamic> deliveryAddress =
            content.containsKey("deliveryAddress")
                ? content["deliveryAddress"]
                : {};
        if (deliveryAddress.isNotEmpty) {
          address1Controller.text = deliveryAddress["addressLine1"];
          address2Controller.text = deliveryAddress["addressLine2"];
          cityController.text = deliveryAddress["city"];
          postalController.text = deliveryAddress["postalCode"];
        }

        this.setState(() {
          _chosenAddressTypeValue = deliveryAddress["addressType"] != null
              ? deliveryAddress["addressType"]
              : "HOME";
        });
      }
    });
  }

  Future<bool> updateDeliveryDetails(Map<String, dynamic> updates) async {
    log('api call start');
    final response = await http.post(
        Uri.parse(
            'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/updateDeliveryInfoByDriver/' +
                apiController.id.value +
                "/" +
                apiController.key.value +
                "/" +
                widget.orderData.id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updates));

    log('update delivery details api call done');

    if (response.statusCode == 200) {
      if (jsonDecode(response.body) == true) {
        return true;
      } else {
        normalDialog(
            context,
            'Failed to update the delivery details, contact the Support team',
            true);
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to load food order');
      normalDialog(
          context,
          'Failed to update the delivery details, contact the Support team',
          true);
    }
    return false;
  }
}
