import 'package:farmer_app/helpers/firebase/firebase_helper.dart';
import 'package:farmer_app/providers/post/profile_posts_provider.dart';
import 'package:farmer_app/providers/social/social_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

class CustomBottomNavBar extends StatefulWidget {
  @required
  List<Widget>? items = [];
  @required
  int? currentIndex = -1;
  @required
  Function? onChange;
  bool isKeyboardAppeared;

  // var data null;
  CustomBottomNavBar(
      {this.items,
      this.currentIndex,
      this.onChange,
      this.isKeyboardAppeared = false});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  bool _showBottomNav = true;

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<FirebaseHelper>().initChatMessagesNotifications();
      context.read<SocialProvider>().list.clear();
      context.read<ProfilePostProvider>().list.clear();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          NotificationListener<UserScrollNotification>(
            onNotification: (UserScrollNotification notification) {
              // print("scroll");
              final ScrollDirection direction = notification.direction;
              setState(() {
                if (direction == ScrollDirection.reverse) {
                  // _showBottomNav = false;
                  _showBottomNav = true;
                } else if (direction == ScrollDirection.forward) {
                  _showBottomNav = true;
                }
              });
              return true;
            },
            child: widget.currentIndex! <= widget.items!.length - 1
                ? widget.currentIndex! >= 0
                    ? widget.items![widget.currentIndex!]
                    : Container()
                : Container(),
          ),
          // else

          AnimatedSlide(
            duration: Duration(milliseconds: 400),
            offset: _showBottomNav
                ? widget.isKeyboardAppeared
                    ? Offset(0, 4)
                    : Offset.zero
                : Offset(0, 4),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 400),
              opacity: _showBottomNav
                  ? widget.isKeyboardAppeared
                      ? 0
                      : 1
                  : 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                        height: 56,

                        // color: Colors.red,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                        child: SizedBox(
                          height: 56,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(19),
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 10,
                                          blurRadius: 1,
                                          color: Colors.grey)
                                    ]),
                                child: Material(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    child: Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                            icon: Image.asset(
                                              'assets/icons/document-text.png',
                                              color: widget.currentIndex! == 1
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.black,
                                              width: 22,
                                            ),
                                            onPressed: () {
                                              widget.onChange!(1);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Consumer<FirebaseHelper>(
                                              builder: (__, provider, child) {
                                            return Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                IconButton(
                                                  icon: Image.asset(
                                                    'assets/icons/chat.png',
                                                    color:
                                                        widget.currentIndex! ==
                                                                2
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : Colors.black,
                                                    width: 20,
                                                  ),
                                                  onPressed: () {
                                                    widget.onChange!(2);
                                                  },
                                                ),
                                                if(provider.chatMessageNotifications > 0)
                                                Positioned(
                                                  top:12,
                                                  right: 10,
                                                  child: Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red[400],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                    ),
                                                    // child: Center(
                                                    //   child: Text(
                                                    //     "",
                                                    //     style: TextStyle(
                                                    //         fontWeight:
                                                    //             FontWeight.bold,
                                                    //         color: Colors.white,fontSize: 12),
                                                    //   ),
                                                    // ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                        ),
                                        Expanded(flex: 2, child: Container()),
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                            icon: Image.asset(
                                              'assets/icons/menu_search.png',
                                              color: widget.currentIndex! == 3
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.black,
                                              width: 20,
                                            ),
                                            onPressed: () {
                                              widget.onChange!(3);
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                            icon: Image.asset(
                                              'assets/icons/user_profile.png',
                                              color: widget.currentIndex! == 4
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Colors.black,
                                              width: 20,
                                            ),
                                            onPressed: () {
                                              widget.onChange!(4);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 48,
            child: AnimatedSlide(
              duration: Duration(milliseconds: 400),
              offset: _showBottomNav
                  ? widget.isKeyboardAppeared
                      ? Offset(0, 4)
                      : Offset.zero
                  : Offset(0, 4),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 400),
                opacity: _showBottomNav
                    ? widget.isKeyboardAppeared
                        ? 0
                        : 1
                    : 0,
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: widget.currentIndex! == 0
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                  onPressed: () {
                    widget.onChange!(0);
                  },
                  child: Image.asset(
                    'assets/icons/home.png',
                    color: Colors.white,
                    width: 20,
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
