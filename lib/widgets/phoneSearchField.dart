import 'dart:convert';
import 'dart:developer';
import 'package:cleanup_worker/appTheme.dart';
import 'package:cleanup_worker/controllers/apiController.dart';
import 'package:cleanup_worker/widgets/customTextField.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class PhoneSearchField extends StatefulWidget {
  PhoneSearchField({this.hintText, this.onSelectAddress, this.controller});

  final String hintText;
  final TextEditingController controller;
  final Function(Map<String, dynamic>) onSelectAddress;

  @override
  _PhoneSearchFieldState createState() => _PhoneSearchFieldState();
}

class _PhoneSearchFieldState extends State<PhoneSearchField> {
  final FocusNode focusNode = FocusNode();
  final apiController = Get.put(APIController());
  List<Map<String, dynamic>> suggestions = [];

  getAddressByPhoneNumber(String value) async {
    if (value != null && value.trim() != '' && value.length > 9) {
      log('api call start >> get address');
      final response = await http.get(
          Uri.parse(
              'https://trackerapi.cleanup.com/admintrack/v1/api/track/driver/getAddressInfoAsList/' +
                  apiController.id.value +
                  "/" +
                  apiController.key.value +
                  "/" +
                  value.trim()),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      log('get address info from phone no. api call done');
      if (response.statusCode == 200) {
        var contentList = await jsonDecode(response.body) as List;
        suggestions.clear();
        contentList.forEach((element) {
          suggestions.add(element as Map<String, dynamic>);
        });
      }
      setState(() {
        true;
      });

      return;
    }

    log('failed to get address suggestions');
    suggestions.clear();
    setState(() {
      suggestions = [];
    });

    return;
  }

  @override
  void initState() {
    widget.controller.addListener(() {
      getAddressByPhoneNumber(widget.controller.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 16),
        child: Container(
            decoration: BoxDecoration(
              color: AppTheme.getTheme().backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(38)),
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
                child: SearchField(
                  controller: widget.controller,
                  focusNode: focusNode,
                  suggestions: suggestions
                      .map(
                        (order) => SearchFieldListItem<Map<String, dynamic>>(
                          order["deliveryMobileNumber"],
                          item: order,
                          child: Row(
                            children: [
                              Text(
                                order["deliveryAddress"]["addressType"] !=
                                            null &&
                                        order["deliveryAddress"]
                                                ["addressType"] !=
                                            ''
                                    ? order["deliveryAddress"]["addressType"] +
                                        " - "
                                    : "",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                order["deliveryAddress"]["addressLine2"] !=
                                            null &&
                                        order["deliveryAddress"]
                                                ["addressLine2"] !=
                                            ''
                                    ? order["deliveryAddress"]["addressLine2"] +
                                        ", "
                                    : "",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                order["deliveryAddress"]["addressLine1"] !=
                                            null &&
                                        order["deliveryAddress"]
                                                ["addressLine1"] !=
                                            ''
                                    ? order["deliveryAddress"]["addressLine1"]
                                    : "",
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                  searchInputDecoration: new InputDecoration(
                    errorText: null,
                    border: InputBorder.none,
                    labelText: widget.hintText,
                    hintText: widget.hintText,
                    hintStyle:
                        TextStyle(color: AppTheme.getTheme().disabledColor),
                  ),
                  onSuggestionTap: (value) {
                    focusNode.unfocus();
                    widget.onSelectAddress(value.item as Map<String, dynamic>);
                  },
                ))));
  }
}
