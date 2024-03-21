import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/models/post_comment.dart';
import 'package:farmer_app/providers/post/post_comment_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommentHelper{

  reset(context, RefreshController refreshController, userId, postId) async {
    context.read<PostCommentProvider>().currentPage = 0;
    context.read<PostCommentProvider>().maxPages = 0;
    context.read<PostCommentProvider>().list = [];
    context.read<PostCommentProvider>().isLoading = false;
    bool res = await getCommentsData(context, refreshController, userId, postId);
    return res;
  }

  Future<bool> getCommentsData(context, RefreshController refreshController, userId, postId) async {

    context.read<PostCommentProvider>().isLoading = true;
    var response =
    await MjApiService().getRequest(MJ_Apis.get_post_comments + "/${userId}/${postId.toString()}");
    print('commentResponse: ${response}');
    context.read<PostCommentProvider>().isLoading = false;
    refreshController.refreshCompleted();
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

  Future<bool> loadMoreData(context, RefreshController refreshController,userId, postId) async {
    refreshController.footerMode!.value = LoadStatus.loading;
    int page = context.read<PostCommentProvider>().currentPage + 1;
    if (page > context.read<PostCommentProvider>().maxPages) {
      refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }
    var response = await MjApiService()
        .getRequest(MJ_Apis.get_post_comments + "/${userId}/${postId.toString()}?page=${page}");
    refreshController.footerMode!.value = LoadStatus.idle;
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
}
