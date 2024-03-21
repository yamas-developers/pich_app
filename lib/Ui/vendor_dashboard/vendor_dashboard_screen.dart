import 'package:farmer_app/Ui/app_components/app_color_button.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/customer_support/customer_support.dart';
import 'package:farmer_app/Ui/notification_screen/notifications_screen.dart';
import 'package:farmer_app/Ui/orders/vendor/vendor_order_list.dart';
import 'package:farmer_app/Ui/produces/vendor/vendor_produces_list.dart';
import 'package:farmer_app/Ui/products/poducts.dart';
import 'package:farmer_app/Ui/store/edit_store_form.dart';
import 'package:farmer_app/Ui/store/store_form.dart';
import 'package:farmer_app/Ui/user_profile/edit_profile.dart';
import 'package:farmer_app/Ui/vendor_dashboard/vendor_earning_screen.dart';
import 'package:farmer_app/Ui/vendor_dashboard/vendor_store_item.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_circular_progress_indicator.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/firebase/firebase_helper.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/helpers/shared_preferances/prefs_helper.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/store/vendor_current_store.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class VendorDashboardScreen extends StatefulWidget {
  static const String routeName = '/vendor_dashboard';

  const VendorDashboardScreen({Key? key}) : super(key: key);

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  bool _showFab = true;
  late User user = User();
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();
  GlobalKey _four = GlobalKey();
  GlobalKey _five = GlobalKey();
  GlobalKey _six = GlobalKey();

  getPageData() async {
    user = (await getUser())!;
    setState(() {
      user = user;
    });
    PrefsHelper prefsHelper = new PrefsHelper();
    if(!mounted) return;
    await prefsHelper.getInstance();
    if (prefsHelper.getString(PrefsHelper.VENDOR_HOME_INTRO_KEY) != 'done') {
      print("===========> INTRO");
      ShowCaseWidget.of(context)
          .startShowCase([_one, _two, _three, _four, _five, _six]);
      prefsHelper.setString(PrefsHelper.VENDOR_HOME_INTRO_KEY, 'done');
    }
    await context.read<VendorStoreProvider>().getVendorStores();
    await context.read<VendorStoreProvider>().getCurrentStore();
    await context.read<VendorStoreProvider>().getVendorStoreData();
    context.read<FirebaseHelper>().initLocalNotifications();
  }

  @override
  void didChangeDependencies() {
    getPageData();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
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
              key: _three,
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
                backgroundColor: Theme.of(context).primaryColor,
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
      body: NotificationListener(
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/home_produces_tree.png",
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
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 12),
                              ),
                              Text(
                                '${user.firstname ?? ''}',
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                        ),
                      ),
                      //hh:mm |

                      Text(
                        '${DateFormat('MMM d, yyyy').format(DateTime.now())}',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Showcase.withWidget(
                        key: _one,
                        height: 80,
                        width: getWidth(context) * .7,
                        container: Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, bottom: 10, top: 10),
                          width: getWidth(context) * .6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/images/home_produces_bell.png",
                                width: 40,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Notification",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                  "View all latest udpated and orders notifications.")
                            ],
                          ),
                        ),
                        shapeBorder: CircleBorder(),
                        child: TouchableOpacity(
                          onTap: () {
                            Navigator.pushNamed(
                                context, NotificationsScreen.routeName);
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
                                return provider.localNotifications < 1
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
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${provider.localNotifications}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
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
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 5),
                        child: Text(
                          'Vendor Dashboard',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Consumer<VendorStoreProvider>(
                        builder: (key, provider, widget) => Column(
                          children: [
                            Showcase.withWidget(
                              key: _two,
                              height: 80,
                              width: getWidth(context) * .7,
                              container: Container(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 10),
                                width: getWidth(context) * .6,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.red,
                                      child: Image.asset(
                                        'assets/icons/vendor.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Current Store",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                        'Click here to select current store. \nNOTE: Dashboard stats will work according to current selected store')
                                  ],
                                ),
                              ),
                              shapeBorder: CircleBorder(),
                              child: TouchableOpacity(
                                onTap: () {
                                  context
                                      .read<VendorStoreProvider>()
                                      .getVendorStores();
                                  bottomModalVendorStores(context);
                                  // Navigator.pushNamed(context, StoreForm.routeName);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(19),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.red,
                                          child: Image.asset(
                                            'assets/icons/vendor.png',
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: provider.currentStore == null
                                              ? Text(
                                                  "Select Store",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                )
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${provider.currentStore!.storeName}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15),
                                                    ),
                                                    if (provider.currentStore!
                                                            .address !=
                                                        null)
                                                      Text(
                                                        '${provider.currentStore!.address}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12),
                                                      )
                                                  ],
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Container(
                                height: 170,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    // DashboardAnalyticsItem(
                                    //   title: 'Total Orders',
                                    //   subTitle: '${provider.currentStoreData.completedOrders ?? 0} orders',
                                    //   iconPath: 'assets/icons/sold.png',
                                    //   color: Color(0Xfff9b233),
                                    // ),
                                    DashboardAnalyticsItem(
                                      title: 'Earnings Today',
                                      subTitle:
                                          '\$${provider.currentStoreData.todayEarning ?? 0}',
                                      iconPath: 'assets/icons/dollar.png',
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    DashboardAnalyticsItem(
                                      title: 'Food Boxes sold today',
                                      subTitle:
                                          '${provider.currentStoreData.todayProduces ?? 0} boxes',
                                      iconPath: "assets/icons/basket_4x.png",
                                      iconScale: 3,
                                      // 'assets/icons/clock.png',
                                      color: Theme.of(context).accentColor,
                                    ),
                                    DashboardAnalyticsItem(
                                      title: 'Single Items Sold Today',
                                      subTitle:
                                          '${provider.currentStoreData.todaySoldItems ?? 0} items',
                                      iconPath: 'assets/icons/pineapple.png',
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                                child: Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 18.0, bottom: 6),
                                    child: Text(
                                      'Manage Store',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Showcase.withWidget(
                                          key: _four,
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
                                                  "assets/icons/basket_4x.png",
                                                  width: 50,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Food Box",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                    'Food box is basket of single items. you can manage food boxs of current selected store from here.')
                                              ],
                                            ),
                                          ),
                                          shapeBorder: CircleBorder(),
                                          child: TouchableOpacity(
                                            onTap: () {
                                              if (provider.currentStore == null) {
                                                showToast(
                                                    "Please select store first");
                                                return;
                                              }
                                              Navigator.of(context).pushNamed(
                                                  VendorProduceBagsScreen
                                                      .routeName);
                                            },
                                            child: VendorDashboardManageItem(
                                                title: 'Food Boxes',
                                                quantity:
                                                    ' ${provider.currentStoreData.totalProduces ?? 0} ',
                                                iconPath:
                                                    'assets/icons/basket_4x.png'),
                                          ),
                                        ),
                                        Showcase.withWidget(
                                          key: _five,
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
                                                  "assets/icons/pear.png",
                                                  width: 50,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Single Items",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text(
                                                    "You can manage store's available single items here")
                                              ],
                                            ),
                                          ),
                                          shapeBorder: CircleBorder(),
                                          child: TouchableOpacity(
                                            onTap: () {
                                              if (provider.currentStore == null) {
                                                showToast(
                                                    "Please select store first");
                                                return;
                                              }
                                              Navigator.of(context)
                                                  .pushNamed(Products.routeName);
                                            },
                                            child: VendorDashboardManageItem(
                                                title: 'Single Items',
                                                iconPath:
                                                    'assets/icons/orange_half_orange.png',
                                                quantity:
                                                    ' ${provider.currentStoreData.totalStoreProducts ?? 0} '),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TouchableOpacity(
                                          onTap: () {
                                            if (provider.currentStore == null) {
                                              showToast(
                                                  "Please select store first");
                                              return;
                                            }
                                            Navigator.of(context).pushNamed(
                                                VendorOrdersScreen.routeName);
                                          },
                                          child: VendorDashboardManageItem(
                                              title: 'Orders',
                                              quantity:
                                                  ' ${provider.currentStoreData.pendingOrders ?? 0} ',
                                              iconPath:
                                                  'assets/icons/cart.png'),
                                        ),
                                        TouchableOpacity(
                                          onTap: () async {
                                            if (provider.currentStore == null) {
                                              showToast(
                                                  "Please select store first");
                                              return;
                                            }
                                            await Navigator.of(context).pushNamed(
                                                VendorEarningScreen.routeName);
                                            context.read<VendorStoreProvider>().getVendorStoreData();
                                            // getPageData();
                                          },
                                          child: VendorDashboardManageItem(
                                              title: 'Earnings',
                                              iconPath: 'assets/icons/shop.png',
                                              quantity:
                                                  ' ${provider.currentStoreData.completedOrders ?? 0} '),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 160,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future bottomModalVendorStores(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                            )),
                        TextButton(
                            onPressed: () async {
                              var a = await Navigator.pushNamed(
                                  context, StoreForm.routeName);
                              // context.read<VendorStoreProvider>().getVendorStores();
                            },
                            child: Row(
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 4),
                                Text(
                                  'Add Store',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 8),
                    child: Text(
                      'Your Stores',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Color.fromRGBO(243, 243, 243, 1),
                      child: Consumer<VendorStoreProvider>(
                        builder: (key, provider, widget) =>
                            provider.loading && provider.list.isEmpty
                                ? ColorCircularProgressIndicator(
                                    message: "Loading",
                                  )
                                : provider.list.isEmpty? emptyWidget(description: 'No stores available') :  ListView(
                                    children: List.generate(
                                    provider.list.length,
                                    (index) => VendorStoreItem(
                                      store: provider.list[index],
                                      colorVary: index,
                                    ),
                                  )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class VendorDashboardManageItem extends StatelessWidget {
  const VendorDashboardManageItem({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.quantity,
  }) : super(key: key);

  final String title;
  final String iconPath;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
        height: isPortrait ? 140 : 180,
        width: isPortrait ? 140 : 240,
        decoration: BoxDecoration(
          color: itmGreyColor.withOpacity(.4),
          borderRadius: BorderRadius.circular(19),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 15)),
              Image.asset(
                iconPath,
                width: isPortrait ? 48 : 100,
                height: isPortrait ? 48 : 100,
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(19),
                  ),
                  // radius: 14,
                  // backgroundColor: Theme.of(context).accentColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 2),
                    child: Text(
                      quantity,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ))
            ],
          ),
        ));
  }
}

class DashboardAnalyticsItem extends StatelessWidget {
  const DashboardAnalyticsItem({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.iconPath,
    required this.color,
    this.iconScale = 1,
  }) : super(key: key);
  final String title;
  final String subTitle;
  final String iconPath;
  final Color color;
  final double iconScale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child: Container(
        // height: 155,
        width: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              Spacer(),
              Image.asset(
                iconPath,
                scale: iconScale,
                width: 48,
                height: 48,
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subTitle,
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
