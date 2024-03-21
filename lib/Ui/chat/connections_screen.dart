// ignore_for_file: prefer_const_constructors

// ignore_for_file: unnecessary_new

import 'package:farmer_app/Ui/app_components/app_back_button.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/chat_shimmer.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/conversation.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/chat/conversation_provider.dart';
import 'package:farmer_app/providers/search/profiles_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../helpers/color_constants.dart';
import 'package:farmer_app/Ui/chat/chat_detail.dart';

import 'chat_followers_area.dart';
import 'chat_following_area.dart';

class ConnectionsScreen extends StatefulWidget {
  static const String routeName = "/connections_screen";

  const ConnectionsScreen({Key? key}) : super(key: key);

  @override
  _ConnectionsScreenState createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: AppBackButton(
                  width: 26,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8),
                child: Container(
                  height: 45,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Start a conversation',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              // height: getHeight(context) - 80,
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //           child: TextField(
                      //         // controller: searchFieldController,
                      //         decoration: InputDecoration(
                      //           contentPadding:
                      //               EdgeInsets.fromLTRB(10, -2, -2, -2),
                      //           fillColor: kGreyColor,
                      //           filled: true,
                      //           suffixIcon: IconButton(
                      //               onPressed: () {
                      //                 setState(() {
                      //                   // searchString = searchFieldController.text;
                      //                 });
                      //               },
                      //               icon: Icon(Icons.search)),
                      //           label: Text('Search'),
                      //           border: OutlineInputBorder(
                      //               borderSide: BorderSide.none,
                      //               borderRadius: BorderRadius.circular(10)),
                      //         ),
                      //       )),
                      //     ],
                      //   ),
                      // ),
                      TabBar(
                          padding: EdgeInsets.all(0),
                          labelColor: Colors.black54,
                          labelStyle: TextStyle(fontSize: 16),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Colors.black54,
                          labelPadding: EdgeInsets.all(8),
                          tabs: [
                            Text('Following'),
                            Text('Followers'),
                          ]),
                      Expanded(
                          child: TabBarView(
                        children: [
                          ChatFollowingsArea(
                            type: 'following',
                          ),
                          ChatFollowersArea(
                            type: 'followers',
                          ),
                          // SearchPostArea(),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
