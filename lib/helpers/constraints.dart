import 'dart:io';

import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import 'color_circular_progress_indicator.dart';

enum Size { SMALL, MEDIUM, LARGE }
enum SocialType { followers, following }
enum AlertType { INFO, WARNING, ERROR, SUCCESS }

String getSize(sSize) {
  String size = '';
  switch (sSize) {
    case Size.LARGE:
      size = "Large";
      break;
    case Size.SMALL:
      size = "Small";
      break;
    case Size.MEDIUM:
      size = "Medium";
      break;
    default:
      size = "Small";
  }
  return size;
}

Enum setSize(cSize) {
  Enum size;
  switch (cSize) {
    case "Large":
      size = Size.LARGE;
      break;
    case "Small":
      size = Size.SMALL;
      break;
    case "Medium":
      size = Size.MEDIUM;
      break;
    default:
      size = Size.SMALL;
  }
  return size;
}

class Constraints {
  static String infoIcon = 'assets/icons/alert/info.png';
  static String successIcon = 'assets/icons/alert/success.png';
  static String warningIcon = 'assets/icons/alert/warning.png';
  static String errorIcon = 'assets/icons/alert/error.png';
  static var colorTween = Tween(
    begin: kprimaryColor,
    end: logoRed,
  );

  static Future<LocationData?> getCurrentLocation() async {
    try {
      Location location = new Location();

      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;
      print("inlocation function");

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        print("inlocation function2");
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return null;
        }
      }

      _permissionGranted = await location.hasPermission();
      print("inlocation function3");
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return null;
        }
      }
      if (_permissionGranted == PermissionStatus.denied) {
        return null;
      }
      print("inlocation function4");

      _locationData = await location.getLocation();
      print(_locationData);
      print("inlocation function5");
      return _locationData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  int convertNumber(num) {
    try {
      // print(num);
      if (num is int) {
        return num;
      }
      if (num != null) {
        int? a = int.tryParse(num);
        // print("a");
        // print(a);
        return a == null ? 0 : a;
      } else {
        // print("herenum");
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
// CONTRAINTS

String USER = '4';
String VENDOR = '3';

double convertKilometerToMiles(double? number) {
  if (number == null) {
    return 0.0;
  }
  return number * 0.62137;
}

String convertDoublePoints(double? number) {
  if (number == null) {
    return "0.0";
  }
  return number.toStringAsFixed(2);
}

Widget emptyWidget({String description = "No data avalable"}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children: [
      SizedBox(
        height: 20,
      ),
      Image.asset(
        "assets/images/crying_apple.png",
        height: 120,
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: kGreyText),
      ),
    ],
  );
}

int convertNumber(num) {
  try {
    // print(num);
    if (num is int) {
      return num;
    }
    if (num != null) {
      int? a = int.tryParse(num);
      // print("a");
      // print(a);
      return a == null ? 0 : a;
    } else {
      // print("herenum");
      return 0;
    }
  } catch (e) {
    print(e);
    return 0;
  }
}

double convertDouble(num) {
  try {
    // print(num);
    if (num is double) {
      return num;
    }
    if (num != null) {
      double? a = double.tryParse(num);
      // print("a");
      // print(a);
      return a == null ? 0 : a;
    } else {
      // print("herenum");
      return 0;
    }
  } catch (e) {
    print(e);
    return 0;
  }
}

int getDifferenceBetweenSeconds(DateTime from){
  int seconds = -1;

  seconds = DateTime.now().difference(from).inSeconds;

  seconds -= 18000;

  return seconds;
}

void showToast(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0);
}

showProgressDialog(context, message, {isDismissable = true}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (buildContext) => AlertDialog(
      content: Row(
        // direction: Axis.horizontal,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: Image.asset("assets/images/logo.gif"),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(child: Text("${message}")),
        ],
      ),
    ),
  );
}

hideProgressDialog(context) {
  Navigator.of(context).pop();
}

Animation<Color?> createColorTween(AnimationController controller) {
  return controller.drive(
    ColorTween(
      begin: Colors.green,
      end: Colors.yellow[700],
    ).chain(CurveTween(curve: Curves.easeInOutCubic)),
  );
}

Widget customPopupItemBuilderExample(
    BuildContext context, title, subtitle, String image, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8),
    decoration: !isSelected
        ? null
        : BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
    child: ListTile(
      selected: isSelected,
      title: title,
      subtitle: subtitle,
      leading: CacheImage(
        url: image,
        width: 40,
        height: 40,
        fit: BoxFit.contain,
      ),
    ),
  );
}

List<String> getPriceArray(@required int multiplesOf) {
  if (multiplesOf > 0) {
    List<String> list = [];
    for (int i = 1; i <= 40; i++) {
      list.add((i * multiplesOf).toString());
    }
    return list;
  } else {
    return [];
  }
}

Widget smartRefreshFooter(BuildContext context, LoadStatus? mode) {
  Widget body;
  // print(mode);
  if (mode == LoadStatus.idle) {
    body = Text("pull up load");
  } else if (mode == LoadStatus.loading) {
    body = AppLoader(
      size: 30.0,
      strock: 1,
    );
  } else if (mode == LoadStatus.failed) {
    body = Text("Load Failed!Click retry!");
  } else if (mode == LoadStatus.canLoading) {
    body = Text("release to load more");
  } else {
    body = Text("No more Data");
  }
  return Center(child: body);
}

Color getRoleColor(String role) {
  return role.toLowerCase() == 'user'
      ? kprimaryColor
      : role.toLowerCase() == 'vendor'
          ? kYellowColor
          : role.toLowerCase() == 'admin'
              ? woodColor
              : role.toLowerCase() == 'provider'
                  ? Colors.grey
                  : logoDarkBlueColor;
}

String convertToAgo(String dateTime) {
  try {
    DateTime input = DateFormat('yyyy-MM-DD HH:mm:ss').parse(dateTime, true);
    // print(input);
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second${diff.inSeconds == 1 ? '' : 's'} ago';
    } else {
      return 'just now';
    }
  } catch (e) {
    print(e);
    return '';
  }
}

String convertTimestampToAgo(int timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('h:mm a');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'DAY AGO';
    } else {
      time = diff.inDays.toString() + 'DAYS AGO';
    }
  }

  return time;
}

showAlertDialog(context, title, message,
    {type = AlertType.INFO,
    okButtonText = 'Ok',
    onPress = null,
    showCancelButton = true,
    dismissible = true}) {
  String icon;

  switch (type) {
    case AlertType.INFO:
      icon = Constraints.infoIcon;
      break;
    case AlertType.SUCCESS:
      icon = Constraints.successIcon;
      break;
    case AlertType.WARNING:
      icon = Constraints.warningIcon;
      break;
    case AlertType.ERROR:
      icon = Constraints.errorIcon;
      break;
    default:
      icon = Constraints.infoIcon;
  }
  showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: dismissible,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      transitionBuilder: (_, anim, __, child) {
        var begin = 0.5;
        var end = 1.0;
        var curve = Curves.bounceOut;
        if (anim.status == AnimationStatus.reverse) {
          curve = Curves.fastLinearToSlowEaseIn;
        }
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return ScaleTransition(
          scale: anim.drive(tween),
          child: child,
        );
      },
      pageBuilder: (BuildContext alertContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(dismissible);
          },
          child: Center(
            child: Container(
              margin: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Material(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          Center(
                            child: Image.asset(
                              icon,
                              width: 50,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${title}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8),
                            child: Text("$message"),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (showCancelButton)
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(alertContext).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                              if (onPress != null)
                                TextButton(
                                  onPressed: onPress,
                                  child: Text("$okButtonText"),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      });
}

int getTimeStamp() {
  DateTime now = DateTime.now();
  return now.microsecondsSinceEpoch;
}

showSnakBar({required title, required message, onTab = null}) async {
  await Future.delayed(Duration(milliseconds: 1500));
  Get.snackbar(title, message,
      colorText: Colors.white,
      duration: Duration(milliseconds: 2000),
      backgroundColor: kprimaryColor.withOpacity(.8), onTap: (a) {
    print("on Notification tab");
    onTab();
  });
}

Future<void> openMap(double lat, double lng) async {
  String url = '';
  String urlAppleMaps = '';
  if (Platform.isAndroid) {
    url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  } else {
    urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
    url = 'comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else if (await canLaunchUrl(Uri.parse(urlAppleMaps))) {
      await launchUrl(Uri.parse(urlAppleMaps));
    } else {
      throw 'Could not launch $url';
    }
  }
}
