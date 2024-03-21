import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmer_app/Ui/app_components/badge.dart';
import 'package:farmer_app/Ui/app_components/placeholder_image.dart';
import 'package:farmer_app/Ui/user_profile/ProfileScreen.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/models/post_comment.dart';
import 'package:farmer_app/models/search_profile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCommentItem extends StatefulWidget {
  final PostComment commentItem;
  final String? selfId;

  const PostCommentItem({
    Key? key,
    required this.commentItem,
    required this.selfId,
  }) : super(key: key);

  @override
  State<PostCommentItem> createState() => _PostCommentItemState();
}

class _PostCommentItemState extends State<PostCommentItem> {
  String role_name = 'User';
  bool isFollowed = false;
  bool latest = false;

  @override
  void initState() {
    bool temp = getDifferenceBetweenSeconds(DateTime.parse(widget.commentItem.createdAt!)) < 5;
   if(temp){
     setState(() {
       latest = temp;
     });
     Future.delayed(Duration(seconds: 1)).then((value){
       setState(() {
         latest = false;
       });
     });
   }
    // if(latest)

    // role_name = widget.profileData.roles!.name ?? 'User';
    // isFollowed = widget.profileData.followersCount! > 0 ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        setState(() {
          latest = !latest;
        });
        // Navigator.pushNamed(context, Profile.routeName,
        //     arguments: {'id':widget.profileData.id.toString(), 'roles': widget.profileData.roles!.name});
        // print('rolesID: ${widget.profileData.roles!.name}');
      },
      child: AnimatedContainer(
        duration: Duration(seconds: 5),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: latest ? Colors.grey.withOpacity(0.3) : Colors.transparent,),
        child: Row(
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: getRoleColor(role_name)),
                    borderRadius: BorderRadius.circular(40),

    ),

                // radius: 25,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: PlaceHolderImage(
                        url:
                            '${MJ_Apis.APP_BASE_URL}${widget.commentItem.user!.profileImage}',
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      )),
                )),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 170,
                  child: Text(
                    "${widget.commentItem.user!.firstname} ${widget.commentItem.user!.lastname}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                SizedBox(
                  width: 240,
                  child: Text(
                    "${widget.commentItem.comment}",
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.parse(widget.commentItem.createdAt!))}",
                  style: TextStyle(color: Colors.grey,fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
