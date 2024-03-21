import 'dart:async';
import 'package:farmer_app/Ui/app_components/shimmer_ui/home_produce_bag_item_shimmer.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/home_store_item_shimmer.dart';
import 'package:farmer_app/Ui/app_components/shimmer_ui/nearest_store_shimmer.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/cart/user_cart.dart';
import 'package:farmer_app/Ui/customer_support/customer_support.dart';
import 'package:farmer_app/Ui/home_produces/components/popular_store_item.dart';
import 'package:farmer_app/Ui/home_produces/home_produce_bag_item.dart';
import 'package:farmer_app/Ui/home_produces/home_produce_item.dart';
import 'package:farmer_app/Ui/notification_screen/notifications_screen.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/Ui/store/store.dart' as st;

import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/app_loader.dart';
import 'package:farmer_app/helpers/cart/cart_helper.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/firebase/firebase_helper.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/helpers/shared_preferances/prefs_helper.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/store_produce_bag.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/location/current_location_provider.dart';
import 'package:farmer_app/providers/produce_bag/home_produce_bag_provider.dart';
import 'package:farmer_app/providers/product/home_store_product.dart';
import 'package:farmer_app/providers/store/home_store_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeProduces extends StatefulWidget {
  static String routeName = "/home_produces";

  const HomeProduces({Key? key}) : super(key: key);

  @override
  State<HomeProduces> createState() => _HomeProducesState();
}

class _HomeProducesState extends State<HomeProduces>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool _showFab = true;
  var size, height, width;
  User user = User();
  Timer? timer;
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();
  GlobalKey _six = GlobalKey();

  getCurrentLocation() async {
    await context.read<CurrentLocationProvider>().getCurrentLocation();
    // await context.read<CurrentLocationProvider>().checkPermission();
  }

  getPageData() async {
    user = (await getUser())!;
    setState(() {
      user = user;
    });
    // bool check = await getFormData();
    // if(!check){
    //   return;
    // }

    getCurrentLocation();

    if (timer != null) timer!.cancel();
    timer = Timer.periodic(Duration(seconds: 20), (timer) {
      if (!context
          .read<CurrentLocationProvider>()
          .isLoading) {
        getCurrentLocation();
      }
    });

    getStoresData();
    getHomeProduceBag();
    getHomeProduces();
    context.read<CartHelper>().getCartData();
    context.read<FirebaseHelper>().initLocalNotifications();
    PrefsHelper prefsHelper = new PrefsHelper();
    await prefsHelper.getInstance();
    // await Future.delayed(Duration(milliseconds: 1000));
    print('===========>INTRO=>' +
        prefsHelper.getString(PrefsHelper.HOME_INTRO_KEY).toString());
    if (prefsHelper.getString(PrefsHelper.HOME_INTRO_KEY) != 'done') {
      print("===========> INTRO");
      ShowCaseWidget.of(context)
          .startShowCase([_one, _two, _three, _four, _five]);
      prefsHelper.setString(PrefsHelper.HOME_INTRO_KEY, 'done');
    }
  }

  getHomeProduces() async {
    context
        .read<HomeStoreProductProvider>()
        .isLoading = true;
    var response = await MjApiService()
        .getRequest(MJ_Apis.get_home_products + "/${user.id}");
    if (!mounted) return;
    context
        .read<HomeStoreProductProvider>()
        .isLoading = false;
    if (response != null) {
      List<StoreProduct> list = [];
      for (int i = 0; i < response.length; i++) {
        list.add(StoreProduct.fromJson(response[i]));
      }
      context.read<HomeStoreProductProvider>().set(list);
    }
  }

  getHomeProduceBag() async {
    context
        .read<HomeProduceBagProvider>()
        .isLoading = true;
    var response = await MjApiService()
        .getRequest(MJ_Apis.get_home_product_bag + "/${user.id}");
    context
        .read<HomeProduceBagProvider>()
        .isLoading = false;
    if (response != null) {
      List<StoreProduceBag> list = [];
      for (int i = 0; i < response.length; i++) {
        list.add(StoreProduceBag.fromJson(response[i]));
      }
      context.read<HomeProduceBagProvider>().set(list);
    }
  }

  getStoresData() async {
    context
        .read<HomeStoreListProvider>()
        .isLoading = true;
    var response = await MjApiService()
        .getRequest(MJ_Apis.get_home_stores + "/${user.id}");
    context
        .read<HomeStoreListProvider>()
        .isLoading = false;
    if (response != null) {
      List<Store> list = [];
      for (int i = 0; i < response.length; i++) {
        list.add(Store.fromJson(response[i]));
      }
      context.read<HomeStoreListProvider>().set(list);
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getPageData();

    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Home Produce");
    size = MediaQuery
        .of(context)
        .size;
    height = size.height;
    width = size.width;
    int _items = 10;
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: kprimaryColor,
        toolbarHeight: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: getHeight(context) / 3),
        child: AnimatedSlide(
          duration: Duration(milliseconds: 400),
          offset: _showFab ? Offset.zero : Offset(4, 0),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 400),
            opacity: _showFab ? 1 : 0,
            child: Showcase.withWidget(
              key: _four,
              height: 80,
              width: getWidth(context) * .7,
              container: Container(
                padding:
                EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
                width: getWidth(context) * .6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/icons/support.png",
                      width: 50,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Customer Support",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                        "For any query and question 24/7 available support to resolve your problems.")
                  ],
                ),
              ),
              shapeBorder: CircleBorder(),
              child: FloatingActionButton(
                heroTag: 'support-fab',
                elevation: 0,
                backgroundColor: Theme
                    .of(context)
                    .primaryColor,
                onPressed: () {
                  Navigator.pushNamed(context, CustomerSupportScreen.routeName);
                },
                child: Icon(
                  Icons.support_agent,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: NotificationListener<UserScrollNotification>(
          onNotification: (UserScrollNotification notification) {
            final ScrollDirection direction = notification.direction;
            setState(() {
              if (direction == ScrollDirection.reverse) {
                _showFab = false;
              } else if (direction == ScrollDirection.forward) {
                _showFab = true;
              }
            });
            return true;
          },
          child: NestedScrollView(
            body: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Consumer<HomeProduceBagProvider>(
                      builder: (key, provider, child) {
                        return provider.isLoading && provider.list.length < 1
                            ? HomeProduceBagListShimmer()
                            : provider.list.length < 1
                            ? emptyWidget(
                            description: "No food boxes available")
                            : ListView.builder(
                            itemCount: provider.list.length,
                            itemBuilder: (ctx, i) =>
                                HomeProductBagItem(
                                    id: i,
                                    storeProduceBag:
                                    provider.list.elementAt(i)));
                      }),
                  Consumer<HomeStoreProductProvider>(
                      builder: (key, provider, child) {
                        return provider.isLoading && provider.list.length < 1
                            ? HomeProduceBagListShimmer()
                            : provider.list.length < 1
                            ? emptyWidget(
                            description: "No single items available")
                            : ListView.builder(
                          itemCount: provider.list.length,
                          itemBuilder: (ctx, i) =>
                              Column(
                                children: [
                                  HomeProduceItem(
                                    id: i,
                                    storeProduct: provider.list.elementAt(i),
                                  )
                                ],
                              ),
                        );
                      }),
                ],
              ),
            ),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/home_produces_tree.png",
                              height: 60,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Good Morning',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      '${user.firstname}',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 15,
                                          overflow: TextOverflow.ellipsis),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Showcase(
                                  key: _one,
                                  title: 'Notification',
                                  description:
                                  'Click here to see confirmation and notifications',
                                  blurValue: .7,
                                  child: TouchableOpacity(
                                    onTap: () {
                                      Navigator.pushNamed(context,
                                          NotificationsScreen.routeName);
                                    },
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset(
                                            "assets/images/home_produces_bell.png",
                                            height: 25,
                                            width: 19,
                                          ),
                                        ),
                                        Consumer<FirebaseHelper>(
                                            builder: (key, provider, child) {
                                              return provider
                                                  .localNotifications < 1
                                                  ? SizedBox(
                                                height: 0,
                                                width: 0,
                                              )
                                                  : Positioned(
                                                top: 0,
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "${provider
                                                          .localNotifications}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Showcase.withWidget(
                                  key: _two,
                                  height: 80,
                                  width: getWidth(context) * .7,
                                  container: Container(
                                    padding: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        bottom: 10,
                                        top: 10),
                                    width: getWidth(context) * .6,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/images/basket_4x.png",
                                          width: 50,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Your Cart",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                            "Cart contains products that allows customers to purchase items from your shop or store a list of the items they wish to purchase in the future ")
                                      ],
                                    ),
                                  ),
                                  shapeBorder: CircleBorder(),
                                  child: TouchableOpacity(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, UserCartScreen.routeName);
                                    },
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.shopping_cart,
                                            size: 28,
                                          ),
                                        ),
                                        Consumer<CartHelper>(
                                            builder: (key, provider, child) {
                                              return provider.list.length < 1
                                                  ? SizedBox()
                                                  : Positioned(
                                                top: 1,
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "${provider.list.length}",
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Consumer<CurrentLocationProvider>(
                            builder: (key, provider, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12.0, bottom: 5),
                                        child: Text(
                                          'Nearest Vendors',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          bottomModalNearestVendors(context);
                                        },
                                        child: Text(
                                          'View All',
                                          style: TextStyle(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  provider.isLoading
                                      ? NearestStoreShimmer(
                                      message: provider.message)
                                      : Showcase.withWidget(
                                    key: _three,
                                    height: 80,
                                    width: getWidth(context) * .7,
                                    container: Container(
                                      padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      width: getWidth(context) * .6,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            "assets/icons/shop.png",
                                            width: 50,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Nearest Stores",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                              "Nearest stores are stores exists near you according to your current device location.")
                                        ],
                                      ),
                                    ),
                                    shapeBorder: ContinuousRectangleBorder(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(19),
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.red,
                                              child: Image.asset(
                                                'assets/images/vendor.png',
                                                height: 20,
                                                width: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: TouchableOpacity(
                                                onTap: () {
                                                  bottomModalNearestVendors(
                                                      context);
                                                },
                                                child: provider.error ||
                                                    provider.nearestStores
                                                        .length <
                                                        1
                                                    ? Text(provider.message,
                                                    style: TextStyle(
                                                        color:
                                                        Colors.white))
                                                    : Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      '${provider.getTopStore()!
                                                          .storeName}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      '${provider.getTopStore()!
                                                          .address}',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      '${convertDoublePoints(
                                                          convertKilometerToMiles(
                                                              provider
                                                                  .getTopStore()!
                                                                  .distance))} miles',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[
                                                          300],
                                                          fontSize: 8),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            TouchableOpacity(
                                              onTap: () {
                                                if(provider
                                                    .getTopStore() != null)
                                                openMap(
                                                    convertDouble(provider
                                                        .getTopStore()!
                                                        .lat),
                                                    convertDouble(provider
                                                    .getTopStore()!
                                                    .lng));
                                              },
                                              child: Image.asset(
                                                'assets/icons/location_icon.png',
                                                width: 15,
                                                height: 20,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }),
                        SizedBox(
                          height: 6,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: Text('Popular Stores'),
                                  ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     // Navigator.push(
                                  //     //     context,
                                  //     //     MaterialPageRoute(
                                  //     //         builder: (context) =>
                                  //     //             HomePage()));
                                  //   },
                                  //   child: Text(
                                  //     'View All',
                                  //     style: TextStyle(
                                  //         color: Theme.of(context).primaryColor,
                                  //         fontSize: 10),
                                  //   ),
                                  //   style: TextButton.styleFrom(
                                  //       shadowColor: Colors.red),
                                  // )
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Container(
                                height: 60,
                                child: //HomeStoreListShimmer()
                                Consumer<HomeStoreListProvider>(
                                    builder: (key, provider, child) {
                                      return provider.list.length < 1 &&
                                          provider.isLoading
                                          ? HomeStoreListShimmer()
                                          : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: provider.list.length,
                                        itemBuilder: (context, i) =>
                                            PopularStoreItem(
                                                store: provider.list
                                                    .elementAt(i)),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    TabBar(
                      isScrollable: true,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                            width: 2.0, color: Theme
                            .of(context)
                            .primaryColor),
                        insets: EdgeInsets.symmetric(horizontal: 36.0),
                      ),
                      labelColor: Theme
                          .of(context)
                          .primaryColor,
                      controller: _tabController,
                      tabs: [
                        Tab(
                          height: 20,
                          text: 'Food Boxes',
                        ),
                        Tab(
                          height: 20,
                          text: 'Single Items',
                        )
                      ],
                    ),
                  ]),
                ),
              ];
            },
          ),
        ),
      ),
    );
  }

  Future bottomModalNearestVendors(BuildContext context) {
    bool isKeyboardAppeared = MediaQuery
        .of(context)
        .viewInsets
        .bottom != 0;
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
              padding: MediaQuery
                  .of(context)
                  .viewInsets,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28.0, vertical: 2),
                          child: Text(
                            'Nearest Vendors',
                            // textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        // Expanded(
                        //     child: TextField(
                        //   decoration: InputDecoration(
                        //     contentPadding: EdgeInsets.all(0),
                        //     isDense: true,
                        //     fillColor: containerGreyShade,
                        //     filled: true,
                        //     prefixIcon: Icon(Icons.search),
                        //     label: Text('Search'),
                        //     border: OutlineInputBorder(
                        //         borderSide: BorderSide.none,
                        //         borderRadius: BorderRadius.circular(10)),
                        //   ),
                        // )),
                        TextButton(
                            onPressed: () {
                              if (isKeyboardAppeared)
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              else
                                Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<CurrentLocationProvider>(
                        builder: (key, provider, _) {
                          return Container(
                            color: Color.fromRGBO(243, 243, 243, 1),
                            child: provider.isLoading &&
                                provider.nearestStores.length < 1
                                ? AppLoader()
                                : provider.nearestStores.length < 1
                                ? emptyWidget(description: 'No stores nearby')
                                : ListView(
                              children: List.generate(
                                  provider.nearestStores.length,
                                      (index) =>
                                      NearestVendorItem(
                                        store: provider
                                            .nearestStores[index],
                                        vendorName:
                                        '${provider.nearestStores[index]
                                            .storeName}',
                                        streetAddress:
                                        '${provider.nearestStores[index]
                                            .address}',
                                        lat: "${provider.nearestStores[index].lat}",
                                        lng: "${provider.nearestStores[index].lng}",
                                      )).toList()

                              // NearestVendorItem(
                              //   vendorName: 'Walli Vendor',
                              //   streetAddress: 'Street 2 LA',
                              // ),
                              // NearestVendorItem(
                              //   vendorName: 'Maxi Vendor',
                              //   streetAddress: 'Main Street LA',
                              // ),
                              // NearestVendorItem(
                              //   vendorName: 'Billy Vendor',
                              //   streetAddress: 'Main Street Downtown',
                              // ),
                              ,
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class NearestVendorItem extends StatelessWidget {
  const NearestVendorItem({
    Key? key,
    required this.vendorName,
    required this.streetAddress,
    required this.lat,
    required this.lng,
    required this.store,
  }) : super(key: key);
  final String vendorName;
  final String streetAddress;
  final String lat,lng;
  final Store store;
  static int colorVary = 0;

  @override
  Widget build(BuildContext context) {
    colorVary++;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(19),
          color: colorVary % 2 == 0
              ? Theme
              .of(context)
              .primaryColor
              : Theme
              .of(context)
              .accentColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: TouchableOpacity(
                  onTap: (){
                    Navigator.pushNamed(
                        context, st.Store.routeName,
                        arguments: store);
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red,
                    child: Image.asset(
                      'assets/icons/vendor.png',
                      height: 20,
                      width: 20,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   width: 20,
              // ),
              Expanded(
                flex: 4,
                child: TouchableOpacity(
                  onTap: (){
                    Navigator.pushNamed(
                        context, st.Store.routeName,
                        arguments: store);
                  },  
                  child: Padding(
                    padding: EdgeInsets.only(left: 10,right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vendorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        Text(
                          streetAddress,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: TouchableOpacity(
                  onTap:(){
                      openMap(
                          convertDouble(lat),
                          convertDouble(lng));
                  },
                  child: Image.asset(
                    'assets/icons/location_icon.png',
                    width: 15,
                    height: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
