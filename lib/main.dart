import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appTheme.dart';
import 'splashScreen.dart';
import 'modules/bottomTab/bottomTabScreen.dart';
import 'modules/login/loginScreen.dart';
import 'pushNotification.dart';

import 'package:http/http.dart' as http;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final PushNotificationService _pushNotificationService =
    PushNotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _pushNotificationService.initialise();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  WidgetsFlutterBinding.ensureInitialized();
  initializeService();
  await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(Duration(seconds: 10), (timer1) async {
    //if (!(await service.isServiceRunning())) timer1.cancel();
    reportApi("Background service call (location)");
    locationUpdateService();
  });
}

@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance serviceInstance) {
  return true;
}

void initializeService() async {
  final service = FlutterBackgroundService();
  service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

locationUpdateService() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      log("Location access. Service disabled, it is required for tracking purpose. Update your system location settings");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    bool permissionGranted = false;

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      permissionGranted = true;
    } else {
      reportApi(
          "Location access, Permission denied, but it is required for tracking purpose, can you update your system settings");
    }

    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload(); // Its important

    String clientId = sharedPreferences.get("client_id");
    String clientKey = sharedPreferences.get("client_key");
    bool keysAcquired = clientId.isNotEmpty & clientKey.isNotEmpty;

    bool canTryLocationUpdate =
        permissionGranted && serviceEnabled && keysAcquired;

    reportApi("bg service call (location) " + clientId);

    if (canTryLocationUpdate) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      updateLocation(clientId, clientKey, position);
    }
  } catch (e) {
    log(e.toString());
  }
}

Future<bool> updateLocation(
    String driverId, String driverKey, Position position) async {
  var deviceInfo = new Map<String, dynamic>();
  deviceInfo['latitude'] = position.latitude;
  deviceInfo['longitude'] = position.longitude;

  log('api call start (bg) >> alerts');
  final response = await http.post(
    Uri.parse(
        'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/driver/addDriverGeoLocation/' +
            driverId +
            "/" +
            driverKey),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(deviceInfo),
  );
  log('api updateLocation(bg) call done');

  if (response.statusCode == 200) {
    log('location update was successful');

    return true;
  } else {
    log('location update was unsuccessful');
    return false;
  }
}

Future<bool> reportApi(String message) async {
  var minDataInfo = new Map<String, dynamic>();
  minDataInfo['description'] = message;

  log('api call start >> log data');
  final response = await http.post(
    Uri.parse(
        'https://trackerapi.deliverydeals.com/admintrack/v1/api/track/delivery/addLoggerData'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(minDataInfo),
  );
  log('api log data call done');

  if (response.statusCode == 200) {
    log('log data sent was successful');
    return null;
  }

  return false;
}

class MyApp extends StatefulWidget {
  static restartApp(BuildContext context) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();

    state.restartApp();
  }

  static startLocationTracker(BuildContext context) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();

    state.startLocationTracker();
  }

  static stopLocationTracker(BuildContext context) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();

    state.stopLocationTracker();
  }

  static setCustomeTheme(BuildContext context) {
    final _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setCustomeTheme();
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = new UniqueKey();

  final PushNotificationService _pushNotificationService =
      PushNotificationService();

  @override
  void initState() {
    super.initState();
    initializeLocation();
    _pushNotificationService.initialise();
  }

  void restartApp() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }

    this.setState(() {
      navigatorKey = new GlobalKey<NavigatorState>();
      key = new UniqueKey();
    });
  }

  void startLocationTracker() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (!isRunning) {
      service.startService();
    }
  }

  void stopLocationTracker() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }
  }

  void setCustomeTheme() {
    setState(() {
      AppTheme.isLightTheme = !AppTheme.isLightTheme;
    });
  }

  initializeLocation() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      var status = await Permission.locationWhenInUse.request();
      if (status.isGranted) {
        var status = await Permission.locationAlways.request();
        if (status.isGranted) {
          //Do some stuff
        } else {
          log("Location access. Service disabled, it is required for tracking purpose. Update your system location settings");
        }
      } else {
        //The user deny the permission
      }
      if (status.isPermanentlyDenied) {
        //When the user previously rejected the permission and select never ask again
        //Open the screen of settings
        await openAppSettings();
      }
    } else {
      //In use is available, check the always in use
      var status = await Permission.locationAlways.status;
      if (!status.isGranted) {
        var status = await Permission.locationAlways.request();
        if (status.isGranted) {
          //Do some stuff
        } else {
          //Do another stuff
        }
      } else {
        //previously available, do some stuff or nothing
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
      statusBarBrightness:
          AppTheme.isLightTheme ? Brightness.light : Brightness.dark,
      systemNavigationBarColor:
          AppTheme.isLightTheme ? Colors.white : Colors.black,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness:
          AppTheme.isLightTheme ? Brightness.dark : Brightness.light,
    ));
    return Container(
      key: key,
      color: AppTheme.getTheme().backgroundColor,
      child: OverlaySupport(
          child: MaterialApp(
              navigatorKey: navigatorKey,
              title: 'Clean up',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.getTheme(),
              routes: routes,
              builder: (BuildContext context, Widget child) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: Builder(
                    builder: (BuildContext context) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          textScaleFactor:
                              MediaQuery.of(context).size.width > 360
                                  ? 1.0
                                  : MediaQuery.of(context).size.width >= 340
                                      ? 0.9
                                      : 0.8,
                        ),
                        child: child,
                      );
                    },
                  ),
                );
              })),
    );
  }

  var routes = <String, WidgetBuilder>{
    Routes.SPLASH: (BuildContext context) => SplashScreen(),
    Routes.TabScreen: (BuildContext context) => new BottomTabScreen(),
  };
}

class Routes {
  static const String SPLASH = "/";
  static const String TabScreen = "/bottomTab/bottomTabScreen";
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) {
  log("Handling a background message: ${message.messageId}");
  var printText = "Notification";
  printText +=
      "\n" + message.notification.title + "\n" + message.notification.body;
  showSimpleNotification(
    Text(printText),
    background: AppTheme.getTheme().primaryColor,
  );
}
