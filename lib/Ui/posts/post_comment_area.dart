import 'dart:developer';

import 'package:farmer_app/Ui/app_components/app_logo.dart';
import 'package:farmer_app/Ui/app_components/placeholder_image.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/post_comment_list_shimmer.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/search_user_item_shimmer.dart';
import 'package:farmer_app/Ui/posts/post_comment_item.dart';
import 'package:farmer_app/Ui/search/search_profile_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/post_comment.dart';
import 'package:farmer_app/models/search_profile.dart';
import 'package:farmer_app/providers/post/post_comment_provider.dart';
import 'package:farmer_app/providers/search/profiles_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PostCommentArea extends StatefulWidget {
  const PostCommentArea({Key? key, required this.postId, required this.userId})
      : super(key: key);
  final dynamic postId;
  final dynamic userId;

  @override
  State<PostCommentArea> createState() => _PostCommentAreaState();
}

class _PostCommentAreaState extends State<PostCommentArea> {
  RefreshController _refreshController = RefreshController();

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
    // if (context.read<ProfilesProvider>().currentPage < 1)
    getCommentsData();
  }

  reset() async {
    context.read<PostCommentProvider>().currentPage = 0;
    context.read<PostCommentProvider>().maxPages = 0;
    context.read<PostCommentProvider>().list = [];
    context.read<PostCommentProvider>().isLoading = false;
    bool res = await getCommentsData();
    return res;
  }

  Future<bool> getCommentsData() async {
    context.read<PostCommentProvider>().isLoading = true;
    if (context.read<PostCommentProvider>().postId !=
        widget.postId.toString()) {
      context.read<PostCommentProvider>().list = [];
      context.read<PostCommentProvider>().postId = widget.postId.toString();
    }
    var response = await MjApiService().getRequest(MJ_Apis.get_post_comments +
        "/${widget.userId}/${widget.postId.toString()}");
    print('commentResponse: ${response}');
    context.read<PostCommentProvider>().isLoading = false;
    _refreshController.refreshCompleted();
    if (response != null) {
      List<PostComment> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(PostComment.fromJson(response['data'][i]));
      }
      context.read<PostCommentProvider>().currentPage =
          response['current_page'];
      context.read<PostCommentProvider>().maxPages = response['last_page'];
      context.read<PostCommentProvider>().list = list;
    }
    return true;
  }

  Future<bool> loadMoreData() async {
    _refreshController.footerMode!.value = LoadStatus.loading;
    int page = context.read<PostCommentProvider>().currentPage + 1;
    if (page > context.read<PostCommentProvider>().maxPages) {
      _refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }
    var response = await MjApiService().getRequest(MJ_Apis.get_post_comments +
        "/${widget.userId}/${widget.postId.toString()}&page=${page}");
    _refreshController.footerMode!.value = LoadStatus.idle;
    // context.read<PostProvider>().isLoading = false;
    if (response != null) {
      List<PostComment> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(PostComment.fromJson(response['data'][i]));
      }
      context.read<PostCommentProvider>().currentPage =
          response['current_page'];
      context.read<PostCommentProvider>().maxPages = response['last_page'];
      context.read<PostCommentProvider>().addMore(list);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PostCommentProvider>(builder: (key, provider, child) {
      log("message: ${provider.list.length}");
      return Container(
        color: kGrey.withOpacity(0.7),
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
                height: 4,
              ),
              provider.isLoading && provider.list.length < 1
                  ? Container(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      height: getHeight(context),
                      child: PostCommentListShimmer())
                  : provider.list.isEmpty
                      ? Column(
                        children: [
                          SizedBox(height: 50,),
                          Center(child: emptyWidget(description: 'No Comments Found')),
                        ],
                      )
                      : Column(
                          children: List.generate(
                            provider.list.length,
                            (index) {
                              return Column(
                                children: [
                                  PostCommentItem(
                                    key: UniqueKey(),
                                    // commentItem: PostComment(
                                    //     comment:
                                    //     provider.list[0].comment,
                                    //     user: User(
                                    //         profileImage: user!.profileImage,
                                    //         firstname: user!.id)),
                                    commentItem: provider.list[index],
                                    selfId: widget.userId,
                                  ),
                                  Divider(
                                    indent: 20,
                                    endIndent: 20,
                                    height: 0,
                                  ),
                                ],
                              );
                            },
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
