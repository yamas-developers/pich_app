// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/post_item_shimmer.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/recipe_item_shimmer.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/cart/user_cart.dart';
import 'package:farmer_app/Ui/store/store.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/cart/cart_helper.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/recipes_data.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/recipes/recipes_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SingleItemDetailScreen extends StatefulWidget {
  StoreProduct? storeProduct;
  final id;

  SingleItemDetailScreen(
      {Key? key, required this.id, required this.storeProduct})
      : super(key: key);

  @override
  _SingleItemDetailScreenState createState() => _SingleItemDetailScreenState();
}

class _SingleItemDetailScreenState extends State<SingleItemDetailScreen> {
  int quantity = 1;
  Enum? selectedSize;
  User user = User();
  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    getPageData();
    super.initState();
  }

  getPageData() async {
    user = (await getUser())!;
    setState(() {
      user = user;
    });
    print('storeProduct: ${widget.storeProduct!.toJson()}');
    setSize(widget.storeProduct!.size ?? 'Small');
    await getRecipesData();
  }

  setSize(String size) {
    switch (size) {
      case 'Large':
        selectedSize = Size.LARGE;
        break;
      case 'Medium':
        selectedSize = Size.MEDIUM;
        break;
      default:
        selectedSize = Size.SMALL;
        break;
    }
    setState(() {});
  }

  updateQuantity(String type) {
    switch (type) {
      case 'add':
        quantity++;
        break;
      case 'delete':
        if (quantity > 1) quantity--;
        break;
      default:
        break;
    }
    setState(() {
      quantity = quantity;
    });
  }

  reset() async {
    context.read<RecipesProvider>().currentPage = 0;
    context.read<RecipesProvider>().maxPages = 0;
    context.read<RecipesProvider>().list = [];
    context.read<RecipesProvider>().isLoading = false;
    bool res = await getRecipesData();
    return res;
  }

  Future<bool> getRecipesData() async {
    var payload = {"product_id": widget.storeProduct!.products!.id};
    context.read<RecipesProvider>().isLoading = true;
    var response = await MjApiService()
        .postRequest(MJ_Apis.get_product_recipes + "/${user.id}", payload);
    print('responseRecipes: ${response}');
    context.read<RecipesProvider>().isLoading = false;
    _refreshController.refreshCompleted();
    if (response != null) {
      List<RecipesData> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(RecipesData.fromJson(response['data'][i]));
      }
      context.read<RecipesProvider>().currentPage = response['current_page'];
      context.read<RecipesProvider>().maxPages = response['last_page'];
      context.read<RecipesProvider>().list = list;
    }
    return true;
  }

  Future<bool> loadMoreData() async {
    _refreshController.footerMode!.value = LoadStatus.loading;
    int page = context.read<RecipesProvider>().currentPage + 1;
    if (page > context.read<RecipesProvider>().maxPages) {
      _refreshController.footerMode!.value = LoadStatus.noMore;
      return false;
    }
    var response = await MjApiService()
        .getRequest(MJ_Apis.get_post_list + "?user_id=${user.id}&page=${page}");
    _refreshController.footerMode!.value = LoadStatus.idle;
    // context.read<PostProvider>().isLoading = false;
    if (response != null) {
      List<RecipesData> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(RecipesData.fromJson(response['data'][i]));
      }
      context.read<RecipesProvider>().currentPage = response['current_page'];
      context.read<RecipesProvider>().maxPages = response['last_page'];
      context.read<RecipesProvider>().addMore(list);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 14,
              sigmaY: 14,
            ),
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScroll) {
                return <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                      "assets/images/arrow-left.png",
                                      height: 32,
                                    )),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      widget.storeProduct!.products!.productName!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Hero(
                                  tag: widget.id,
                                  child: CacheImage(
                                    url:
                                        "${MJ_Apis.APP_BASE_URL}${widget.storeProduct!.products!.image}",
                                    // width: 56,
                                    height: 140,
                                    fit: BoxFit.contain,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Size",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    // Text(
                                    //   "Quantity",
                                    //   style: TextStyle(
                                    //     color: Colors.white,
                                    //     fontSize: 15,
                                    //     fontWeight: FontWeight.w500,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                //SIZE AND QTY
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        TouchableOpacity(
                                          onTap: () {
                                            // setState(() {
                                            //   selectedSize = Size.SMALL;
                                            // });
                                          },
                                          child: Container(
                                            height: 33,
                                            width: 32,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                                color: Colors.white),
                                            child: Center(
                                              child: Text(
                                                "S",
                                                style: TextStyle(
                                                  color:
                                                      selectedSize == Size.SMALL
                                                          ? kprimaryColor
                                                          : Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        TouchableOpacity(
                                          onTap: () {
                                            // setState(() {
                                            //   selectedSize = Size.MEDIUM;
                                            // });
                                          },
                                          child: Container(
                                            height: 33,
                                            width: 32,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                                color: Colors.white),
                                            child: Center(
                                              child: Text(
                                                "M",
                                                style: TextStyle(
                                                  color:
                                                      selectedSize == Size.MEDIUM
                                                          ? kprimaryColor
                                                          : Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        TouchableOpacity(
                                          onTap: () {
                                            // setState(() {
                                            //   selectedSize = Size.LARGE;
                                            // });
                                          },
                                          child: Container(
                                            height: 33,
                                            width: 32,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                                color: Colors.white),
                                            child: Center(
                                              child: Text(
                                                "L",
                                                style: TextStyle(
                                                  color:
                                                      selectedSize == Size.LARGE
                                                          ? kprimaryColor
                                                          : Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    // Container(
                                    //   height: 33,
                                    //   width: 114,
                                    //   decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(11),
                                    //       color: Colors.white),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceAround,
                                    //     children: [
                                    //       GestureDetector(
                                    //         onTap: () {
                                    //           setState(() {
                                    //             updateQuantity("delete");
                                    //           });
                                    //         },
                                    //         child: Text(
                                    //           "-",
                                    //           style: TextStyle(
                                    //             color: Colors.black,
                                    //             fontSize: 30,
                                    //             fontWeight: FontWeight.w600,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //       Text(
                                    //         "${quantity}",
                                    //         style: TextStyle(
                                    //           color: Colors.black,
                                    //           fontSize: 15,
                                    //           fontWeight: FontWeight.w600,
                                    //         ),
                                    //       ),
                                    //       GestureDetector(
                                    //         onTap: () {
                                    //           setState(() {
                                    //             updateQuantity("add");
                                    //           });
                                    //         },
                                    //         child: Text(
                                    //           "+",
                                    //           style: TextStyle(
                                    //             color: Colors.black,
                                    //             fontSize: 25,
                                    //             fontWeight: FontWeight.w600,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: 15,
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     SizedBox(
                            //       width: 30,
                            //     ),
                            //   ],
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Column(
                            //     children: [
                            //       Container(
                            //         height: 93,
                            //         width: double.infinity,
                            //         decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(19),
                            //           color: kGreyColor,
                            //         ),
                            //         child: Padding(
                            //           padding: const EdgeInsets.fromLTRB(
                            //               14, 10, 0, 10),
                            //           child: Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.spaceBetween,
                            //             children: [
                            //               Padding(
                            //                 padding:
                            //                     const EdgeInsets.only(top: 8.0),
                            //                 child: Column(
                            //                   crossAxisAlignment:
                            //                       CrossAxisAlignment.start,
                            //                   children: [
                            //                     Row(
                            //                       children: [
                            //                         Text(
                            //                           widget.storeProduct!
                            //                               .products!.productName!,
                            //                           style: TextStyle(
                            //                             color: kprimaryColor,
                            //                             fontSize: 15,
                            //                             fontWeight:
                            //                                 FontWeight.w500,
                            //                           ),
                            //                         ),
                            //                         Text(
                            //                           " \$${widget.storeProduct!.price}",
                            //                           style: TextStyle(
                            //                               color: Colors.black,
                            //                               fontWeight:
                            //                                   FontWeight.w500,
                            //                               fontSize: 15,
                            //                               decoration:
                            //                                   TextDecoration
                            //                                       .none),
                            //                         )
                            //                       ],
                            //                     ),
                            //                     SizedBox(
                            //                       height: 4,
                            //                     ),
                            //                     Text(
                            //                       widget.storeProduct!.size!,
                            //                       style: TextStyle(
                            //                           color: Colors.black,
                            //                           fontSize: 10,
                            //                           decoration:
                            //                               TextDecoration.none),
                            //                     ),
                            //                     if(widget.storeProduct!.store != null)Row(
                            //                       children: [
                            //                         CircleAvatar(
                            //                           backgroundColor:
                            //                               kYellowColor,
                            //                           radius: 15,
                            //                           child: CacheImage(
                            //                             url:
                            //                                 '${MJ_Apis.APP_BASE_URL}${widget.storeProduct!.store!.storeIcon}',
                            //                             height: 15,
                            //                           ),
                            //                         ),
                            //                         SizedBox(
                            //                           width: 5,
                            //                         ),
                            //                         Text(
                            //                           "${widget.storeProduct!.store!.storeName}",
                            //                           maxLines: 1,
                            //                           style: TextStyle(
                            //                               fontSize: 12,
                            //                               color: Colors.black),
                            //                         ),
                            //                         SizedBox(
                            //                           width: 5,
                            //                         ),
                            //                         Text(
                            //                           ">",
                            //                           style: TextStyle(
                            //                               fontSize: 12,
                            //                               color: Colors.black,
                            //                               decoration:
                            //                                   TextDecoration
                            //                                       .none),
                            //                         )
                            //                       ],
                            //                     ),
                            //                   ],
                            //                 ),
                            //               ),
                            //               // SizedBox(
                            //               //   width: 80,
                            //               // ),
                            //               Padding(
                            //                 padding: const EdgeInsets.fromLTRB(
                            //                     8.0, 8, 14, 8),
                            //                 child: TouchableOpacity(
                            //                   onTap: widget.storeProduct!.status!.toLowerCase() == 'active' ? () {
                            //                     context.read<CartHelper>().addToCart(
                            //                         storeProductId: widget.storeProduct!.id,
                            //                         quantity: 1,
                            //                         store_id: widget.storeProduct!.storeId,
                            //                         price: widget.storeProduct!.price,
                            //                         type: 'product');
                            //                     Navigator.pushReplacementNamed(
                            //                         context, UserCartScreen.routeName);
                            //                   } : null,
                            //                   child: Container(
                            //                     height: 40,
                            //                     width: 83,
                            //                     decoration: BoxDecoration(
                            //                         color: widget.storeProduct!.status!.toLowerCase() == 'active' ? kYellowColor : kGreyText.withOpacity(0.5),
                            //                         borderRadius:
                            //                             BorderRadius.circular(
                            //                                 11)),
                            //                     child: Center(
                            //                       child: Text(
                            //                          "Add",
                            //                         style: TextStyle(
                            //                           color: Colors.white,
                            //                           fontSize: 15,
                            //                         ),
                            //                       ),
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 12,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ]))
                ];
              },
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                    child: Row(
                      children: [
                        Text(
                          "Recipies",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    // height: getHeight(context)-100,
                    child: Consumer<RecipesProvider>(
                        builder: (key, provider, child) {
                      return SmartRefresher(
                        controller: _refreshController,
                        enablePullDown: false,
                        enablePullUp: true,
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
                        child: provider.isLoading && provider.list.length < 1
                            ? RecipeListSimmer()
                            : ListView.builder(
                                itemCount: provider.list.length,
                                itemBuilder: (context, i) {
                                  return RecipeItem(
                                      key: ValueKey(provider.list[i].id),
                                      data: provider.list[i]);
                                }),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, UserCartScreen.routeName);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 64,
                        // width: 50,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(19)),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shopping Bag',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: 16),
                            ),
                            Spacer(),
                            Text(
                              " \$${widget.storeProduct!.price}",
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.none,
                                  fontSize: 16),
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Store.routeName,
                          arguments: widget.storeProduct!.store);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 64,
                      // width: 50,
                      decoration: BoxDecoration(
                          color: kYellowColor,
                          borderRadius: BorderRadius.circular(19)),
                      child: Image.asset(
                        'assets/images/vendor.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class RecipeItem extends StatelessWidget {
  final RecipesData data;

  const RecipeItem({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Container(
        height: 93,
        width: getWidth(context) - 5,
        // width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          color: kGreyColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CacheImage(
                url: "${MJ_Apis.APP_BASE_URL}${data.recipesImage}",
                width: 72,
                height: 120,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${data.title}",
                      style: TextStyle(
                        color: kprimaryColor,
                        fontSize: 15,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        data.description ?? '',
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
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
