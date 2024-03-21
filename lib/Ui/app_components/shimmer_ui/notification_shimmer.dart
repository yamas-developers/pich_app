import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context,__) {
          return Column(
            children: [
              Container(
                color: Colors.grey.withOpacity(.3),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child:Container(
                      color: Colors.grey,
                      width: 40,
                      height: 40,
                    )
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 10.0,
                        color: kprimaryColor,
                        ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: getWidth(context),
                        height: 8.0,
                        color: kprimaryColor,
                      ),
                      SizedBox(height: 1,),
                      Container(
                        width: 70,
                        height: 8.0,
                        color: kprimaryColor,
                      ),
                    ],
                  ),
                  // trailing: PopupMenuButton<MenuTile>(
                  //   icon: Icon(Icons.more_horiz),
                  //   itemBuilder: (BuildContext context) {
                  //     return <PopupMenuEntry<MenuTile>>[
                  //       PopupMenuItem(
                  //           value: MenuTile.markAsRead, child: Text('Mark as Read')),
                  //       PopupMenuItem(
                  //         child: Text('Delete'),
                  //         value: MenuTile.delete,
                  //       )
                  //     ];
                  //   },
                  // ),
                ),
              ),
              Divider(),
              SizedBox(height: 1,)
            ],
          );
        }
      ),
    );
  }
}
