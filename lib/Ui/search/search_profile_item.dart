import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmer_app/Ui/app_components/badge.dart';
import 'package:farmer_app/Ui/app_components/placeholder_image.dart';
import 'package:farmer_app/Ui/user_profile/ProfileScreen.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/models/search_profile.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/material.dart';

class SearchProfileItem extends StatefulWidget {
  final User profileData;
  final String? selfId;

  const SearchProfileItem({
    Key? key,
    required this.profileData,
    required this.selfId,
  }) : super(key: key);

  @override
  State<SearchProfileItem> createState() => _SearchProfileItemState();
}

class _SearchProfileItemState extends State<SearchProfileItem> {
  String role_name = 'User';
  bool isFollowed = false;

  @override
  void initState() {
    getPageData();
    super.initState();
  }
  getPageData(){
    if(widget.profileData.roles != null) role_name =
        widget.profileData.roles!.name ??
            'User';
    isFollowed = convertNumber(widget.profileData.followersCount!) > 0 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    // print("roles: ${widget.profileData.roles!.name}");
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, Profile.routeName,
            arguments: {'id':widget.profileData.id.toString(), 'roles': widget.profileData.roles != null ? widget.profileData.roles!.name : "User"});
        // print('rolesID: ${widget.profileData.roles!.name}');
      },
      child: Container(
        child: Row(
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: getRoleColor(role_name)),
                    borderRadius: BorderRadius.circular(40)),
                // radius: 25,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: PlaceHolderImage(
                        url:
                            '${MJ_Apis.APP_BASE_URL}${widget.profileData.profileImage}',
                        width: 40,
                        height: 40,
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
                    "${widget.profileData.firstname} ${widget.profileData.lastname}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Text(
                  "@${widget.profileData.username}",
                  style: TextStyle(color: Colors.blueGrey),
                ),
                SizedBox(
                  height: 8,
                ),
                Badge(
                  value: '${role_name}',
                  color: getRoleColor(role_name),
                )
              ],
            ),
            Spacer(),
            TextButton(
              onPressed: () async {
                MjApiService apiService = MjApiService();
                if (isFollowed) {
                  dynamic payload = {
                    "other_user_id": widget.profileData.id.toString(),
                    "type": "unfollow",
                  };
                  setState(() {
                    isFollowed = false;
                    widget.profileData.followersCount = '0';
                  });
                  print(payload);
                  dynamic response = await apiService.postRequest(
                      "${MJ_Apis.follow}/${widget.selfId}", payload);
                } else {
                  dynamic payload = {
                    "other_user_id": widget.profileData.id.toString(),
                    "type": "follow",
                  };
                  setState(() {
                    isFollowed = true;
                    widget.profileData.followersCount = '1';
                  });
                  print(payload);

                  dynamic response = await apiService.postRequest(
                      "${MJ_Apis.follow}/${widget.selfId}", payload);
                }
              },
              child: Text(
                isFollowed ? 'Unfollow -' : 'Follow +',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: getRoleColor(role_name)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
