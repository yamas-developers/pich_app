import 'dart:ffi';

import 'package:farmer_app/Ui/app_components/app_logo.dart';
import 'package:farmer_app/Ui/app_components/placeholder_image.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/post_item_shimmer.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/posts/create_post.dart';
import 'package:farmer_app/Ui/posts/post_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/color_circular_progress_indicator.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/helpers/shared_preferances/prefs_helper.dart';
import 'package:farmer_app/models/post_data.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/post/post_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:showcaseview/showcaseview.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  RefreshController _refreshController = RefreshController();
  User? user;
  GlobalKey _first = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getPageData();
    print("dependency Changed");
  }

  getPageData() async {
    user = (await getUser())!;
    setState(() {
      user = user;
    });
    getPostData();
    PrefsHelper prefsHelper = new PrefsHelper();
    await prefsHelper.getInstance();
    if (prefsHelper.getString(PrefsHelper.POST_INTRO_KEY) != "done") {
      ShowCaseWidget.of(context).startShowCase([_first]);
      prefsHelper.setString(PrefsHelper.POST_INTRO_KEY, 'done');
    }
  }

  reset() async {
    context.read<PostProvider>().currentPage = 0;
    context.read<PostProvider>().maxPages = 0;
    context.read<PostProvider>().list = [];
    context.read<PostProvider>().isLoading = false;
    bool res = await getPostData();
    return res;
  }

  Future<bool> getPostData() async {
    context.read<PostProvider>().isLoading = true;
    var response = await MjApiService()
        .getRequest(MJ_Apis.get_post_list + "?user_id=${user!.id}");
    context.read<PostProvider>().isLoading = false;
    _refreshController.refreshCompleted();
    if (response != null) {
      List<PostData> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(PostData.fromJson(response['data'][i]));
      }
      context.read<PostProvider>().currentPage = response['current_page'];
      context.read<PostProvider>().maxPages = response['last_page'];
      context.read<PostProvider>().list = list;
    }
    return true;
  }

  Future<bool> loadMoreData() async {
    _refreshController.footerMode!.value = LoadStatus.loading;
    int page = context.read<PostProvider>().currentPage + 1;
    if (page > context.read<PostProvider>().maxPages) {
      _refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }
    var response = await MjApiService().getRequest(
        MJ_Apis.get_post_list + "?user_id=${user!.id}&page=${page}");
    _refreshController.footerMode!.value = LoadStatus.idle;
    // context.read<PostProvider>().isLoading = false;
    if (response != null) {
      List<PostData> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(PostData.fromJson(response['data'][i]));
      }
      context.read<PostProvider>().currentPage = response['current_page'];
      context.read<PostProvider>().maxPages = response['last_page'];
      context.read<PostProvider>().addMore(list);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Consumer<PostProvider>(builder: (key, provider, child) {
        print(provider.isLoading);
        return Container(
          height: getHeight(context),
          width: getWidth(context),
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
            child:
                // provider.isLoading
                //     ? Center(child: AppLoader())
                //     :
                ListView(
              children: [
                SizedBox(
                  height: 8,
                ),
                // Text("PHIC"),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: AppLogo(),
                ),
                SizedBox(
                  height: 14,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (user != null)
                            ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: PlaceHolderImage(
                                  url:
                                      '${MJ_Apis.APP_BASE_URL}${user!.profileImage}',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                )),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Showcase.withWidget(
                          key: _first,
                          height: 80,
                          width: getWidth(context) * .7,
                          container: Container(
                            padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 10,
                                top: 10),
                            width: getWidth(context) * .6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  "assets/icons/pear.png",
                                  width: 50,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Share Meal",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                    "Share your healthy meal of daily life to all the other public.")
                              ],
                            ),
                          ),
                          shapeBorder: CircleBorder(),
                          child: TouchableOpacity(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, CreatePost.routeName);
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(.4),
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade50)),
                              child: Text(
                                "Share your healthy options.",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                        )),
                    // Expanded(
                    //     child: TouchableOpacity(
                    //   onTap: () {},
                    //   child: Container(
                    //     child: Image.asset(
                    //       "assets/images/picture.png",
                    //       width: 26,
                    //       height: 26,
                    //     ),
                    //   ),
                    // ))
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(18, 8, 18, 0),
                  child: provider.isLoading && provider.list.length < 1
                      ? SizedBox(
                          height: getHeight(context), child: PostListSimmer())
                      : provider.list.length < 1
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                emptyWidget(description: "No posts available"),
                              ],
                            )
                          : Column(
                              children: List.generate(
                                provider.list.length,
                                (index) => Column(
                                  children: [
                                    PostItem(
                                      postData: provider.list[index],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 4,
                                    )
                                  ],
                                ),
                              ),
                            ),
                ),
                // SizedBox(height: 140),
              ],
            ),
          ),
        );
      }),
    );
  }
}
