// ignore_for_file: prefer_const_constructors

// ignore_for_file: unnecessary_new

import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/chat_shimmer.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/chat/connections_screen.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/firebase/firebase_helper.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/helpers/shared_preferances/prefs_helper.dart';
import 'package:farmer_app/models/conversation.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/chat/conversation_provider.dart';
import 'package:farmer_app/providers/search/profiles_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../helpers/color_constants.dart';
import 'package:farmer_app/Ui/chat/chat_detail.dart';

class ConversationList extends StatefulWidget {
  static const String routeName = "/list_conversation";

  const ConversationList({Key? key}) : super(key: key);

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  RefreshController _refreshController = RefreshController();
  User user = User();
  bool isLoading = false;
  GlobalKey _first = GlobalKey();

  getPageData() async {
    user = (await getUser())!;
    getConversationData();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      print("====>Chat notification set");
      context
          .read<FirebaseHelper>()
          .setMessageNotification(userId: user.id, count: 0, message: '');
    });

    PrefsHelper prefsHelper = new PrefsHelper();
    await prefsHelper.getInstance();
    if (prefsHelper.getString(PrefsHelper.CHAT_INTRO_KEY) != "done") {
      ShowCaseWidget.of(context).startShowCase([_first]);
      prefsHelper.setString(PrefsHelper.CHAT_INTRO_KEY, 'done');
    }
  }

  reset() async {
    context.read<ConversationProvider>().currentPage = 0;
    context.read<ConversationProvider>().maxPages = 0;
    context.read<ConversationProvider>().list = [];
    context.read<ConversationProvider>().isLoading = false;
    bool res = await getConversationData();
    return res;
  }

  onBackData() async {
    context
        .read<FirebaseHelper>()
        .setMessageNotification(userId: user.id, count: 0, message: '');
    context.read<ConversationProvider>().currentPage = 0;
    context.read<ConversationProvider>().maxPages = 0;
    bool res = await getConversationData();
  }

  Future<bool> getConversationData() async {
    context.read<ConversationProvider>().isLoading = true;
    var response = await MjApiService()
        .postRequest(MJ_Apis.user_chats + "/${user.id}", {});
    context.read<ConversationProvider>().isLoading = false;
    _refreshController.refreshCompleted();
    if (response != null) {
      List<Conversation> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(Conversation.fromJson(response['data'][i]));
      }
      context.read<ConversationProvider>().currentPage =
          response['current_page'];
      context.read<ConversationProvider>().maxPages = response['last_page'];
      context.read<ConversationProvider>().list = list;
    }
    return true;
  }

  Future<bool> loadMoreData() async {
    _refreshController.footerMode!.value = LoadStatus.loading;
    int page = context.read<ConversationProvider>().currentPage + 1;
    if (page > context.read<ConversationProvider>().maxPages) {
      _refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }
    var response = await MjApiService().postRequest(
        MJ_Apis.user_chats + "/${user.id}&page=${page}",
        {"page": page.toString()});
    _refreshController.footerMode!.value = LoadStatus.idle;
    // context.read<PostProvider>().isLoading = false;
    if (response != null) {
      List<Conversation> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(Conversation.fromJson(response['data'][i]));
      }
      context.read<ConversationProvider>().currentPage =
          response['current_page'];
      context.read<ConversationProvider>().maxPages = response['last_page'];
      context.read<ConversationProvider>().addMore(list);
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
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        // title: TextField(
        //   decoration: new InputDecoration(
        //     contentPadding: const EdgeInsets.fromLTRB(25, 12, 22, 12),
        //     filled: true,
        //     fillColor: Colors.white,
        //     hintText: "Search",
        //     prefixIcon: Icon(
        //       Icons.search,
        //       color: kYellowColor,
        //     ),
        //     enabledBorder: const OutlineInputBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(30.0)),
        //         borderSide: BorderSide(color: Colors.transparent)),
        //     focusedBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(30.0)),
        //         borderSide: BorderSide(color: Colors.transparent)),
        //   ),
        // ),
        iconTheme: IconThemeData(
          color: kYellowColor,
          //change your color here
        ),
        backgroundColor: Color.fromRGBO(243, 243, 243, 1),
        elevation: 0,
        actions: [
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Wrap(
        children: [
          Consumer<ConversationProvider>(builder: (key, provider, child) {
            return Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 45,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                        child: Text(
                          'Conversations',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                    ),
                    Showcase.withWidget(
                      key: _first,
                      height: 80,
                      width: getWidth(context) * .7,
                      container: Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 10),
                        width: getWidth(context) * .6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/icons/support.png",
                              width: 50,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Start Chat",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                                "Click here to see new users you want to chat with new user")
                          ],
                        ),
                      ),
                      shapeBorder: CircleBorder(),
                      child: TextButton(
                        child: Text('Tap to Chat'),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConnectionsScreen()));
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  height: _height - 95,
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
                            // Text("Loading")
                          ],
                        )),
                        bezierColor: kYellowColor,
                      ),
                      footer: CustomFooter(
                        height: 150,
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
                      child: provider.isLoading && provider.list.length < 1
                          ? ConversationShimmer()
                          : provider.list.length < 1
                              ? emptyWidget(
                                  description: 'No Conversations found!')
                              : ListView.builder(
                                  itemCount: provider.list.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 16),
                                  //  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ConversationLists(
                                      conversation: provider.list[index],
                                      reset: () {
                                        onBackData();
                                      },
                                      otherUser: provider.list[index]
                                          .getOtherUser(user.id),
                                      isMessageRead: (provider.list[index]
                                                  .getMyChat(user.id) !=
                                              null)
                                          ? convertNumber(provider.list[index]
                                                      .getMyChat(user.id)!
                                                      .unreadCount!) >
                                                  0
                                              ? true
                                              : false
                                          : false,
                                    );
                                  },
                                ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class ConversationLists extends StatefulWidget {
  Conversation conversation;
  bool isMessageRead;
  ChatData? otherUser;
  final reset;

  ConversationLists(
      {required this.conversation,
      required this.otherUser,
      required this.isMessageRead,
      required this.reset});

  @override
  _ConversationListsState createState() => _ConversationListsState();
}

class _ConversationListsState extends State<ConversationLists> {
  @override
  Widget build(BuildContext context) {
    return widget.otherUser == null
        ? SizedBox()
        : TouchableOpacity(
            onTap: () async {
              var data = await Navigator.pushNamed(
                  context, ChatDetail.routeName,
                  arguments: {
                    "other_user": widget.otherUser,
                    "conversation": widget.conversation,
                    "type": "conversation",
                  });
              widget.reset();
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
                                    "${MJ_Apis.APP_BASE_URL}${widget.otherUser!.user!.profileImage}",
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
                                      "${widget.otherUser!.user!.firstname} ${widget.otherUser!.user!.lastname}",
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      widget.conversation.lastMsg!.isNotEmpty
                                          ? "${widget.conversation.lastMsg}"
                                          : 'No Message Yet',
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 13,
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.grey.shade600,
                                          fontWeight: widget.isMessageRead
                                              ? FontWeight.bold
                                              : FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${widget.conversation.timeAgo}",
                        // maxLines: 2,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: widget.isMessageRead
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
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
