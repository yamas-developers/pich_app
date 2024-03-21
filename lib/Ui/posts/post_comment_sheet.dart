import 'package:date_format/date_format.dart';
import 'package:farmer_app/Ui/posts/post_comment_area.dart';
import 'package:farmer_app/Ui/search/search_post_area.dart';
import 'package:farmer_app/Ui/search/search_profiles_area.dart';
import 'package:farmer_app/Ui/search/search_profile_item.dart';
import 'package:farmer_app/Ui/posts/post_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/post_comment.dart';
import 'package:farmer_app/providers/post/post_comment_provider.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:farmer_app/models/user.dart' as usr;

class PostCommentSheet extends StatefulWidget {
  const PostCommentSheet({
    Key? key,
    required this.id
  }) : super(key: key);
  final dynamic id;

  @override
  State<PostCommentSheet> createState() => _PostCommentSheetState();
}

class _PostCommentSheetState extends State<PostCommentSheet> {
  TextEditingController typeCommentController = TextEditingController();
  usr.User? user;

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  getPageData() async {
    usr.User? userData = await context.read<UserProvider>().currentUser;
    setState(() {
      user = userData;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(context) - 50,
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: DefaultTabController(
          length: 1,
          initialIndex: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                // color: kprimaryColor,
                  gradient: LinearGradient(colors: [kprimaryColor, Colors.lightGreen])
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,8,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text('Comments', style: TextStyle(fontSize: 20, color: Colors.white),),
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.close, color: Colors.white))
                  ],),
                ),
              ),
              Expanded(
                      child: user!=null?PostCommentArea(postId: widget.id, userId: user!.id,):Container(),
                  ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: typeCommentController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(6, -2,-2, -2),
                            fillColor: kGreyColor,
                            filled: true,
                            hintText: 'Type your comment here...',
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        )),
                    TextButton(
                        onPressed: () async {
                          if(typeCommentController.text.trim().isEmpty)return;
                          showToast('Posting your comment');
                          MjApiService apiService = MjApiService();
                          Map payload = {"post_id":widget.id.toString(),"comment":typeCommentController.text};
                          typeCommentController.text = '';

                          var response = await apiService.postRequest(MJ_Apis.add_comment+"/${user!.id}", payload);

                          showToast('Successfully Posted a comment');
                          print('response: ${response}');

                          PostComment comment =  PostComment.fromJson(response);
                          context.read<PostCommentProvider>().addOne(comment);

                        },
                        child: Text(
                          'Post',
                          style: TextStyle(color: Colors.black),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
