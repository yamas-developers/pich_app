// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:date_format/date_format.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/cart/user_cart.dart';
import 'package:farmer_app/Ui/home_produces/single_item_cart.dart';
import 'package:farmer_app/Ui/home_produces/single_item_detail_screen.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/cart/cart_helper.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/models/product.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/store_produce_bag.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:farmer_app/Ui/order_details/orderDetailsFirst.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:farmer_app/Ui/store/store.dart' as storeScreen;

class BasketCartActivity extends StatefulWidget {
  const BasketCartActivity({
    Key? key,
    required this.id,
    required this.bag,
  }) : super(key: key);
  final String id;
  final StoreProduceBag bag;

  @override
  State<BasketCartActivity> createState() => _BasketCartActivityState();
}

class _BasketCartActivityState extends State<BasketCartActivity> {
  bool isStarted = true;
  bool addClicked = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 0)).then((value) {
      setState(() {
        isStarted = false;
        getPageData();
      });
    });
  }

  getPageData() async {
    context.read<CartHelper>().getCartData();

    bool isClicked = (await context
            .read<CartHelper>()
            .isProduceAdded(widget.bag.id))['quantity'] >
        0;
    setState(() {
      addClicked = isClicked;
    });
    Store? store = widget.bag.store;
    for (int i = 0; i < widget.bag.produceBagProduct!.length; i++) {
      if (widget.bag.produceBagProduct![i].storeProduct!.store == null) {
        widget.bag.produceBagProduct![i].storeProduct!.store = store;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('store in basket_cart: ${widget.bag.store}');
    var screenHeight = MediaQuery.of(context).size.height;
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    var kFactorTop = MediaQuery.of(context).orientation == Orientation.portrait
        ? addClicked
            ? 0.7
            : 0.8
        : 0.18;
    var kFactorLeft =
        MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2.5;
    // print(kFactor);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.black.withOpacity(0.6),
      ),
      backgroundColor: Colors.black.withOpacity(0.6),
      body: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 3.0,
          sigmaY: 3.0,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Container(
            // color: Colors.black.withOpacity(0.6),
            child: Stack(
              // clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 22,
                  top: 20,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        isStarted = true;
                      });
                      await Future.delayed(Duration(milliseconds: 400))
                          .then((value) {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Image.asset(
                      'assets/images/arrow-left.png',
                      scale: 8,
                    ),
                  ),
                ),
                if (widget.bag.produceBagProduct!.length > 0)
                  AnimatedPositioned(
                    left: kFactorLeft *
                        (isStarted
                            ? 100
                            : isPortrait
                                ? 180
                                : 190),
                    top: kFactorTop * (isStarted ? 600 : 100),
                    duration: Duration(milliseconds: 500),
                    child: BasketCartAnimatedInsideItem(
                      product: widget.bag.produceBagProduct!
                          .elementAt(0)
                          .storeProduct,
                      qty: widget.bag.produceBagProduct!
                          .elementAt(0).quantity??-1,
                    ),
                  ),
                if (widget.bag.produceBagProduct!.length > 1)
                  AnimatedPositioned(
                    left: kFactorLeft * (isStarted ? 120 : 50),
                    top: kFactorTop * (isStarted ? 560 : 160),
                    duration: Duration(milliseconds: 500),
                    child: BasketCartAnimatedInsideItem(
                      product: widget.bag.produceBagProduct!
                          .elementAt(1)
                          .storeProduct,
                      qty: widget.bag.produceBagProduct!
                          .elementAt(1).quantity??-1,
                    ),
                  ),
                if (widget.bag.produceBagProduct!.length > 2)
                  AnimatedPositioned(
                    left: kFactorLeft *
                        (isStarted
                            ? 120
                            : isPortrait
                                ? 130
                                : 10),
                    top: kFactorTop *
                        (isStarted
                            ? 560
                            : addClicked
                                ? isPortrait
                                    ? 240
                                    : 400
                                : 280),
                    duration: Duration(milliseconds: 500),
                    child: BasketCartAnimatedInsideItem(
                      product: widget.bag.produceBagProduct!
                          .elementAt(2)
                          .storeProduct,
                      qty: widget.bag.produceBagProduct!
                          .elementAt(2).quantity??-1,
                    ),
                  ),
                if (widget.bag.produceBagProduct!.length > 3)
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 500),
                    left: isPortrait
                        ? kFactorLeft * (isStarted ? 150 : 60)
                        : kFactorLeft * 85,
                    top: kFactorTop * (isStarted ? 590 : 430),
                    child: BasketCartAnimatedInsideItem(
                      product: widget.bag.produceBagProduct!
                          .elementAt(3)
                          .storeProduct,
                      qty: widget.bag.produceBagProduct!
                          .elementAt(3).quantity??-1,
                    ),
                  ),
                if (widget.bag.produceBagProduct!.length > 4)
                  AnimatedPositioned(
                    left: kFactorLeft * (isStarted ? 160 : 220),
                    top: kFactorTop * (isStarted ? 540 : 380),
                    duration: Duration(milliseconds: 500),
                    child: BasketCartAnimatedInsideItem(
                      product: widget.bag.produceBagProduct!
                          .elementAt(4)
                          .storeProduct,
                      qty: widget.bag.produceBagProduct!
                          .elementAt(4).quantity??-1,
                    ),
                  ),

                Positioned(
                  bottom: addClicked ? 70 : 10,
                  right: 15,
                  left: 15,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            bottomModalAllProducts(context);
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                                color: kYellowColor,
                                fontSize: 14,
                                decoration: TextDecoration.none),
                          ),
                        ),
                        Hero(
                          tag: widget.id,
                          child: Image.asset(
                            'assets/images/empty_basket.png',
                            height: 130,
                            width: 180,
                            scale: isPortrait ? 2 : 8,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kGreyColor,
                          ),
                          height: 100, width: 300,
                          // height: 100,
                          // width: 100,
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '${widget.bag.produceBagTitle}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.none),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          '\$${widget.bag.price}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              decoration: TextDecoration.none),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${widget.bag.produceBagProduct!.length} items',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          decoration: TextDecoration.none),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            maxRadius: 11,
                                            backgroundColor:
                                                Color.fromRGBO(249, 178, 51, 1),
                                            child: Image.asset(
                                              'assets/images/vendor.png',
                                              height: 11,
                                              width: 11,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          if (widget.bag.store != null)
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    storeScreen.Store.routeName,
                                                    arguments:
                                                        widget.bag.store);
                                              },
                                              child: Text(
                                                  '${widget.bag.store!.storeName}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      decoration:
                                                          TextDecoration.none)),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: Theme.of(context).accentColor,
                                        onPressed: () {
                                          setState(() {
                                            addClicked = true;
                                          });
                                          context.read<CartHelper>().addToCart(
                                              storeProductId: widget.bag.id,
                                              quantity: 1,
                                              store_id: widget.bag.storeId,
                                              price: widget.bag.price,
                                              type: 'produce');
                                          Navigator.pushReplacementNamed(
                                              context,
                                              UserCartScreen.routeName);
                                        },
                                        child: Text(
                                          'ADD',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // AnimatedPositioned(
                //   bottom: 80,
                //   left: 80,
                //   right: 80,
                //   duration: Duration(milliseconds: 500),
                //   child: Hero(
                //     tag: ValueKey(widget.id),
                //     child: Image.asset(
                //       'assets/png/empty_basket.png',
                //       height: 130,
                //       width: 180,
                //       scale: isPortrait ? 6 : 8,
                //     ),
                //   ),
                // ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 28, 0, 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'Food Box',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    if (addClicked)
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, UserCartScreen.routeName);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  height: 50,
                                  // width: 50,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(14)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Shopping Bag',
                                        style: TextStyle(
                                            color: Colors.white,
                                            decoration: TextDecoration.none,
                                            fontSize: 16),
                                      ),
                                      Consumer<CartHelper>(
                                          builder: (key, provider, child) {
                                        return Text(
                                          '\$${provider.cartTotal}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              decoration: TextDecoration.none,
                                              fontSize: 16),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, storeScreen.Store.routeName,
                                    arguments: widget.bag.store);
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                height: 50,
                                // width: 50,
                                decoration: BoxDecoration(
                                    color: kYellowColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset('assets/images/vendor.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future bottomModalAllProducts(BuildContext context) {
    bool isKeyboardAppeared = MediaQuery.of(context).viewInsets.bottom != 0;
    return showModalBottomSheet(
        backgroundColor: Color.fromRGBO(243, 243, 243, 1),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            height: 600,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(children: [
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                  ),
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //
                        //       TextButton(
                        //           onPressed: () {
                        //             if (isKeyboardAppeared)
                        //               FocusScope.of(context)
                        //                   .requestFocus(FocusNode());
                        //             else
                        //               Navigator.pop(context);
                        //           },
                        //           child: Text(
                        //             'Cancel',
                        //             style: TextStyle(color: Colors.black),
                        //           ))
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28.0, vertical: 8),
                          child: Text(
                            'Single Items in Food Box',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: kprimaryColor,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Color.fromRGBO(243, 243, 243, 1),
                            child: Column(
                              children: List.generate(
                                  widget.bag.produceBagProduct!.length,
                                  (i) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0, vertical: 4),
                                        child: Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 7, 0, 7),
                                          height: 81,
                                          decoration: BoxDecoration(
                                            color: itmGreyColor,
                                            borderRadius:
                                                BorderRadius.circular(19),
                                          ),
                                          child: Row(
                                            children: [
                                              Padding(
                                                  padding: const EdgeInsets.all(
                                                      18.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);

                                                      Navigator.push(
                                                        context,
                                                        PageRouteBuilder(
                                                          opaque: false,
                                                          pageBuilder: (context,
                                                                  _, __) =>
                                                              SingleItemDetailScreen(
                                                            id: "produce_" +
                                                                widget.id
                                                                    .toString(),
                                                            storeProduct: widget
                                                                .bag
                                                                .produceBagProduct![
                                                                    i]
                                                                .storeProduct,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Hero(
                                                      tag:
                                                          "produce_${widget.id}",
                                                      child: CacheImage(
                                                        url:
                                                            "${MJ_Apis.APP_BASE_URL}${widget.bag.produceBagProduct![i].storeProduct!.products!.iconImage}",
                                                        width: 56,
                                                        height: 56,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  )),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${widget.bag.produceBagProduct![i].storeProduct!.products!.productName}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      '${widget.bag.produceBagProduct![i].storeProduct!.size}',
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),

                                                    Text(
                                                      "${widget.bag.produceBagProduct![i].quantity} included",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Theme.of(context)
                                                                  .accentColor),
                                                    ),
                                                    // Padding(
                                                    //   padding: const EdgeInsets.only(top: 12.0),
                                                    //   child: Row(
                                                    //     children: [
                                                    //       CircleAvatar(
                                                    //         maxRadius: 11,
                                                    //         backgroundColor: Color.fromRGBO(249, 178, 51, 1),
                                                    //         child: CacheImage(
                                                    //           url:'${MJ_Apis.APP_BASE_URL}${widget.bag.produceBagProduct![i].storeProduct!.store!.storeIcon}',
                                                    //           height: 11,
                                                    //           width: 11,
                                                    //         ),
                                                    //       ),
                                                    //       SizedBox(width: 5),
                                                    //       Text(
                                                    //         "${widget.bag.produceBagProduct![i].storeProduct!.store!.storeName}",
                                                    //         maxLines: 1,
                                                    //         style: TextStyle(fontSize: 12),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 18.0),
                                                child: Text(
                                                  '\$${widget.bag.produceBagProduct![i].storeProduct!.price}',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )).toList(),
                            ),
                          ),
                        ),
                      ]),
                ),
              ]),
            ),
          );
        });
  }
}

class BasketCartAnimatedInsideItem extends StatelessWidget {
  const BasketCartAnimatedInsideItem({
    Key? key,
    required this.product,
    required this.qty
  }) : super(key: key);

  final StoreProduct? product;
  final int qty;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (context, _, __) => SingleItemDetailScreen(
              id: "produce_" + product!.id!.toString(),
              storeProduct: product,
            ),
          ),
        );
      },
      child: Column(
        children: [
          CacheImage(
            url: '${MJ_Apis.APP_BASE_URL}${product!.products!.iconImage}',
            // scale: 0,
            width: 80,
            height: 80,
          ),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(30)),
            child: Text(
              '${qty != -1 ? '$qty x ' : ''}${product!.products!.productName}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.black,
                // decoration: TextDecoration.non
              ),
            ),
          )
        ],
      ),
    );
  }
}
