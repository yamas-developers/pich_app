import 'dart:io';

import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/posts/post_comment_sheet.dart';
import 'package:farmer_app/Ui/posts/post_detail.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/post_data.dart';
import 'package:farmer_app/providers/post/post_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/src/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../providers/search/profiles_provider.dart';
import '../../providers/social/social_provider.dart';
import '../../providers/user/user_provider.dart';

class PostItem extends StatefulWidget {
  PostData? postData;

  PostItem({@required this.postData});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  late VideoPlayerController _controller;
  String? fileName;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    getPagedata();
    super.initState();
  }

  List<String> thumbnailList = [];

  // getThumbnails(PostData postData) async {
  //   if (postData!.postVideos!.isNotEmpty) {
  //     dynamic path = await VideoThumbnail
  //         .thumbnailFile(
  //       video:
  //       "${MJ_Apis.APP_BASE_URL}${postData!.postVideos![0].video!}",
  //       thumbnailPath: (await getTemporaryDirectory())
  //           .path,
  //       imageFormat: ImageFormat.JPEG,
  //       maxHeight: 260,
  //       // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
  //       quality: 100,
  //     );
  //
  //     setState(() {
  //       fileName = path;
  //     });
  //     thumbnailList.clear();
  //     thumbnailList.add(fileName!);
  //     return thumbs;
  //   }
  // }

  getPagedata() async {
    if ((widget.postData?.postVideos?.length ?? 0) < 0) {
      setState(() {
        loading = false;
      });
      return;
    }
    String? fileName = await getThumbnails(widget.postData!);
    if (fileName != null) {
      thumbnailList.clear();

      thumbnailList.add(fileName);
    }
    setState(() {
      thumbnailList = thumbnailList;
      loading = false;
    });

    // _controller = VideoPlayerController.network(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
    //   ..initialize().then((_) {
    //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    //     setState(() {});
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return widget.postData == null
        ? SizedBox()
        : Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Row(
                  children: [
                    if (widget.postData!.postUser != null)
                      ClipRRect(
                        // backgroundColor: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        child: CacheImage(
                          url:
                              "${MJ_Apis.APP_BASE_URL}${widget.postData!.postUser!.profileImage}",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.postData!.postUser != null)
                            Row(
                              children: [
                                Text(
                                  "${widget.postData!.postUser!.firstname} ${widget.postData!.postUser!.lastname}",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          Row(
                            children: [
                              Text(
                                "${DateFormat('h:mm a - MMM dd, yyyy').format(DateTime.parse(widget.postData!.createdAt!))}",
                                style: TextStyle(color: kGreyText),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    // IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
                    CupertinoButton(
                      onPressed: () {
                        showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoActionSheet(
                              title: Text('Options'),
                              actions: <Widget>[
                                CupertinoActionSheetAction(
                                  child: Text('I want to report this post'),
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    showAlertDialog(
                                      context,
                                      'Reporting this post\n',
                                      'Are you sure you want to report this post?. '
                                          'This will immediately be removed from your timeline'
                                          ' and will be flagged as inappropriate.',
                                      okButtonText: 'Report',
                                      onPress: () {
                                        Navigator.pop(context);
                                        _showReasonDialog(context);
                                      },
                                      type: AlertType.WARNING,
                                    );
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text('I want to block this user'),
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    showAlertDialog(
                                      context,
                                      'Blocking ${widget.postData?.postUser?.firstname ?? ''} ${widget.postData?.postUser?.lastname} \n',
                                      ' Are you sure you want to block ${widget.postData?.postUser?.firstname ?? ''} ${widget.postData?.postUser?.lastname}?'
                                          ' All posts from this user will immediately be removed from your timeline'
                                          ' and you will not be able to see this user.',
                                      okButtonText: 'Block',
                                      onPress: () async {
                                        Navigator.pop(context);
                                        bool res = await context
                                            .read<UserProvider>()
                                            .blockUser(
                                                widget.postData?.postUser?.id);
                                        if (res) {
                                          showToast(
                                              "Successfully blocked user");
                                          context
                                              .read<PostProvider>()
                                              .removePostsFromUser(widget
                                                  .postData?.postUser?.id);

                                          context
                                              .read<SocialProvider>()
                                              .removeUser(widget
                                                  .postData?.postUser?.id);

                                          context
                                              .read<ProfilesProvider>()
                                              .removeUser(widget
                                                  .postData?.postUser?.id);
                                        } else {
                                          showToast(
                                              "Unable to block, please try again later");
                                        }
                                        Navigator.pop(context);
                                      },
                                      type: AlertType.WARNING,
                                    );
                                  },
                                ),
                                CupertinoActionSheetAction(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    // Handle cancel action
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(CupertinoIcons.ellipsis),
                    ),
                    // Image.asset("assets/icons/about.png")
                  ],
                ),
              ),
              SizedBox(
                height: 6,
              ),
              if (widget.postData!.description != null)
                Container(
                  padding: EdgeInsets.only(left: 10),
                  width: getWidth(context),
                  child: Text(
                    "${widget.postData!.description}",
                    maxLines: 2,
                    style: TextStyle(
                        color: Colors.grey[700],
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              SizedBox(
                height: 6,
              ),
              TouchableOpacity(
                onTap: () {
                  if (loading) return;
                  Navigator.pushNamed(context, PostDetailScreen.routeName,
                      arguments: [widget.postData, thumbnailList]);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: widget.postData!.postImages!.isNotEmpty
                      ? Container(
                          height: 260,
                          width: getWidth(context),
                          child: CacheImage(
                            url:
                                "${MJ_Apis.APP_BASE_URL}${widget.postData!.postImages!.first.image}",
                            fit: BoxFit.cover,
                          ),
                        )
                      : widget.postData!.postVideos!.isNotEmpty
                          ? fileName != null
                              ? Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: FileImage(
                                      File(fileName!),
                                    ),
                                    fit: BoxFit.cover,
                                  )),
                                  height: 260,
                                  width: getWidth(context),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    size: 80,
                                    color: Colors.white,
                                  ))
                              : Container(
                                  color: Colors.grey.withOpacity(.6),
                                  height: 260,
                                  width: getWidth(context),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    size: 80,
                                    color: Colors.white,
                                  ))
                          : SizedBox(),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        int count =
                            convertNumber(widget.postData!.postMyLikesCount);
                        if (count > 0) {
                          context
                              .read<PostProvider>()
                              .likePost(widget.postData!.id, 'unlike');
                          setState(() {
                            widget.postData!.postMyLikesCount = 0;
                            widget.postData!.postLikesCount =
                                widget.postData!.postLikesCount! - 1;
                          });
                        } else {
                          context
                              .read<PostProvider>()
                              .likePost(widget.postData!.id, 'like');
                          setState(() {
                            widget.postData!.postMyLikesCount = 1;
                            widget.postData!.postLikesCount =
                                widget.postData!.postLikesCount! + 1;
                          });
                        }
                      },
                      child: Image.asset(
                        "assets/icons/Heart.png",
                        height: 22,
                        color:
                            convertNumber(widget.postData!.postMyLikesCount) > 0
                                ? Colors.red
                                : Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "${widget.postData!.postLikesCount}",
                      style: TextStyle(fontSize: 10, color: kGreyText),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    InkWell(
                        onTap: () {
                          bottomModalComment(context, widget.postData!.id);
                        },
                        child: Image.asset("assets/icons/message.png",
                            height: 22, color: Colors.grey[600])),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "${widget.postData!.postCommentsCount}",
                      style: TextStyle(fontSize: 10, color: kGreyText),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    // Image.asset("assets/icons/share.png")
                  ],
                ),
              ),
            ],
          );
  }

  _reprtPost() {
    // context.read<PostProvider>().reportPost(widget.postData?.id, reason)
  }

  void _showReasonDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _reasonController = TextEditingController();
        return CupertinoAlertDialog(
          title: Text('Report Reason'),
          content: CupertinoTextField(
            controller: _reasonController,
            placeholder: 'Enter your reason',
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: Text('Okay'),
              onPressed: () async {
                if (_reasonController.text.isEmpty) {
                  showToast('Plese enter a reason to report');
                  return;
                }
                bool res = await context
                    .read<PostProvider>()
                    .reportPost(widget.postData?.id, _reasonController.text);
                if (res) {
                  showToast("Successfully reported this post");
                } else {
                  showToast("Unable to report, please try again later");
                }
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Close the action sheet
              },
            ),
          ],
        );
      },
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
}
