import 'package:farmer_app/Ui/app_components/app_logo.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/placeholder_image.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/chat_shimmer.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/search_user_item_shimmer.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/search/search_profile_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/conversation.dart';
import 'package:farmer_app/models/search_profile.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/chat/conversation_provider.dart';
import 'package:farmer_app/providers/search/profiles_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'chat_detail.dart';

class ChatFollowersArea extends StatefulWidget {
  const ChatFollowersArea({
    Key? key,
    required this.type,
  }) : super(key: key);
  final String type;

  @override
  State<ChatFollowersArea> createState() => _ChatFollowersAreaState();
}

class _ChatFollowersAreaState extends State<ChatFollowersArea> {
  RefreshController _refreshController = RefreshController();
  User? user;
  bool isLoading = false;

  getPageData() async {
    setState(() {
      isLoading = true;
    });
    user = await getUser();

    // print('followers: $response');
    // if (context.read<FollowersProvider>().currentPage < 1)
    getConectionsData();
    setState(() {
      isLoading = false;
    });
  }

  reset() async {
    context.read<FollowersProvider>().currentPage = 0;
    context.read<FollowersProvider>().maxPages = 0;
    context.read<FollowersProvider>().list = [];
    context.read<FollowersProvider>().isLoading = false;
    bool res = await getConectionsData();
    return res;
  }

  onBackData() async {
    context.read<FollowersProvider>().currentPage = 0;
    context.read<FollowersProvider>().maxPages = 0;
    bool res = await getConectionsData();
  }

  Future<bool> getConectionsData() async {
    context.read<FollowersProvider>().isLoading = true;
    String queryString;
    if (widget.type == "followers") {
      queryString = MJ_Apis.get_followers;
    } else {
      queryString = MJ_Apis.get_following;
    }
    var response =
        await MjApiService().getRequest(queryString + "/${user!.id}");
    print('data=>: ${response}');
    context.read<FollowersProvider>().isLoading = false;
    _refreshController.refreshCompleted();
    if (response != null) {
      List<User> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(User.fromJson(response['data'][i]));
      }
      context.read<FollowersProvider>().currentPage = response['current_page'];
      context.read<FollowersProvider>().maxPages = response['last_page'];
      context.read<FollowersProvider>().list = list;
    }
    return true;
  }

  Future<bool> loadMoreData() async {
    _refreshController.footerMode!.value = LoadStatus.loading;
    int page = context.read<FollowersProvider>().currentPage + 1;
    if (page > context.read<FollowersProvider>().maxPages) {
      _refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }
    String queryString;
    if (widget.type == "followers") {
      queryString = MJ_Apis.get_following;
    } else {
      queryString = MJ_Apis.get_followers;
    }
    var response =
        await MjApiService().getRequest(queryString + "/${user!.id}");

    _refreshController.footerMode!.value = LoadStatus.idle;
    // context.read<PostProvider>().isLoading = false;
    if (response != null) {
      List<User> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(User.fromJson(response['data'][i]));
      }
      context.read<FollowersProvider>().currentPage = response['current_page'];
      context.read<FollowersProvider>().maxPages = response['last_page'];
      context.read<FollowersProvider>().addMore(list);
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowersProvider>(builder: (key, provider, child) {
      return Column(
        children: [
          Container(
            height: getHeight(context) - 180,
            color: Color.fromRGBO(244, 244, 244, 1.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: BezierHeader(
                  child: Center(
                      child: Column(
                    children: [
                      AppLoader(
                        size: 40.0,
                        strock: 1,
                      ),
                    ],
                  )),
                  bezierColor: kYellowColor,
                ),
                footer: CustomFooter(
                  builder: smartRefreshFooter,
                ),
                onLoading: () async {
                  print("loading");
                  // _refreshController.load
                  bool res = await loadMoreData();
                },
                onRefresh: () async {
                  bool res = await reset();
                  _refreshController.loadComplete();
                },
                child: (provider.isLoading || isLoading) && provider.list.length < 1 || user == null
                    ? ConversationShimmer()
                    : provider.list.length < 1
                        ? emptyWidget(description: 'No Connections found!')
                        : ListView.builder(
                            itemCount: provider.list.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 16),
                            //  physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ConnectionItem(
                                selfId: user!.id!,
                                // reset: (){
                                //   onBackData();
                                // },
                                otherUser: provider.list[index],
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class ConnectionItem extends StatefulWidget {
  // String otherUserId;
  String selfId;
  User? otherUser;

  // final reset;

  ConnectionItem({
    required this.otherUser,
    required this.selfId,
    // required this.isMessageRead,
    // required this.reset
  });

  @override
  _ConnectionItemState createState() => _ConnectionItemState();
}

class _ConnectionItemState extends State<ConnectionItem> {
  @override
  Widget build(BuildContext context) {
    return widget.otherUser == null
        ? SizedBox()
        : TouchableOpacity(
            onTap: () async {
              //  var data = await Navigator.pushNamed(context, ChatDetail.routeName, arguments: {
              //   "other_user": widget.otherUser,
              //   "conversation": widget.conversation,
              //   "type": "conversation",
              // });
              //  widget.reset();
            },
            child: Container(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CacheImage(
                                url:
                                    "${MJ_Apis.APP_BASE_URL}${widget.otherUser!.profileImage}",
                                width: 40,
                                height: 40,
                                // maxRadius: 30,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.transparent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "${widget.otherUser!.firstname} ${widget.otherUser!.lastname}",
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      'Tap to start a chat',
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 13,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TouchableOpacity(
                        onTap: () async {
                          print('id in profile: ${widget.otherUser!.id}');

                          // return;

                          Conversation? conversation = await context
                              .read<ConversationProvider>()
                              .checkChat(
                                  context: context,
                                  otherUserId: widget.otherUser!.id,
                                  selfId: widget.selfId);

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
                                "user": widget.otherUser,
                                "conversation": conversation,
                                "type": "profile",
                                "isExist": isExist
                              });
                        },
                        child: Icon(Icons.message),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
          );
  }
}
