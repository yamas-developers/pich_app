import 'package:farmer_app/Ui/app_components/shimmer_ui/post_item_shimmer.dart';
import 'package:farmer_app/Ui/posts/post_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/post_data.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/post/profile_posts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfilePostSection extends StatefulWidget {
  final String userId;

  const ProfilePostSection({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePostSection> createState() => _ProfilePostSectionState();
}

class _ProfilePostSectionState extends State<ProfilePostSection> {
  RefreshController _refreshController = RefreshController();
  User user = User();

  @override
  void initState() {
    print("userID in postSection: ${widget.userId}");
    if (widget.userId != '' && widget.userId != null)
      Future.delayed(Duration.zero).then((value) => getPageData());
    // WidgetsBinding.instance!
    //     .addPostFrameCallback((_) => getPageData());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  getPageData() async {
    user = (await getUser())!;
    setState(() {
      user = user;
    });
    getPostData();
  }

  reset() async {
    context.read<ProfilePostProvider>().currentPage = 0;
    context.read<ProfilePostProvider>().maxPages = 0;
    context.read<ProfilePostProvider>().list = [];
    context.read<ProfilePostProvider>().isLoading = false;
    bool res = await getPostData();
    return res;
  }

  Future<bool> getPostData() async {
    print('userIdd: ${widget.userId}');
    context.read<ProfilePostProvider>().isLoading = true;
    var response = await MjApiService()
        .getRequest(MJ_Apis.get_profile_post_list + "/${widget.userId}");
    if (!mounted) return false;
    context.read<ProfilePostProvider>().isLoading = false;
    _refreshController.refreshCompleted();
    print("response in post section: ${response}");
    if (response != null) {
      List<PostData> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(PostData.fromJson(response['data'][i]));
      }
      context.read<ProfilePostProvider>().currentPage =
          response['current_page'];
      context.read<ProfilePostProvider>().maxPages = response['last_page'];
      context.read<ProfilePostProvider>().list = list;
    } else {
      context.read<ProfilePostProvider>().list = [];
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
    var response = await MjApiService().getRequest(
        MJ_Apis.get_profile_post_list + "/${widget.userId}&page=${page}");
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfilePostProvider>(builder: (key, provider, child) {
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
          height: 120,
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
            : provider.list.length < 1
                ? emptyWidget(description: "No posts found")
                : ListView.builder(
                    itemCount: provider.list.length,
                    itemBuilder: (context, i) {
                      return PostItem(postData: provider.list[i]);
                    }),
      );
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
