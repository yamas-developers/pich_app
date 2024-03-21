// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:farmer_app/Ui/produces/vendor/vendor_produce_bag_item.dart';
import 'package:farmer_app/Ui/store/store_detail.dart';
import 'package:farmer_app/Ui/store/store_form.dart';
import 'package:farmer_app/Ui/store/store_produces_area.dart';
import 'package:farmer_app/Ui/store/store_products_area.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/store.dart' as storeModel;
import 'package:farmer_app/models/store_produce_bag.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../helpers/color_constants.dart';

class Store extends StatefulWidget {
  static const String routeName = "/store";

  const Store({Key? key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> with TickerProviderStateMixin {
  TabController? _tabController;
  storeModel.Store? storeData;
  User? user = User();


  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    user = context.read<UserProvider>().currentUser;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    storeData = ModalRoute.of(context)!.settings.arguments as storeModel.Store?;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }


  var size, height, width;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: kYellowColor,
        toolbarHeight: 0,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScroll) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Container(
                      height: 147,
                      decoration: BoxDecoration(
                        color: kYellowColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(19),
                          bottomRight: Radius.circular(19),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 18, 10, 0),
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                      "assets/images/arrow-left.png",
                                      height: 25,
                                    )),
                                SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, StoreForm.routeName);
                                      },
                                      child: Text(
                                        '${storeData!.storeName}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      width: 220,
                                      child: Text(
                                        '${storeData!.address}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          TabBar(
                            labelPadding: EdgeInsets.fromLTRB(25, 14, 25, 6),
                            // labelPadding: EdgeInsets.only(bottom: 3),
                            isScrollable: true,
                            indicator: CircleTabIndicator(
                                color: kprimaryColor, radius: 8),
                            labelColor: kprimaryColor,
                            unselectedLabelColor: Colors.white,
                            controller: _tabController,
                            tabs: [
                              Tab(
                                text: 'Food Boxes',
                              ),
                              Tab(
                                text: 'Single Items',
                              ),
                              // Tab(
                              //   text: 'Orders',
                              // )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    // Padding(
                    //   padding: const EdgeInsets.all(12.0),
                    //   child: Column(
                    //     children: [
                    //       Container(
                    //           height: 57,
                    //           decoration: BoxDecoration(
                    //               color: kprimaryColor,
                    //               borderRadius: BorderRadius.circular(19)),
                    //           child: Padding(
                    //             padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14),
                    //             child: Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   "Search items",
                    //                   style: TextStyle(color: Colors.white),
                    //                 ),
                    //                 Image.asset(
                    //                   "assets/icons/search.png",
                    //                   height: 21,
                    //                 )
                    //               ],
                    //             ),
                    //           )),
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              ]),
            ),
          ];
        },
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [
              //1 Tab Content
              StoreProducesArea(storeData: storeData!,isVendor: user!.rolesId == VENDOR, isSelf: storeData!.userId.toString() == user!.id),
              StoreProductsArea(storeData: storeData!,isVendor: user!.rolesId == VENDOR,isSelf: storeData!.userId.toString() == user!.id),

              // Padding(
              //   padding: const EdgeInsets.all(12.0),
              //   child: Container(
              //     height: height - 285,
              //     child: ListView.builder(
              //       itemCount: 7,
              //       itemBuilder: (ctx, i) => ProducesListContainer(
              //         context: context,
              //         id: i,
              //         leadingIcon: 'assets/images/basket_4x.png',
              //         title: 'Fruits Produce',
              //         price: 17.54,
              //         numberOfItems: 5,
              //         vendorName: 'Walli Vendor',
              //       ),
              //     ),
              //   ),
              // ),

              // Column(),
              // Column(),
            ],
          ),
        ),
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

// Container ProducesListContainer({
//   required BuildContext context,
//   required int id,
//   required String leadingIcon,
//   required String title,
//   required double price,
//   required int numberOfItems,
//   required String vendorName,
// }) {
//   return Container(
//     margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
//     height: 91,
//     decoration: BoxDecoration(
//       color: kGreyColor,
//       borderRadius: BorderRadius.circular(19),
//     ),
//     child: Row(
//       children: [
//         Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: Image.asset(
//               leadingIcon,
//               width: 57,
//               height: 39,
//               fit: BoxFit.cover,
//             )),
//         Expanded(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                     fontSize: 15, color: Theme.of(context).primaryColor),
//               ),
//               Text(
//                 '$numberOfItems items',
//                 style: TextStyle(fontSize: 10),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 12.0),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       maxRadius: 11,
//                       backgroundColor: Color.fromRGBO(249, 178, 51, 1),
//                       child: Image.asset(
//                         'assets/images/billy_vendor_icon.png',
//                         height: 11,
//                         width: 11,
//                       ),
//                     ),
//                     SizedBox(width: 5),
//                     Text(
//                       vendorName,
//                       style: TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(right: 18.0),
//           child: Container(
//             height: 40,
//             width: 83,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(11), color: kYellowColor),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Add",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
