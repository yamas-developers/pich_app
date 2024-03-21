import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/notification_shimmer.dart';
import 'package:farmer_app/Ui/orders/order_screen.dart';
import 'package:farmer_app/Ui/orders/vendor/vendor_order_list.dart';
import 'package:farmer_app/Ui/vendor_dashboard/vendor_wallet_screen.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/firebase/firebase_helper.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/models/user_notification.dart';
import 'package:farmer_app/providers/user/user_notification_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:developer';
import 'package:farmer_app/models/post_data.dart';
import 'package:farmer_app/Ui/posts/post_detail.dart';
import 'dart:convert';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/providers/post/post_provider.dart';

class NotificationsScreen extends StatefulWidget {
  static const String routeName = "/notification_screen";

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

enum Menu { markAllAsRead, deleteAll }
enum MenuTile { markAsRead, delete }

class _NotificationsScreenState extends State<NotificationsScreen> {
  RefreshController _refreshController = RefreshController();
  User? user;
  String _selectedMenu = '';

  getPageData() async {
    user = (await getUser())!;
    setState(() {
      user = user;
    });
    getPostData();
  }

  reset() async {
    context.read<UserNotificationProvider>().currentPage = 0;
    context.read<UserNotificationProvider>().maxPages = 0;
    context.read<UserNotificationProvider>().list = [];
    context.read<UserNotificationProvider>().isLoading = false;
    bool res = await getPostData();
    return res;
  }

  @override
  void didChangeDependencies() {
    context.read<FirebaseHelper>().setLocalNotification(0);
    super.didChangeDependencies();
  }

  Future<bool> getPostData() async {
    context.read<UserNotificationProvider>().isLoading = true;
    var response = await MjApiService()
        .getRequest(MJ_Apis.get_user_notification + "/${user!.id}");
    context.read<UserNotificationProvider>().isLoading = false;
    _refreshController.refreshCompleted();
    if (response != null) {
      List<UserNotification> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(UserNotification.fromJson(response['data'][i]));
      }
      context.read<UserNotificationProvider>().currentPage =
          response['current_page'];
      context.read<UserNotificationProvider>().maxPages = response['last_page'];
      context.read<UserNotificationProvider>().list = list;
    }
    return true;
  }

  Future<bool> loadMoreData() async {
    _refreshController.footerMode!.value = LoadStatus.loading;
    int page = context.read<UserNotificationProvider>().currentPage + 1;
    if (page > context.read<UserNotificationProvider>().maxPages) {
      _refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }
    var response = await MjApiService().getRequest(
        MJ_Apis.get_user_notification + "/${user!.id}&page=${page}");
    _refreshController.footerMode!.value = LoadStatus.idle;
    // context.read<PostProvider>().isLoading = false;
    if (response != null) {
      List<UserNotification> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(UserNotification.fromJson(response['data'][i]));
      }
      context.read<UserNotificationProvider>().currentPage =
          response['current_page'];
      context.read<UserNotificationProvider>().maxPages = response['last_page'];
      context.read<UserNotificationProvider>().addMore(list);
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'assets/icons/arrow-left.png',
                            color: Colors.black,
                            scale: 10,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Notifications',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ],
                  ),
                  // PopupMenuButton<Menu>(
                  //   // Callback that sets the selected popup menu item.
                  //     onSelected: (Menu item) {
                  //       setState(() {
                  //         _selectedMenu = item.name;
                  //       });
                  //     },
                  //     itemBuilder: (BuildContext context) =>
                  //     <PopupMenuEntry<Menu>>[
                  //       const PopupMenuItem<Menu>(
                  //         value: Menu.markAllAsRead,
                  //         child: Text('Mark all as read'),
                  //       ),
                  //       const PopupMenuItem<Menu>(
                  //         value: Menu.deleteAll,
                  //         child: Text('Delete All'),
                  //       ),
                  //     ]),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'New',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - 180,
                  child: Consumer<UserNotificationProvider>(
                      builder: (key, provider, child) {
                    return SmartRefresher(
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
                          ? NotificationShimmer()
                          : provider.list.length < 1
                              ? emptyWidget(
                                  description: 'No Notifications found')
                              : ListView(
                                  children: provider.list
                                      .map(
                                        (e) => NotificationsScreenItem(
                                          notification: e,
                                          // title: 'Billy Vendor Posted a video',
                                          // imageUrl:
                                          // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJxv0P4qDS_KAn-lIeyKpOSVEM87pPKbIVIQ&usqp=CAU',
                                          // timestamp: '20 minutes ago',
                                        ),
                                      )
                                      .toList(),
                                ),
                    );
                  }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NotificationsScreenItem extends StatelessWidget {
  const NotificationsScreenItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final UserNotification notification;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () async {
            User? user = (await getUser());
            log('MK: notification data: ${notification.toJson()}');
            if (notification.click == 'UserPost') {
              PostData? data =
                  PostData.fromJson(jsonDecode(notification.data!)['post']);
              showProgressDialog(context, 'Fetching data');

              data = await context.read<PostProvider>().getPostData(
                  notification.receiverId.toString(), data.id.toString());
              List<String> thumbnailList = [];
              if (data != null) {
                String? fileName = await getThumbnails(data);
                if (fileName != null) thumbnailList.add(fileName);
              }

              hideProgressDialog(context);
              Navigator.pushNamed(context, PostDetailScreen.routeName,
                  arguments: [data, thumbnailList]);
            } else if (notification.click == 'Orders') {
              if (user != null && user.rolesId == VENDOR) {
                Navigator.pushNamed(context, VendorOrdersScreen.routeName);
              } else {
                Navigator.pushNamed(context, OrderAndVoucherScreen.routeName, arguments: 'Orders');
              }
            } else if (notification.click == 'Voucher') {
              Navigator.pushNamed(context, OrderAndVoucherScreen.routeName, arguments: 'Vouchers');
            } else if (notification.click == 'Payment_Request') {
              Navigator.pushNamed(context, VendorWalletScreen.routeName);
            }
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: CacheImage(
              url: "${MJ_Apis.APP_BASE_URL}${notification.image}",
              width: 50,
              height: 50,
            ),
          ),
          title: Text("${notification.title}",
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500,
                // color: Colors.blueGrey
              )),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${notification.description}",
                maxLines: 2,
                style: TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
              ),
              Text(
                "${DateFormat('h:mm a - MMM dd, yyyy').format(DateTime.parse(notification.createdAt ?? ""))}",
                maxLines: 2,
                style: TextStyle(
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey),
              )
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
        Divider(),
      ],
    );
  }
}
