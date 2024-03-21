import 'package:farmer_app/Ui/app_components/app_logo.dart';
import 'package:farmer_app/Ui/app_components/placeholder_image.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/search_user_item_shimmer.dart';
import 'package:farmer_app/Ui/search/search_profile_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/search_profile.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/search/profiles_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/providers/social/social_provider.dart';

class SearchProfilesArea extends StatefulWidget {
  const SearchProfilesArea({Key? key, required this.searchString})
      : super(key: key);
  final String searchString;

  @override
  State<SearchProfilesArea> createState() => _SearchProfilesAreaState();
}

class _SearchProfilesAreaState extends State<SearchProfilesArea> {
  RefreshController _refreshController = RefreshController();
  User? user = User();

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("dependency Changed");
  }

  late String check = widget.searchString;

  getPageData() async {
    User? userData = await getUser();
    setState(() {
      user = userData;
    });
    getProfilesData();
  }

  reset() async {
    // User? userData = await getUser();
    // setState((){
    //   user = userData;
    // });

    context.read<ProfilesProvider>().currentPage = 0;
    context.read<ProfilesProvider>().maxPages = 0;
    context.read<ProfilesProvider>().list = [];
    context.read<ProfilesProvider>().isLoading = false;
    bool res = await getProfilesData();
    return res;
  }

  Future<bool> getProfilesData() async {
    context.read<ProfilesProvider>().isLoading = true;
    var response = await MjApiService().getRequest(
        MJ_Apis.get_profiles + "/${user!.id}?search=${widget.searchString}");
    print('profilesResponse: ${response}');
    context.read<ProfilesProvider>().isLoading = false;
    _refreshController.refreshCompleted();
    if (response != null) {
      List<User> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(User.fromJson(response['data'][i]));
      }
      context.read<ProfilesProvider>().currentPage = response['current_page'];
      context.read<ProfilesProvider>().maxPages = response['last_page'];
      context.read<ProfilesProvider>().list = list;
    }
    return true;
  }

  Future<bool> loadMoreData() async {
    _refreshController.footerMode!.value = LoadStatus.loading;
    int page = context.read<ProfilesProvider>().currentPage + 1;
    if (page > context.read<ProfilesProvider>().maxPages) {
      _refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }
    var response = await MjApiService().getRequest(MJ_Apis.get_profiles +
        "/${user!.id}?page=${page}&search=${widget.searchString}");
    _refreshController.footerMode!.value = LoadStatus.idle;
    // context.read<PostProvider>().isLoading = false;
    if (response != null) {
      List<User> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(User.fromJson(response['data'][i]));
      }
      context.read<ProfilesProvider>().currentPage = response['current_page'];
      context.read<ProfilesProvider>().maxPages = response['last_page'];
      context.read<ProfilesProvider>().addMore(list);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.searchString != check && check != null) {
      reset();
      check = widget.searchString;
    }

    print("searchString: ${widget.searchString}");
    return Consumer<ProfilesProvider>(builder: (key, provider, child) {
      return Container(
        color: kGrey,
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
          child: ListView(
            children: [
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18, 8, 18, 0),
                child: provider.isLoading && provider.list.length < 1
                    ? SizedBox(
                        height: getHeight(context),
                        child: SearchUserListShimmer())
                    : provider.list.length < 1
                        ? emptyWidget(description: "No profiles found")
                        : Column(
                            children: List.generate(
                              provider.list.length,
                              (index) {
                                if (provider.list[index].id == user!.id)
                                  return SizedBox();
                                return Column(
                                  children: [
                                    SearchProfileItem(
                                      profileData: provider.list[index],
                                      selfId: user!.id,
                                    ),
                                    Divider(),
                                  ],
                                );
                              },
                            ),
                          ),
              ),
              // SizedBox(height: 140),
            ],
          ),
        ),
      );
    });
  }
}

class SocialProfilesArea extends StatefulWidget {
  // final routeName = "social";

  SocialProfilesArea({Key? key}) : super(key: key);

  @override
  State<SocialProfilesArea> createState() => _SocialProfilesAreaState();
}

class _SocialProfilesAreaState extends State<SocialProfilesArea> {
  RefreshController _refreshController = RefreshController();
  User? user = User();

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print("dependency Changed");
  }

  getPageData() async {
    User? userData = await getUser();
    setState(() {
      user = userData;
    });
    getProfilesData();
  }

  reset() async {
    // User? userData = await getUser();
    // setState((){
    //   user = userData;
    // });

    context
        .read<SocialProvider>()
        .currentPage = 0;
    context
        .read<SocialProvider>()
        .maxPages = 0;
    context
        .read<SocialProvider>()
        .list = [];
    context
        .read<SocialProvider>()
        .isLoading = false;
    bool res = await getProfilesData();
    return res;
  }

  Future<bool> getProfilesData() async {
    context
        .read<SocialProvider>()
        .isLoading = true;
    var response = await MjApiService().getRequest(MJ_Apis.get_social_profiles +
        "/${user!.id}/${context
            .read<SocialProvider>()
            .type}");
    print('profilesResponse: ${response}');
    context
        .read<SocialProvider>()
        .isLoading = false;
    _refreshController.refreshCompleted();
    if (response != null) {
      List<User> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        User profile = User.fromJson(response['data'][i]);
        if (profile.id != user!.id)
          list.add(profile);
      }
      context
          .read<SocialProvider>()
          .currentPage = response['current_page'];
      context
          .read<SocialProvider>()
          .maxPages = response['last_page'];
      context
          .read<SocialProvider>()
          .list = list;
    }
    return true;
  }

  Future<bool> loadMoreData() async {
    _refreshController.footerMode!.value = LoadStatus.loading;
    int page = context.read<SocialProvider>().currentPage + 1;
    if (page > context.read<SocialProvider>().maxPages) {
      _refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }
    var response = await MjApiService().getRequest(MJ_Apis.get_social_profiles +
        "/${user!.id}/${context.read<SocialProvider>().type}?page=${page}");
    _refreshController.footerMode!.value = LoadStatus.idle;
    // context.read<PostProvider>().isLoading = false;
    if (response != null) {
      List<User> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        User profile = User.fromJson(response['data'][i]);
        if(profile.id != user!.id)
          list.add(profile);
      }
      context.read<SocialProvider>().currentPage = response['current_page'];
      context.read<SocialProvider>().maxPages = response['last_page'];
      context.read<SocialProvider>().addMore(list);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SocialProvider>(builder: (key, provider, child) {
      return Container(
        color: kGrey,
        height: getHeight(context),
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
          child: ListView(
            children: [
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18, 8, 18, 0),
                child: provider.isLoading && provider.list.length < 1
                    ? SizedBox(
                        height: getHeight(context),
                        child: SearchUserListShimmer())
                    : provider.list.length < 1
                        ? emptyWidget(description: "No profiles found")
                        : Column(
                            children: List.generate(
                              provider.list.length,
                              (index) {
                                if (provider.list[index].id == user!.id)
                                  return SizedBox();
                                return Column(
                                  children: [
                                    SearchProfileItem(
                                      profileData: provider.list[index],
                                      selfId: user!.id,
                                    ),
                                    Divider(),
                                  ],
                                );
                              },
                            ),
                          ),
              ),
              // SizedBox(height: 140),
            ],
          ),
        ),
      );
    });
  }
}
