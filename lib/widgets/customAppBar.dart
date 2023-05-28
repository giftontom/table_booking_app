import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget{
  CustomAppBar({this.title=""});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: AppBar().preferredSize.height,
          child: Padding(
            padding: EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.width - 8,
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
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.arrow_back_ios),
                        Flexible(
                            child: Text(
                              title,
                              style: TextStyle(fontSize: 27, color: Colors.black),
                            ))
                      ]),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}