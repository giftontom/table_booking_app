import 'package:flutter/material.dart';
import '../../appTheme.dart';
import '../../models/profileData.dart';
import '../../models/settingListData.dart';

class EditProfile extends StatelessWidget {
  final ProfileData profiledo;
  EditProfile({Key key, @required this.profiledo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<SettingsListData> userInfoList = [
      SettingsListData(
        titleTxt: '',
        subTxt: "",
      ),
      SettingsListData(
        titleTxt: 'First Name',
        subTxt: profiledo.firstName,
      ),
      SettingsListData(
        titleTxt: 'Last name',
        subTxt: profiledo.lastName,
      ),
      SettingsListData(
        titleTxt: 'Email',
        subTxt: profiledo.email == null ? 'NA' : profiledo.email,
      ),
      SettingsListData(
        titleTxt: 'Phone',
        subTxt: profiledo.phone,
      ),
      SettingsListData(
        titleTxt: 'Driver license number',
        subTxt: profiledo.driverLicenseNumber == null
            ? 'NA'
            : profiledo.driverLicenseNumber,
      ),
      SettingsListData(
        titleTxt: 'Edit your porfile data feature is not available now',
        subTxt: '',
      ),
    ];

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
                    top: MediaQuery.of(context).padding.top, bottom: 16),
                child: appBar(context),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      bottom: 16 + MediaQuery.of(context).padding.bottom),
                  itemCount: userInfoList.length,
                  itemBuilder: (context, index) {
                    return index == 0
                        ? getProfileUI(context)
                        : InkWell(
                            onTap: () {},
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 16),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16.0, bottom: 16, top: 16),
                                          child: Text(
                                            userInfoList[index].titleTxt,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Colors.black45,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 16.0, bottom: 16, top: 16),
                                        child: Container(
                                          child: Text(
                                            userInfoList[index].subTxt,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: Divider(
                                    height: 1,
                                  ),
                                )
                              ],
                            ),
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getProfileUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 130,
            height: 130,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.getTheme().primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppTheme.getTheme().dividerColor,
                        blurRadius: 8,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                    child: Image.asset("assets/images/userImage.png"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget appBar(BuildContext context) {
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
            "View Profile",
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
