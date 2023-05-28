import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cleanup_worker/appTheme.dart';
import 'package:cleanup_worker/controllers/apiController.dart';
import 'package:cleanup_worker/functions/normalDialog.dart';
import 'package:cleanup_worker/models/orderListData.dart';
import 'package:cleanup_worker/widgets/customAppBar.dart';
import 'package:cleanup_worker/widgets/customButton.dart';
import 'package:cleanup_worker/widgets/customTextField.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

class ProofOfDeliveryScreen extends StatefulWidget {
  ProofOfDeliveryScreen(this.orderData);

  final OrderListData orderData;
  _ProofOfDeliveryScreenState createState() => _ProofOfDeliveryScreenState();
}

class _ProofOfDeliveryScreenState extends State<ProofOfDeliveryScreen> {
  final apiController = Get.put(APIController());
  TextEditingController additionalInfo = TextEditingController();
  String deliveryImage = "";

  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  bool isLoading = false;

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
                  title: "Proof of Delivery",
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                children: <Widget>[
                  CustomTextField(
                    hintText: "Additional Info",
                    minLines: 3,
                    controller: additionalInfo,
                    fontSize: 24,
                  ),
                  CustomActionBox(
                    promptText: "Customer's Signature",
                    secondChild: Signature(
                      controller: signatureController,
                      width: double.infinity,
                      height: double.infinity,
                      backgroundColor: Colors.white,
                    ),
                    onClear: () => signatureController.clear(),
                  ),
                ],
              ))),
              AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  child: !isLoading
                      ? CustomButton(
                          text: 'Update',
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            updateDeliveryDetails().then((bool completed) {
                              setState(() {
                                isLoading = false;
                              });
                              if (completed) {
                                Navigator.of(context).pop(true);
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

  Future<bool> updateDeliveryDetails() async {
    log('api call start');

    var proofOfDeliveryInfo = new Map<String, dynamic>();
    proofOfDeliveryInfo['toAdditionalInfo'] = additionalInfo.text;
    proofOfDeliveryInfo['completed'] = true.toString();

    final uri = Uri.parse(
        'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/updateProofOfDeliveryInfoByDriver/' +
            apiController.id.value +
            "/" +
            apiController.key.value +
            "/" +
            widget.orderData.id);

    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(proofOfDeliveryInfo),
    );

    /*
      var userSignature = await signatureController.toPngBytes();
      if (userSignature != null) {
        final signMultiPartImage =
            http.MultipartFile.fromBytes('signature', userSignature);
        request.files.add(signMultiPartImage);
      }
    */

    if (response.statusCode == 200) {
      var userSignature = await signatureController.toPngBytes();
      if (userSignature != null) {
        final signatureURI = Uri.parse(
            'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/updateSignatureProofOfDeliveryInfoByDriver/' +
                apiController.id.value +
                "/" +
                apiController.key.value +
                "/" +
                widget.orderData.id);

        var signatureRequest = new http.MultipartRequest('POST', signatureURI);
        signatureRequest.headers.addAll({
          'Content-Type': 'multipart/form-data',
        });
        signatureRequest.files.add(http.MultipartFile.fromBytes(
            'signatureFile', userSignature,
            contentType: MediaType('multipart', 'form-data'),
            filename: 'signatureFile'));
        final responseStream = await signatureRequest.send();

        log('update proof of delivery api call done');
        final response = await http.Response.fromStream(responseStream);
        if (response.statusCode == 200) {
          setState(() {
            isLoading = false;
          });

          return true;
        }
      }

      setState(() {
        isLoading = false;
      });

      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      //throw Exception('Failed to load food order');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to update the server'),
        duration: Duration(seconds: 7),
      ));
    }
    return false;
  }
}

class CustomActionBox extends StatefulWidget {
  CustomActionBox(
      {this.promptText, this.onTap, this.onClear, this.secondChild});
  final String promptText;
  final VoidCallback onTap;
  final VoidCallback onClear;
  final Widget secondChild;

  _CustomActionBoxState createState() => _CustomActionBoxState();
}

class _CustomActionBoxState extends State<CustomActionBox> {
  bool showFirst = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (showFirst) {
          setState(() {
            showFirst = false;
          });
          if (widget.onTap != null) {
            widget.onTap();
          }
        }
      },
      child: Container(
          height: 200,
          width: double.infinity,
          margin: const EdgeInsets.only(left: 24, right: 24, top: 20),
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
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: showFirst
                  ? Center(
                      child: Text(widget.promptText,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 21,
                              color: Colors.black)))
                  : Stack(children: [
                      widget.secondChild,
                      Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showFirst = true;
                                });
                                if (widget.onClear != null) {
                                  widget.onClear();
                                }
                              },
                              child: CircleAvatar(
                                  backgroundColor:
                                      AppTheme.getTheme().primaryColor,
                                  child: Icon(Icons.close_rounded))))
                    ]))),
    );
  }
}
