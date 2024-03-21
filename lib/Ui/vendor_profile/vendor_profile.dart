// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/post_item_shimmer.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/profiler_header_shimmer.dart';
import 'package:farmer_app/Ui/orders/vendor/order_vendor_item.dart';
import 'package:farmer_app/Ui/posts/post_item.dart';
import 'package:farmer_app/Ui/user_profile/edit_profile.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/color_circular_progress_indicator.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/post_data.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/models/user_profile.dart';
import 'package:farmer_app/providers/post/post_provider.dart';
import 'package:farmer_app/providers/post/profile_posts_provider.dart';
import 'package:farmer_app/providers/user/my_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import '../../helpers/color_constants.dart';

class VendorProfile extends StatefulWidget {
  static const String routeName = "/vendor_profile";

  const VendorProfile({Key? key}) : super(key: key);

  @override
  _VendorProfileState createState() => _VendorProfileState();
}

class _VendorProfileState extends State<VendorProfile>
    with TickerProviderStateMixin {
  TabController? _tabController;
  User user = User();
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getPageData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  getProfile() {}

  getPageData() async {
    user = (await getUser())!;
    setState(() {
      user = user;
    });
    if (context.read<ProfilePostProvider>().currentPage < 1) getPostData();
    getProfile();
    getProfileData();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  reset() async {
    context.read<ProfilePostProvider>().currentPage = 0;
    context.read<ProfilePostProvider>().maxPages = 0;
    context.read<ProfilePostProvider>().list = [];
    context.read<ProfilePostProvider>().isLoading = false;
    bool res = await getPostData();
    return res;
  }

  // ==============> Get Profile Data
  getProfileData() async {
    context.read<MyProfileProvider>().isLoading = true;
    var response =
        await MjApiService().getRequest(MJ_Apis.get_profile + "/${user.id}");
    context.read<MyProfileProvider>().isLoading = false;
    if (response != null) {
      context
          .read<MyProfileProvider>()
          .setMyProfile(User.fromJson(response));
    }
  }



  Future<bool> getPostData() async {
    context.read<ProfilePostProvider>().isLoading = true;
    var response = await MjApiService()
        .getRequest(MJ_Apis.get_profile_post_list + "/${user.id}");
    context.read<ProfilePostProvider>().isLoading = false;
    _refreshController.refreshCompleted();
    if (response != null) {
      List<PostData> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(PostData.fromJson(response['data'][i]));
      }
      context.read<ProfilePostProvider>().currentPage =
          response['current_page'];
      context.read<ProfilePostProvider>().maxPages = response['last_page'];
      context.read<ProfilePostProvider>().list = list;
    }
    return true;
  }

  Future<bool> loadMorePostData() async {
    _refreshController.footerMode!.value = LoadStatus.loading;
    int page = context.read<ProfilePostProvider>().currentPage + 1;
    if (page > context.read<ProfilePostProvider>().maxPages) {
      _refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }
    var response = await MjApiService()
        .getRequest(MJ_Apis.get_post_list + "?user_id=${user.id}&page=${page}");
    _refreshController.footerMode!.value = LoadStatus.idle;
    // context.read<PostProvider>().isLoading = false;
    if (response != null) {
      List<PostData> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(PostData.fromJson(response['data'][i]));
      }
      context.read<ProfilePostProvider>().currentPage =
          response['current_page'];
      context.read<ProfilePostProvider>().maxPages = response['last_page'];
      context.read<ProfilePostProvider>().addMore(list);
    }
    return true;
  }

  // ignore: prefer_typing_uninitialized_variables
  var size, height, width;
  bool isCurrent = true;
  int voucherNumber = 1;
  bool isPortrait = true;

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    height = size.height;
    width = size.width;
    return Scaffold(
        backgroundColor: Color.fromRGBO(243, 243, 243, 1),
        appBar: AppBar(
          backgroundColor: kprimaryColor,
          toolbarHeight: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScroll) {
              return <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "${user.username}",
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Montserrat",
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showProfileMenuBottomSheet(context);
                        },
                        child: Icon(Icons.menu),
                      )
                    ],
                  ),
                  Consumer<MyProfileProvider>(builder: (key, provider, child) {
                    return Stack(
                      // overflow: Overflow.visible,
                      // clipBehavior: Overflow.visible,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 52),
                          // height: 125,
                          //width: 343,
                          decoration: BoxDecoration(
                              color: kprimaryColor,
                              borderRadius: BorderRadius.circular(19.0)),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 34,
                              ),

                              // if(false)
                              provider.isLoading &&
                                      provider.currentUser.id == null
                                  ? ProfileHeaderShimmer()
                                  : Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            "${provider.currentUser.firstname} ${provider.currentUser.lastname}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icons/location_icon.png",
                                              height: 12,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              provider.currentUser.address ==
                                                      null
                                                  ? "No Address Found"
                                                  : "${provider.currentUser.address}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(16, 8, 16, 0),
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                8, 10, 8, 10),
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .shadowColor
                                                    .withOpacity(.5),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Colors.white
                                                        .withOpacity(.4))),
                                            child: Flex(
                                              direction: Axis.horizontal,
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceAround,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(children: [
                                                    Text(
                                                      "Followers",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${provider.currentUser.followersCount}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(children: [
                                                    Text(
                                                      "Following",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${provider.currentUser.followingCount}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                  ]),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(children: [
                                                    Text(
                                                      "Posts",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${provider.currentUser.postsCount}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: Colors.white54,
                                                      ),
                                                    ),
                                                  ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                              Container(
                                height: 40,
                                transform: Matrix4.translationValues(0, 10, 0),
                                decoration: BoxDecoration(),
                                child: Center(
                                  child: TabBar(
                                    labelPadding: EdgeInsets.only(
                                        bottom: 19, left: 14, right: 14),
                                    isScrollable: true,
                                    indicator: CircleTabIndicator(
                                        color: kYellowColor, radius: 8),
                                    labelColor: kYellowColor,
                                    unselectedLabelColor: Colors.white,
                                    controller: _tabController,
                                    tabs: [
                                      Tab(
                                        text: 'Posts',
                                      ),
                                      Tab(
                                        text: 'Orders',
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            child: provider.isLoading &&
                                    provider.currentUser.id == null
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
                                            "${MJ_Apis.APP_BASE_URL}${provider.currentUser.profileImage}",
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  }),
                ]))
              ];
            },
            body: SafeArea(
              child: SizedBox(
                height: height,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Consumer<ProfilePostProvider>(
                        builder: (key, provider, child) {
                      return SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: false,
                        enablePullUp: true,
                        // header: BezierHeader(
                        //   child: Center(
                        //       child: Column(
                        //     children: [
                        //       AppLoader(
                        //         size: 40.0,
                        //         strock: 1,
                        //       ),
                        //       // Text("Loading")
                        //     ],
                        //   )),
                        //   bezierColor: kYellowColor,
                        // ),
                        footer: CustomFooter(
                          builder: smartRefreshFooter,
                        ),
                        onLoading: () async {
                          print("loading");
                          // _refreshController.load
                          bool res = await loadMorePostData();
                        },
                        onRefresh: () async {
                          bool res = await reset();
                          _refreshController.loadComplete();
                        },
                        child: provider.isLoading && provider.list.length < 1
                            ? PostListSimmer()
                            : ListView.builder(
                                itemCount: provider.list.length,
                                itemBuilder: (context, i) {
                                  return PostItem(postData: provider.list[i]);
                                }),
                      );
                    }),

                    //third Tab content
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            height: 55,
                            // width: 400,
                            decoration: BoxDecoration(
                                color: kGrey,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isCurrent = true;
                                    });
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 45,
                                      width: 140,
                                      decoration: BoxDecoration(
                                          color:
                                              isCurrent ? kYellowColor : kGrey,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text(
                                        "Current",
                                        style: TextStyle(
                                            color: isCurrent
                                                ? Colors.white
                                                : Colors.black),
                                      )),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isCurrent = false;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 45,
                                    width: 140,
                                    decoration: BoxDecoration(
                                        color: isCurrent ? kGrey : kYellowColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: GestureDetector(
                                      child: Text(
                                        "Previous",
                                        style: TextStyle(
                                            color: isCurrent
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (isCurrent)
                            Column(
                              children: List.generate(
                                  2, (index) => OrderVendorItem()),
                            ),
                          if (!isCurrent)
                            Column(
                              children: List.generate(
                                  10, (index) => OrderVendorItem()),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Container buildContainer(index) {
    return Container(
      height: 100,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              "assets/icons/background.png",
            ),
            fit: BoxFit.fill),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(isPortrait ? 60 : 120, 15, 0, 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Expiry",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "12 July 2022",
                      style: TextStyle(fontSize: 13, color: kGreyColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: isPortrait ? 30.0 : 50),
            child: Text(
              "\$50.0",
              style: TextStyle(
                  color: kprimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
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
