import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cleanup_worker/functions/normalDialog.dart';
import 'package:cleanup_worker/main.dart';
import 'package:cleanup_worker/modules/hotelBooking/proofOfDeliveryScreen.dart';
import 'package:cleanup_worker/modules/hotelBooking/updateOrderInfoScreen.dart';
import 'package:cleanup_worker/widgets/customAppBar.dart';
import 'package:cleanup_worker/widgets/customButton.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:maps_launcher/maps_launcher.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/apiController.dart';
import 'package:flutter/material.dart';
import '../../models/orderListData.dart';
import '../../appTheme.dart';

class HotelDetailes extends StatefulWidget {
  final OrderListData hotelData;

  const HotelDetailes({Key key, this.hotelData}) : super(key: key);
  @override
  _HotelDetailesState createState() => _HotelDetailesState();
}

class _HotelDetailesState extends State<HotelDetailes>
    with TickerProviderStateMixin {
  final ValueNotifier<int> _pageNotifier = new ValueNotifier(0);
  PageController _pageController = new PageController();

  final apiController = Get.put(APIController());
  bool isFav = false;
  bool isReadless = false;
  AnimationController animationController;
  var imageHieght = 0.0;
  AnimationController _animationController;

  Future<void> _launched;
  bool isLoading = false;
  bool isSignatureAttachLoading = false;

  OrderListData orderData;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    animationController.forward();
    if (widget.hotelData.deliveryStatus == 'DELIVER_REACHEDSTORE' ||
        widget.hotelData.deliveryStatus == 'DELIVER_LEFTSTORE' ||
        widget.hotelData.deliveryStatus == 'DELIVER_ONTOCLIENT') {
      this.setState(() {
        _pageNotifier.value = 1;
        _pageController = PageController(initialPage: 1);
      });
    }
    orderInit(widget.hotelData.id);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  orderInit(String orderId) async {
    await getOrder(orderId);
  }

  Future<void> getOrder(String orderId) async {
    log('api call start (getOrder)');
    final response = await http.get(Uri.parse(
        'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/getOrderInfoForDriver/' +
            orderId +
            "/" +
            apiController.id.value +
            "/" +
            apiController.key.value));

    log('update api call done');

    if (response.statusCode == 200) {
      this.setState(() {
        orderData = OrderListData.fromJson(jsonDecode(response.body));
      });
    } else {
      normalDialog(context,
          'Failed to get the Order info, contact the Support team', true);
    }
  }

  Future<bool> updateOrder(
      String driverId, String driverKey, String orderId, String status) async {
    log('api call start');
    final response = await http.get(Uri.parse(
        'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/updateOrderByDriver/' +
            driverId +
            "/" +
            driverKey +
            "/" +
            orderId +
            "/" +
            status));

    log('update api call done');

    if (response.statusCode == 200) {
      if (jsonDecode(response.body) == true) {
        return true;
      } else {
        normalDialog(context,
            'Failed to update the Order, contact the Support team', true);
      }
      //return OrderListData.fromJson(jsonDecode(response.body.content));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to load food order');
      normalDialog(context,
          'Failed to update the Order, contact the Support team', true);
    }

    return false;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: phoneNumber,
      );
      await launchUrl(launchUri);
    } catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to load Phone service'),
        duration: Duration(seconds: 7),
      ));
    }
  }

  Future<void> _findDirections(Address address) async {
    try {
      String addressQuery =
          address.addressLine1 != null && address.addressLine1 != ""
              ? address.addressLine1 + ", "
              : "";
      addressQuery += address.postalCode != null && address.postalCode != ""
          ? address.postalCode + ", "
          : "";
      addressQuery +=
          address.city != null && address.city != "" ? address.city + ", " : "";
      addressQuery += address.province != null && address.province != ""
          ? address.province
          : "";

      await MapsLauncher.launchQuery(addressQuery);
    } catch (ex) {
      log(ex.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to load Map service'),
        duration: Duration(seconds: 7),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    imageHieght = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: AppTheme.getTheme().backgroundColor,
        body: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top, bottom: 2),
                  child: CustomAppBar(
                    title: "Order Info",
                  )),
              Center(
                  child: CirclePageIndicator(
                      currentPageNotifier: _pageNotifier,
                      selectedSize: 25,
                      size: 20,
                      itemCount: 2,
                      selectedDotColor: AppTheme.getTheme().primaryColor,
                      dotColor: Colors.black12)),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: PageView(
                        controller: _pageController,
                        children: getHotelDetails(isInList: true),
                        onPageChanged: (index) {
                          setState(() {
                            _pageNotifier.value = index;
                          });
                        },
                      ))),
              Visibility(
                  visible: orderData != null &&
                      orderData.deliveryStatus == 'DELIVER_ONTOCLIENT',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Visibility(
                          visible: orderData != null &&
                              orderData.signatureFile == null,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProofOfDeliveryScreen(orderData)))
                                  .whenComplete(() => {
                                        this.setState(() {
                                          isSignatureAttachLoading = false;
                                          orderInit(orderData.id);
                                        })
                                      });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Attach signature',
                                style: TextStyle(
                                    fontSize: 21,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )),
                      Visibility(
                        visible: orderData != null &&
                            orderData.signatureFile != null,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.done_outline),
                                  Text(
                                    "Signature attached",
                                    style: TextStyle(
                                        fontSize: 21,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  )
                                ])),
                      ),
                    ],
                  )),
              Visibility(
                  visible: orderData != null,
                  child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      child: !isLoading
                          ? CustomButton(
                              text: orderData != null &&
                                      orderData.deliveryStatus ==
                                          'DELIVER_ASSIGN'
                                  ? "Accept now"
                                  : orderData != null &&
                                          orderData.deliveryStatus ==
                                              'DELIVER_ACCEPT'
                                      ? "On route"
                                      : orderData != null &&
                                              orderData.deliveryStatus ==
                                                  'DELIVER_ONTOSTORE'
                                          ? "Arrived"
                                          : orderData != null &&
                                                  orderData.deliveryStatus ==
                                                      'DELIVER_REACHEDSTORE'
                                              ? "Left store"
                                              : orderData != null &&
                                                      orderData
                                                              .deliveryStatus ==
                                                          'DELIVER_LEFTSTORE'
                                                  ? "On way to customer"
                                                  : 'Clear',
                              onTap: () {
                                setState(() {
                                  isLoading = true;
                                });

                                var status;
                                if (orderData != null &&
                                    orderData.deliveryStatus ==
                                        'DELIVER_ONTOCLIENT') {
                                  status = 'DELIVER_COMPLETED';
                                } else if (orderData != null &&
                                    orderData.deliveryStatus ==
                                        'DELIVER_ONTOSTORE') {
                                  status = 'DELIVER_REACHEDSTORE';
                                } else if (orderData != null &&
                                    orderData.deliveryStatus ==
                                        'DELIVER_REACHEDSTORE') {
                                  status = 'DELIVER_LEFTSTORE';
                                } else if (orderData != null &&
                                    orderData.deliveryStatus ==
                                        'DELIVER_LEFTSTORE') {
                                  status = 'DELIVER_ONTOCLIENT';
                                } else if (orderData != null &&
                                    orderData.deliveryStatus ==
                                        'DELIVER_ACCEPT') {
                                  status = 'DELIVER_ONTOSTORE';
                                } else {
                                  status = 'DELIVER_ACCEPT';
                                }

                                updateOrderStatus(status);
                              },
                            )
                          : CircularProgressIndicator())),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              ),
            ],
          ),
        ));
  }

  updateOrderStatus(String status) {
    updateOrder(apiController.id.value, apiController.key.value, orderData.id,
            status)
        .then((bool completed) {
      setState(() {
        isLoading = false;
      });
      if (completed) {
        Navigator.pop(context);
      }
    });
  }

  List<Widget> getHotelDetails({bool isInList = false}) {
    if (orderData != null) {
      return <Widget>[
        Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                        visible: isInList,
                        child: Text(
                          "Pick up info",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 32,
                            color: Colors.black,
                          ),
                        ))
                  ]),
              Text(" "),
              Visibility(
                  visible: isInList,
                  child: Text(
                    orderData.id,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 21,
                      color: Colors.black,
                    ),
                  )),
              Visibility(
                  visible: isInList,
                  child: Text(
                    "#" + orderData.storeName,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 21,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  )),
              Visibility(
                  visible: true,
                  child: Wrap(children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.place),
                          Flexible(
                              child: Text(
                            orderData.storeAddress.addressLine1,
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ))
                        ]),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.phone_in_talk),
                          Flexible(
                              child: Text(
                            orderData.storeMobileNumber,
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ))
                        ]),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.time_to_leave),
                        Text(
                          (orderData.formatDate.length > 12)
                              ? orderData.storeETATime ==
                                      orderData.formatDate.substring(12)
                                  ? 'Pick up ASAP'
                                  : 'Pick up by ' + orderData.storeETATime
                              : 'Pick up by ' + orderData.storeETATime,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 21,
                              color: Colors.red,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                              visible: orderData.storeMobileNumber != "" &&
                                  orderData.storeMobileNumber != "NA",
                              child: Wrap(children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    _launched = _makePhoneCall(
                                        "+1" + orderData.storeMobileNumber);
                                  },
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.storefront),
                                        Text(' Call',
                                            style: TextStyle(
                                              fontSize: 24,
                                            ))
                                      ]),
                                )
                              ])),
                          Text(
                            ' ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          Visibility(
                            visible: orderData.storeAddress != null &&
                                orderData.storeAddress.addressLine1 != null,
                            child: Wrap(children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  _findDirections(orderData.storeAddress);
                                },
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.storefront),
                                      Text(' Map',
                                          style: TextStyle(
                                            fontSize: 24,
                                          ))
                                    ]),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppTheme.getTheme().primaryColor),
                              )
                            ]),
                          )
                        ]),
                    Visibility(
                        visible: true,
                        child: Wrap(children: <Widget>[
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                    child: Text(
                                  'Pick up notes : ' + orderData.storeNotes,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )),
                              ]),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[Flexible(child: Text(' '))]),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                    child: Text(
                                  'Swipe right to see Drop off info >',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )),
                              ]),
                        ])),
                  ])),
            ]),
        Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                  visible: true,
                  child: Wrap(children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Visibility(
                              visible: isInList,
                              child: Flexible(
                                  child: Text(
                                "Drop off info",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 32,
                                  color: Colors.black,
                                ),
                              )))
                        ]),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[Flexible(child: Text(" "))]),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                              visible: isInList,
                              child: Flexible(
                                  child: Text(
                                orderData.id,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 21,
                                  color: Colors.black,
                                ),
                              )))
                        ]),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.settings_accessibility),
                          Flexible(
                              child: Text(
                            orderData.deliveryFirstName +
                                ', ' +
                                orderData.deliveryLastName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ))
                        ]),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.place),
                          Flexible(
                              child: Text(
                            orderData.deliveryAddress.addressLine1,
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          )),
                        ]),
                    Visibility(
                        visible:
                            orderData.deliveryAddress.addressLine2 != null &&
                                orderData.deliveryAddress.addressLine2 != '',
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.apartment),
                              Flexible(
                                  child: Text(
                                "# " + orderData.deliveryAddress.addressLine2,
                                style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )),
                            ])),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.time_to_leave),
                        Flexible(
                            child: Text(
                          'Drop by ' + orderData.customerETATime,
                          style: TextStyle(
                              fontSize: 21,
                              color: Colors.red,
                              fontWeight: FontWeight.w500),
                        )),
                      ],
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.phone_in_talk),
                          Text(
                            orderData.deliveryMobileNumber,
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          )
                        ]),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                              visible: orderData.deliveryMobileNumber != "" &&
                                  orderData.deliveryMobileNumber != "NA",
                              child: Wrap(children: <Widget>[
                                ElevatedButton(
                                    onPressed: () {
                                      _launched = _makePhoneCall("+1" +
                                          orderData.deliveryMobileNumber);
                                    },
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(Icons.face),
                                          Text(' Call',
                                              style: TextStyle(
                                                fontSize: 24,
                                              ))
                                        ]))
                              ])),
                          Text(
                            ' ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          Visibility(
                              visible: orderData.deliveryAddress != null &&
                                  orderData.deliveryAddress.addressLine1 !=
                                      null,
                              child: Wrap(children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    _findDirections(orderData.deliveryAddress);
                                  },
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.face),
                                        Text(
                                          ' Map',
                                          style: TextStyle(fontSize: 24),
                                        )
                                      ]),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppTheme.getTheme().primaryColor),
                                )
                              ])),
                          Text(
                            ' ',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          Visibility(
                              visible: orderData.deliveryStatus ==
                                      'DELIVER_ONTOSTORE' ||
                                  orderData.deliveryStatus ==
                                      'DELIVER_REACHEDSTORE' ||
                                  orderData.deliveryStatus ==
                                      'DELIVER_LEFTSTORE' ||
                                  orderData.deliveryStatus ==
                                      'DELIVER_ONTOCLIENT',
                              child: Wrap(children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateOrderInfoScreen(
                                                        orderData)))
                                        .whenComplete(() => setState(() {
                                              orderInit(orderData.id);
                                            }));
                                  },
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(Icons.directions),
                                        Text(' Edit',
                                            style: TextStyle(
                                              fontSize: 24,
                                            ))
                                      ]),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppTheme.getTheme().primaryColor),
                                )
                              ]))
                        ]),
                    Visibility(
                        visible: true,
                        child: Wrap(children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                  child: Text(
                                'Drop off notes : ' + orderData.deliveryNotes,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )),
                            ],
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text("Payment Info : ",
                                    style: TextStyle(
                                        fontSize: 21,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                                Flexible(
                                    child: Text(
                                  orderData.collectionAmount != null &&
                                          orderData.collectionType != null
                                      ? orderData.collectionType +
                                          " (" +
                                          orderData.collectionAmount
                                              .toString() +
                                          ")"
                                      : orderData.collectionType != null
                                          ? orderData.collectionType
                                          : "",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ))
                              ]),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                    child: Text(
                                  '< Swipe left to see pick up info',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )),
                              ]),
                        ])),
                  ]))
            ])
      ];
    } else {
      return <Widget>[
        Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                  visible: isInList,
                  child: Text(
                    "Loading order info ...",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  ))
            ]),
        Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                  child: Text(
                "Loading order info ...",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                  color: Colors.black,
                ),
              ))
            ])
      ];
    }
  }
}
