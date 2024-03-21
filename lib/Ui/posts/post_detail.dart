import 'dart:io';

import 'package:farmer_app/Ui/app_components/app_back_button.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/posts/post_comment_sheet.dart';
import 'package:farmer_app/Ui/posts/post_video_screen.dart';
import 'package:farmer_app/Ui/user_profile/ProfileScreen.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/post_data.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/post/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../helpers/color_constants.dart';

class PostDetailScreen extends StatefulWidget {
  static const routeName = '/post_detail';

  const PostDetailScreen();

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  PostData? _postData;
  List thumbnailList = [];
  bool loading = false;

  @override
  void didChangeDependencies() {
    dynamic args = ModalRoute.of(context)!.settings.arguments;
    _postData = args[0];
    thumbnailList = args[1];
    getPageData();

    super.didChangeDependencies();
  }

  User? user = User();

  getPageData() async {
    user = (await getUser())!;

    if (_postData!.postVideos!.isNotEmpty) {
      if (_postData!.postVideos!.length > 0) {
        int j = 0;
        setState(() {
          loading = true;
        });
        if (thumbnailList.isNotEmpty) j = 1;
        for (int i = j; i < _postData!.postVideos!.length; i++) {
          dynamic path = await VideoThumbnail.thumbnailFile(
            video: "${MJ_Apis.APP_BASE_URL}${_postData!.postVideos![i].video!}",
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.JPEG,
            maxHeight: 260,
            // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
            quality: 100,
          );

          thumbnailList[i] = path;
        }
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: getDefaultAppBackButton(),
        // title: Text('Post Details'),
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.transparent,
        // title: Text("Post Detail",
        // style: TextStyle(
        //   color: Colors.black
        // ),),
      ),
      body: SingleChildScrollView(
        child: _postData == null
            ? Text("Cannot get data")
            : Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  if (_postData!.postUser != null)
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: Row(
                        children: [
                          TouchableOpacity(
                            onTap: () {

                              dynamic args = null;

                              if(user!.id == _postData!.postUser!.id.toString()){
                                return;
                              }
                              else {
                                args = {
                                  'id': _postData!.postUser!.id.toString(),
                                  'roles': _postData!.postUser!.roles == null
                                      ? 'other'
                                      : _postData!.postUser!.roles!.name
                                };
                              }
                              Navigator.pushReplacementNamed(context, Profile.routeName,
                                  arguments: args);
                              // print('rolesID: ${widget.profileData.roles!.name}');
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                child: CacheImage(
                                  url:
                                      "${MJ_Apis.APP_BASE_URL}${_postData!.postUser!.profileImage}",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${_postData!.postUser!.firstname} ${_postData!.postUser!.lastname}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.parse(_postData!.createdAt!))}",
                                      style: TextStyle(color: kGreyText),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Spacer(),
                          // Image.asset("assets/icons/about.png")
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 2, 4, 0),
                    child: Column(children: [
                      if (_postData!.description != null)
                        Container(
                            width: getWidth(context),
                            child: Text("${_postData!.description}")),

                      //
                      SizedBox(
                        height: 6,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 20),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                int count =
                                    convertNumber(_postData!.postMyLikesCount);
                                if (count > 0) {
                                  context
                                      .read<PostProvider>()
                                      .likePost(_postData!.id, 'unlike');
                                  setState(() {
                                    _postData!.postMyLikesCount = 0;
                                    _postData!.postLikesCount =
                                        _postData!.postLikesCount! - 1;
                                  });
                                } else {
                                  context
                                      .read<PostProvider>()
                                      .likePost(_postData!.id, 'like');
                                  setState(() {
                                    _postData!.postMyLikesCount = 1;
                                    _postData!.postLikesCount =
                                        _postData!.postLikesCount! + 1;
                                  });
                                }
                              },
                              child: Image.asset(
                                "assets/icons/Heart.png",height: 22,
                                color:
                                    convertNumber(_postData!.postMyLikesCount) >
                                            0
                                        ? Colors.red
                                        : Colors.grey[600],
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "${_postData!.postLikesCount}",
                              style: TextStyle(fontSize: 10, color: kGreyText),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                            InkWell(
                                onTap: () {
                                  bottomModalComment(context, _postData!.id);
                                },
                                child: Image.asset("assets/icons/message.png",height: 22,color: Colors.grey[600])),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "${_postData!.postCommentsCount}",
                              style: TextStyle(fontSize: 10, color: kGreyText),
                            ),
                            SizedBox(
                              width: 40,
                            ),
                          ],
                        ),
                      ),
                      if (_postData!.postImages != null)
                        Column(
                            children: List.generate(
                                _postData!.postImages!.length,
                                (index) => Container(
                                      padding: EdgeInsets.all(10),
                                      // height: 260,
                                      width: getWidth(context),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CacheImage(
                                          url:
                                              "${MJ_Apis.APP_BASE_URL}${_postData!.postImages![index].image}",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ))),
                      if (_postData!.postVideos != null &&
                          thumbnailList != null)
                        Column(
                            children: !loading
                                ? List.generate(
                                    thumbnailList.length,
                                    (index) => TouchableOpacity(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                PostVideoScreen.routeName,
                                                arguments:
                                                    '${MJ_Apis.APP_BASE_URL}${_postData!.postVideos![index].video}');
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            // height: 260,
                                            width: getWidth(context),
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    width: getWidth(context),
                                                    child: Image.file(
                                                      File(
                                                          thumbnailList[index]),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                Positioned.fill(
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.play_arrow_rounded,
                                                      size: 120,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ))
                                : List.generate(
                                    _postData!.postVideos!.length,
                                    (index) => Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(4, 8, 8, 8),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(.6),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          height: 260,
                                          width: getWidth(context),
                                          child: Center(
                                            // height: 50,
                                            // width: 50,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )),
                                    ),
                                  )),
                    ]),
                  ),
                ],
              ),
      ),
    );
  }

  Future bottomModalComment(BuildContext context, id) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        context: context,
        builder: (context) {
          return PostCommentSheet(id: id);
        });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }
}
