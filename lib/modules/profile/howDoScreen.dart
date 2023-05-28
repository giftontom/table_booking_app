import 'package:flutter/material.dart';
import '../../appTheme.dart';

class HowDoScreen extends StatefulWidget {
  final String title;
  final String content;
  final String subTxt;

  const HowDoScreen({Key key, this.title = "", this.subTxt, this.content})
      : super(key: key);
  @override
  _HowDoScreenState createState() => _HowDoScreenState();
}

class _HowDoScreenState extends State<HowDoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: AppTheme.getTheme().backgroundColor,
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
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top, bottom: 24),
                child: appBar(),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    widget.subTxt,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 16),
                                  child: Container(
                                    child: Text(
                                      widget.content,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
          padding: const EdgeInsets.only(top: 4, left: 24, bottom: 24),
          child: Text(
            widget.title,
            style: new TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 24,
            left: 24,
          ),
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }
}
