// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    required this.message,
    required this.userName,
    required this.isOther,
    this.key,
    required this.url,
    required this.type,
    required this.timestamp,
  });

  final Key? key;
  final String message;
  final String userName;
  final String url;
  final String type;
  final dynamic timestamp;
  final bool isOther;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isOther ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isOther
                ? kprimaryColor.withOpacity(0.9)
                : kYellowColor.withOpacity(0.9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: isOther ? Radius.circular(0) : Radius.circular(12),
              bottomRight: !isOther ? Radius.circular(0) : Radius.circular(12),
            ),
          ),
          // width: 160,
          constraints: BoxConstraints(maxWidth: 250),
          padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            right: 16,
            left: 16,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 6,
            horizontal: 8,
          ),
          child: Column(
            crossAxisAlignment:
            isOther ? CrossAxisAlignment.start : CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isOther ? Colors.white : Colors.white,
                ),
              ),
              if (type == 'image')
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: CacheImage(
                    url: url,
                  ),
                ),
              Wrap(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  if (type != 'file')
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: isOther ? Colors.white : Colors.white,
                        ),
                        textAlign: isOther ? TextAlign.start : TextAlign.start,
                      ),
                    ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      convertTimestampToAgo(timestamp),
                      // getTimeSinceUpload(timestamp),
                      style: TextStyle(
                          color: isOther ? Colors.white70 : Colors.white70,
                          fontSize: 12),
                      textAlign: isOther ? TextAlign.end : TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

// String getTimeSinceUpload(timestamp) {
//   Timestamp time = Timestamp.fromMillisecondsSinceEpoch(0);
//   if(timestamp is Timestamp){
//   time = timestamp;
//   }else{
//     try{
//     time = Timestamp.fromDate(DateTime.parse(timestamp));
//     }catch(e){
//       print("error in converting time: $e");
//     }
//   }
//     if (time == Timestamp.fromMillisecondsSinceEpoch(0)) {
//       return "- - -";
//     }
//     DateTime date = DateTime.parse(time.toDate().toString());
//     DateTime now = DateTime.now();
//     int minutes = now.difference(date).inMinutes;
//     int hours = now.difference(date).inHours;
//     int days = now.difference(date).inDays;
//     double weeks = days / 7;
//     double months = weeks / 4;
//     double years = days / 365;
//
//     if (years >= 1) {
//       String year = " year";
//       if (years >= 2) {
//         year = " years";
//       }
//       return years.toInt().toString() + year;
//     } else if (months >= 1) {
//       String month = " month";
//       if (months >= 2) {
//         month = " months";
//       }
//       return months.toInt().toString() + month;
//     } else if (weeks >= 1) {
//       String week = " week";
//       if (weeks >= 2) {
//         week = " weeks";
//       }
//       return weeks.toInt().toString() + week;
//     } else if (days >= 1) {
//       String day = " day";
//       if (days >= 2) {
//         day = " days";
//       }
//       return days.toInt().toString() + day;
//     } else if (hours >= 1) {
//       String hour = " hour";
//       if (hours >= 2) {
//         hour = " hours";
//       }
//       return hours.toInt().toString() + hour;
//     } else if (minutes >= 1) {
//       String minute = " minute";
//       if (minutes >= 2) {
//         minute = " minutes";
//       }
//       return minutes.toInt().toString() + minute;
//     } else {
//       return "Just now";
//     }
//   }

}
