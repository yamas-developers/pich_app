// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, file_names, unnecessary_import, sized_box_for_whitespace

import 'dart:convert';
import 'dart:ui';
import 'package:farmer_app/Ui/app_components/app_back_button.dart';
import 'package:farmer_app/Ui/chat/chat_detail.dart';
import 'package:farmer_app/Ui/user_profile/user_dynamic_forms.dart';
import 'package:farmer_app/Ui/user_profile/user_profile_vendor_stores.dart';
import 'package:farmer_app/config/mj_config.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/models/conversation.dart';
import 'package:farmer_app/models/dynamic_form.dart';
import 'package:farmer_app/models/user_profile.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/post.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/post_item_shimmer.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/profiler_header_shimmer.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/order_details//OrderDetails.dart';
import 'package:farmer_app/Ui/orders/user/order_user_item.dart';
import 'package:farmer_app/Ui/posts/post_item.dart';
import 'package:farmer_app/Ui/user_profile/edit_profile.dart';
import 'package:farmer_app/Ui/user_profile/profile_order_section.dart';
import 'package:farmer_app/Ui/user_profile/profile_post_section.dart';
import 'package:farmer_app/Ui/user_profile/profile_vouchers_section.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/post_data.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/models/user_profile.dart';
import 'package:farmer_app/providers/chat/conversation_provider.dart';
import 'package:farmer_app/providers/post/profile_posts_provider.dart';
import 'package:farmer_app/providers/user/my_profile_provider.dart';
import 'package:farmer_app/providers/user/user_dynamic_form_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:farmer_app/Ui/search/search_screen_sheet.dart';
import 'package:farmer_app/providers/social/social_provider.dart';

import '../../providers/post/post_provider.dart';
import '../../providers/search/profiles_provider.dart';
import '../../providers/user/user_provider.dart';

class Profile extends StatefulWidget {
  static const String routeName = "/profile";

  Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  TabController? _tabControllerVendor;
  TabController? _tabControllerSelfUser;
  TabController? _tabControllerOtherUser;
  User user = User();
  RefreshController _refreshController = RefreshController();
  bool isLoading = false;
  String userId = '';
  bool isSelf = true;
  bool init = true;
  User otherUserProfile = User();
  bool showBackButton = false;
  String roles = '';

  @override
  void initState() {
    _tabControllerVendor = TabController(length: 2, vsync: this);
    _tabControllerSelfUser = TabController(length: 3, vsync: this);
    _tabControllerOtherUser = TabController(length: 1, vsync: this);
    if (init) {
      Future.delayed(Duration.zero).then((value) {
        init = false;
      });
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (init) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => getPageData());
    }
    super.didChangeDependencies();
  }

  getFormData() async {
    User _user = (await getUser())!;
    context.read<UserDynamicFormProvider>().isLoading = true;
    var response =
        await MjApiService().getRequest(MJ_Apis.get_forms + "/${_user.id}");
    context.read<UserDynamicFormProvider>().isLoading = false;
    if (response != null) {
      List<DynamicForm> list = [];
      print(response);
      for (int i = 0; i < response.length; i++) {
        if (response[i]['field'] == null) {
          continue;
        }
        if (response[i]['field'].length < 1) {
          continue;
        }
        if (DynamicForm.fromJson(response[i]).userForm == null) {
          list.add(DynamicForm.fromJson(response[i]));
        }
      }
      context.read<UserDynamicFormProvider>().set(list);
    }
  }

  getPageData() async {
    setState(() {
      isLoading = true;
    });
    context.read<MyProfileProvider>().isLoading = true;

    dynamic arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null) {
      setState(() {
        userId = arguments['id'] ?? '';
        isSelf = userId != '' ? false : true;
        roles = arguments['roles'] ?? 'other';
      });
      print('args: ${arguments['id']}');
    } else {
      setState(() {
        // roles = 'other';
        // userId = '';
        isSelf = true;
      });
    }

    // print('roles: ${arguments['roles']??''}');
    User? userData = await getUser();

    setState(() {
      user = userData!;
    });
    if (isSelf) {
      setState(() {
        roles = user.rolesId.toString() == VENDOR ? 'vendor' : 'user';
        userId = user.id ?? '';
        showBackButton = true;
      });
      getFormData();
    }
    await getProfileData(userId);
    context.read<MyProfileProvider>().isLoading = false;
    setState(() {
      isLoading = false;
    });

    // if (context.read<ProfilePostProvider>().currentPage < 1) getPostData();
  }

  @override
  void dispose() {
    _tabControllerSelfUser!.dispose();
    _tabControllerOtherUser!.dispose();
    _tabControllerVendor!.dispose();
    super.dispose();
  }

  // ==============> Get Profile Data
  getProfileData(String userId) async {
    context.read<MyProfileProvider>().isLoading = true;
    if (!isSelf) {
      var response =
          await MjApiService().getRequest(MJ_Apis.get_profile + "/${userId}");

      if (response != null) {
        otherUserProfile = User.fromJson(response);
      }
    } else {
      var response =
          await MjApiService().getRequest(MJ_Apis.get_profile + "/${userId}");
      if (response != null) {
        context.read<MyProfileProvider>().setMyProfile(User.fromJson(response));
      }
    }
    context.read<MyProfileProvider>().isLoading = false;
  }

  // ignore: prefer_typing_uninitialized_variables
  var size, height, width;
  bool isPortrait = true;

  GlobalKey? _postkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print('isSelf: ${isSelf}');
    print('roles: ${roles}');
    print('userId: ${userId}');
    dynamic postCallback = () {
      if (_postkey != null && _postkey!.currentContext != null) {
        _tabControllerOtherUser!.index = 0;
        _tabControllerSelfUser!.index = 0;
        _tabControllerVendor!.index = 0;
        Scrollable.ensureVisible(
          _postkey!.currentContext!,
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
    };
    return Scaffold(
        backgroundColor: Color.fromRGBO(243, 243, 243, 1),
        appBar: AppBar(
          // leading:
          backgroundColor: kprimaryColor,
          toolbarHeight: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<MyProfileProvider>(builder: (key, provider, child) {
            return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScroll) {
                return <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (!isSelf)
                              AppBackButton(
                                width: 26,
                              ),
                            SizedBox(
                              width: 10,
                            ),
                            if (isSelf)
                              Text(
                                "Welcome  ",
                                style: TextStyle(
                                    fontSize: 20,
                                    // color: kprimaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Montserrat"),
                              ),
                            if (isSelf)
                              Text(
                                "${user.username ?? ''}",
                                style: TextStyle(
                                    color: kprimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Montserrat"),
                              )
                            else
                              Row(
                                children: [
                                  Text(
                                    "${otherUserProfile.username ?? ''}",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: kprimaryColor,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Montserrat"),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        Spacer(),
                        if (isSelf)
                          TouchableOpacity(
                            onTap: () {
                              showProfileMenuBottomSheet(context);
                            },
                            child: Icon(Icons.menu),
                          )
                        else if (otherUserProfile.id != null)
                          TouchableOpacity(
                            onTap: () async {
                              print('id in profile: ${otherUserProfile.id}');

                              // return;

                              Conversation? conversation = await context
                                  .read<ConversationProvider>()
                                  .checkChat(
                                      context: context,
                                      otherUserId: otherUserProfile.id,
                                      selfId: userId);
                              // if(conversation == null)

                              if (conversation == null) {
                                showAlertDialog(context, "Warning!",
                                    "Cannot start chat right now please try again later",
                                    okButtonText: 'Ok', onPress: () {
                                  Navigator.of(context).pop();
                                }, type: AlertType.WARNING);
                                return;
                              }
                              bool isExist = true;
                              if (conversation.id == null) {
                                isExist = false;
                              }
                              Navigator.pushNamed(context, ChatDetail.routeName,
                                  arguments: {
                                    "user": otherUserProfile,
                                    "conversation": conversation,
                                    "type": "profile",
                                    "isExist": isExist
                                  });
                            },
                            child: Icon(Icons.message),
                          ),
                        if (otherUserProfile.id != null)
                          CupertinoButton(
                            onPressed: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoActionSheet(
                                    title: Text('Options'),
                                    actions: <Widget>[
                                      CupertinoActionSheetAction(
                                        child:
                                            Text('I want to block this user'),
                                        onPressed: () {
                                          // Navigator.pop(context);
                                          showAlertDialog(
                                            context,
                                            'Blocking ${otherUserProfile.username ?? 'this user'} \n',
                                            ' Are you sure you want to block ${otherUserProfile.username ?? 'this user'}?'
                                                ' All posts from this user will immediately be removed from your timeline'
                                                ' and you will not be able to see this user.',
                                            okButtonText: 'Block',
                                            onPress: () async {
                                              Navigator.pop(context);
                                              bool res = await context
                                                  .read<UserProvider>()
                                                  .blockUser(
                                                      otherUserProfile.id);
                                              if (res) {
                                                showToast(
                                                    "Successfully blocked user");
                                                context
                                                    .read<PostProvider>()
                                                    .removePostsFromUser(
                                                        otherUserProfile.id);

                                                context
                                                    .read<SocialProvider>()
                                                    .removeUser(
                                                        otherUserProfile.id);

                                                context
                                                    .read<ProfilesProvider>()
                                                    .removeUser(
                                                        otherUserProfile.id);
                                              } else {
                                                showToast(
                                                    "Unable to block, please try again later");
                                              }
                                              Navigator.pop(context);
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
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    if (isSelf && roles.toLowerCase() != 'vendor')
                      ProfileScreenHeader(
                        tabController: _tabControllerSelfUser,
                        currentUser: provider.currentUser,
                        isLoading: provider.isLoading,
                        postCallback: postCallback,
                        tabs: [
                          Tab(
                            text: 'Posts',
                          ),
                          Tab(
                            text: 'Vouchers',
                          ),
                          Tab(
                            text: 'Orders',
                          )
                        ],
                      )
                    else if (!isSelf && roles.toLowerCase() == 'vendor')
                      ProfileScreenHeader(
                        tabController: _tabControllerVendor,
                        currentUser:
                            isSelf ? provider.currentUser : otherUserProfile,
                        isLoading: isSelf ? provider.isLoading : isLoading,
                        isSelf: isSelf,
                        postCallback: postCallback,
                        tabs: [
                          Tab(
                            text: 'Posts',
                          ),
                          Tab(
                            text: 'Stores',
                          ),
                        ],
                      )
                    else if (isSelf && roles.toLowerCase() == 'vendor')
                      ProfileScreenHeader(
                        tabController: _tabControllerOtherUser,
                        currentUser: provider.currentUser,
                        isLoading: provider.isLoading,
                        isSelf: isSelf,
                        postCallback: postCallback,
                        tabs: [
                          Tab(
                            text: 'Posts',
                          ),
                        ],
                      )
                    else
                      ProfileScreenHeader(
                        tabController: _tabControllerOtherUser,
                        currentUser: otherUserProfile,
                        isLoading: isLoading,
                        isSelf: isSelf,
                        postCallback: postCallback,
                        tabs: [
                          Tab(
                            text: 'Posts',
                          ),
                        ],
                      ),
                  ]))
                ];
              },
              body: SafeArea(
                child: SizedBox(
                  height: height,
                  child: TabBarView(
                    key: _postkey,
                    controller: isSelf && roles.toLowerCase() != 'vendor'
                        ? _tabControllerSelfUser
                        : !isSelf && roles.toLowerCase() == 'vendor'
                            ? _tabControllerVendor
                            : _tabControllerOtherUser,
                    children: [
                      // provider.isLoading ? PostListSimmer():
                      ProfilePostSection(
                        userId: userId,
                        key: UniqueKey(),
                      ),

                      //second tab content

                      if (isSelf && roles.toLowerCase() != 'vendor')
                        ProfileVoucersSection(),
                      //third Tab content
                      if (isSelf && roles.toLowerCase() != 'vendor')
                        ProfileOrderSection(userId: user.id ?? ''),
                      if (!isSelf && roles.toLowerCase() == 'vendor')
                        UserProfileVendorStores(userId: userId)
                    ],
                  ),
                ),
              ),
            );
          }),
        ));
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<Conversation?> checkChat(otherUserId) async {
    try {
      User user = (await getUser())!;
      List list = [user.id, otherUserId];
      var payload = {"user_ids": jsonEncode(list)};
      showProgressDialog(context, MJConfig.please_wait);
      var response = await MjApiService()
          .postRequest(MJ_Apis.check_chat + "/${userId}", payload);
      hideProgressDialog(context);
      if (response != null) {
        // Conversation conversation;
        // otherUserProfile = UserProfile.fromJson(response);
        if (response.isNotEmpty) {
          return Conversation.fromJson(response);
        } else {
          return Conversation();
        }
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class ProfileScreenHeader extends StatelessWidget {
  ProfileScreenHeader(
      {Key? key,
      required TabController? tabController,
      this.isSelf = true,
      required this.currentUser,
      required this.tabs,
      this.isLoading = false,
      this.postCallback})
      : _tabController = tabController,
        super(key: key);

  final TabController? _tabController;
  final User currentUser;
  bool isLoading;
  bool isSelf;
  List<Widget> tabs;
  dynamic postCallback;

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      // clipBehavior: Overflow.visible,
      children: [
        Container(
          margin: EdgeInsets.only(top: 52),
          // height: 135,
          //width: 343,
          decoration: BoxDecoration(
              color: kprimaryColor, borderRadius: BorderRadius.circular(19.0)),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 34,
              ),
              isLoading && currentUser.id == null
                  ? ProfileHeaderShimmer()
                  : Column(
                      children: [
                        Center(
                          child: Text(
                            "${currentUser.firstname} ${currentUser.lastname}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        if (isSelf && currentUser.rolesId.toString() != VENDOR)
                          Consumer<UserDynamicFormProvider>(
                              builder: (key, provider, child) {
                            return provider.list.length < 1
                                ? SizedBox()
                                : TouchableOpacity(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, UserDynamicForms.routeName);
                                    },
                                    child: Text(
                                      "${provider.list.length} Form: Missing Information",
                                      style: TextStyle(
                                          color: Colors.deepOrangeAccent[700],
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                  );
                          }),
                        SizedBox(
                          height: 2,
                        ),
                        if (currentUser.rolesId.toString() == VENDOR)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/location_icon.png",
                                height: 12,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                currentUser.address == null
                                    ? "No Address Found"
                                    : "${currentUser.address}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .shadowColor
                                    .withOpacity(.5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.white.withOpacity(.4))),
                            child: Flex(
                              direction: Axis.horizontal,
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: TouchableOpacity(
                                      onTap: () {
                                        context.read<SocialProvider>().type =
                                            'followers';
                                        Navigator.pushNamed(
                                          context,
                                          SocialScreenSheet.routeName,
                                        );
                                      },
                                      child: Column(children: [
                                        Text(
                                          "Followers",
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "${currentUser.followersCount}",
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ]),
                                    )),
                                Expanded(
                                  flex: 1,
                                  child: TouchableOpacity(
                                    onTap: () {
                                      context.read<SocialProvider>().type =
                                          'following';
                                      Navigator.pushNamed(
                                        context,
                                        SocialScreenSheet.routeName,
                                      );
                                    },
                                    child: Column(children: [
                                      Text(
                                        "Following",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "${currentUser.followingCount}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TouchableOpacity(
                                    onTap: postCallback,
                                    child: Column(children: [
                                      Text(
                                        "Posts",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "${currentUser.postsCount}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ]),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

              // SizedBox(
              //   height: 10,
              // ),
              Container(
                height: 40,
                transform: Matrix4.translationValues(0, 10, 0),
                decoration: BoxDecoration(),
                child: Center(
                  child: TabBar(
                    labelPadding:
                        EdgeInsets.only(bottom: 19, left: 12, right: 12),
                    isScrollable: true,
                    indicator:
                        CircleTabIndicator(color: kYellowColor, radius: 8),
                    labelColor: kYellowColor,
                    unselectedLabelColor: Colors.white,
                    controller: _tabController,
                    tabs: tabs,
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            child: isLoading && currentUser.id == null
                ? ProfileImageSimmer()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: kprimaryColor,
                      ),
                      child: CacheImage(
                        fit: BoxFit.cover,
                        width: 84,
                        height: 84,
                        url:
                            "${MJ_Apis.APP_BASE_URL}${currentUser.profileImage}",
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({required Color color, required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius - 5);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
// Column buildpost(index) {
//   return Column(
//     children: [
//       SizedBox(
//         height: 15,
//       ),
//       Padding(
//         padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: Colors.white,
//               radius: 30,
//               child: Image.asset("assets/images/Ellipse.png"),
//             ),
//             Padding(
//               padding: EdgeInsets.all(5.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         "Jessica Melinda",
//                         style: TextStyle(fontSize: 13),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         "12 Jan 2022",
//                         style: TextStyle(color: kGreyColor),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Spacer(),
//             Image.asset("assets/icons/about.png")
//           ],
//         ),
//       ),
//       SizedBox(
//         height: 6,
//       ),
//       Container(
//         height: 260,
//         width: width,
//         child: Image.asset(
//           "assets/images/post.png",
//           fit: BoxFit.fill,
//         ),
//       ),
//       SizedBox(
//         height: 6,
//       ),
//       Padding(
//         padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
//         child: Row(
//           children: [
//             Image.asset("assets/icons/Heart.png"),
//             SizedBox(
//               width: 4,
//             ),
//             Text(
//               "143k",
//               style: TextStyle(fontSize: 10, color: Colors.black),
//             ),
//             SizedBox(
//               width: 40,
//             ),
//             Image.asset("assets/icons/message.png"),
//             SizedBox(
//               width: 4,
//             ),
//             Text(
//               "143k",
//               style: TextStyle(fontSize: 10, color: kGreyColor),
//             ),
//             SizedBox(
//               width: 40,
//             ),
//             Image.asset("assets/icons/share.png")
//           ],
//         ),
//       ),
//     ],
//   );
// }
