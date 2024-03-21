import 'package:farmer_app/Ui/cart/user_cart.dart';
import 'package:farmer_app/Ui/chat/ConversationList.dart';
import 'package:farmer_app/Ui/chat/chat_detail.dart';
import 'package:farmer_app/Ui/customer_support/customer_support.dart';
import 'package:farmer_app/Ui/home_screen.dart';
import 'package:farmer_app/Ui/notification_screen/notifications_screen.dart';
import 'package:farmer_app/Ui/order_details/OrderDetails.dart';
import 'package:farmer_app/Ui/order_details/orderDetailsFirst.dart';
import 'package:farmer_app/Ui/order_details/orderDetailsSecond.dart';
import 'package:farmer_app/Ui/orders/order_screen.dart';
import 'package:farmer_app/Ui/orders/vendor/vendor_order_list.dart';
import 'package:farmer_app/Ui/posts/create_post.dart';
import 'package:farmer_app/Ui/posts/post_detail.dart';
import 'package:farmer_app/Ui/posts/post_video_screen.dart';
import 'package:farmer_app/Ui/produces/vendor/add_vendor_produce.dart';
import 'package:farmer_app/Ui/produces/vendor/edit_vendor_produces.dart';
import 'package:farmer_app/Ui/produces/vendor/vendor_produces_list.dart';
import 'package:farmer_app/Ui/products/edit_vendor_product.dart';
import 'package:farmer_app/Ui/products/poducts.dart';
import 'package:farmer_app/Ui/products/products.form.dart';
import 'package:farmer_app/Ui/registeration/login_screen.dart';
import 'package:farmer_app/Ui/registeration/otp_verification_screen.dart';
import 'package:farmer_app/Ui/registeration/signup-screen.dart';
import 'package:farmer_app/Ui/splash_screen.dart';
import 'package:farmer_app/Ui/store/edit_store_form.dart';
import 'package:farmer_app/Ui/store/store.dart';
import 'package:farmer_app/Ui/store/store_detail.dart';
import 'package:farmer_app/Ui/store/store_form.dart';
import 'package:farmer_app/Ui/user_profile/ProfileScreen.dart';
import 'package:farmer_app/Ui/user_profile/edit_profile.dart';
import 'package:farmer_app/Ui/user_profile/user_dynamic_forms.dart';
import 'package:farmer_app/Ui/vendor_dashboard/vendor_dashboard_screen.dart';
import 'package:farmer_app/Ui/vendor_dashboard/vendor_earning_screen.dart';
import 'package:farmer_app/Ui/vendor_dashboard/vendor_wallet_screen.dart';
import 'package:farmer_app/Ui/vendor_profile/vendor_profile.dart';
import 'package:farmer_app/Ui/vouchers/selectVouchers.dart';
import 'package:farmer_app/helpers/animate_route.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/Ui/search/search_screen_sheet.dart';

import '../intro_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (BuildContext buildContext) {
        return SplashScreen();
      });
    case IntroScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: IntroScreen(),
          routeName: IntroScreen.routeName);
    case LoginScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: LoginScreen(),
          routeName: LoginScreen.routeName);
    case SignupScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: SignupScreen(),
          routeName: SignupScreen.routeName);
    case CustomerSupportScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: CustomerSupportScreen(),
          routeName: CustomerSupportScreen.routeName);
    case UserDynamicForms.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: UserDynamicForms(),
          routeName: UserDynamicForms.routeName);
    // HomeScreen.routeName : (context) => HomeScreen(userType: '',),
    case HomeScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: HomeScreen(),
          routeName: HomeScreen.routeName);
    //
    case Profile.routeName:
      print(settings.name);
      return routeOne(
          settings: settings, widget: Profile(), routeName: Profile.routeName);

    case SocialScreenSheet.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: SocialScreenSheet(),
          routeName: SocialScreenSheet.routeName);

    case OrderAndVoucherScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: OrderAndVoucherScreen(),
          routeName: OrderAndVoucherScreen.routeName);

    case OrderDetails.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: OrderDetails(),
          routeName: OrderDetails.routeName);
    case orderDetailsFirst.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: orderDetailsFirst(),
          routeName: orderDetailsFirst.routeName);
    case SelectVouchers.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: SelectVouchers(),
          routeName: SelectVouchers.routeName);
    //
    case Store.routeName:
      print(settings.name);
      return routeOne(
          settings: settings, widget: Store(), routeName: Store.routeName);
    case StoreDetail.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: StoreDetail(),
          routeName: StoreDetail.routeName);
    case StoreForm.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: StoreForm(),
          routeName: StoreForm.routeName);
    case EditStoreForm.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: EditStoreForm(),
          routeName: EditStoreForm.routeName);
    case Products.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: Products(),
          routeName: Products.routeName);
    case ProductForm.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: ProductForm(),
          routeName: ProductForm.routeName);
    case AddVendorProduce.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: AddVendorProduce(),
          routeName: AddVendorProduce.routeName);
    //
    case VendorProfile.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: VendorProfile(),
          routeName: VendorProfile.routeName);
    case ConversationList.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: ConversationList(),
          routeName: ConversationList.routeName);
    case EditProfile.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: EditProfile(),
          routeName: EditProfile.routeName);
    case NotificationsScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: NotificationsScreen(),
          routeName: NotificationsScreen.routeName);
    case PostDetailScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: PostDetailScreen(),
          routeName: PostDetailScreen.routeName);
    case CreatePost.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: CreatePost(),
          routeName: CreatePost.routeName);
    case VendorProduceBagsScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: VendorProduceBagsScreen(),
          routeName: VendorProduceBagsScreen.routeName);
    //
    case VendorOrdersScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: VendorOrdersScreen(),
          routeName: VendorOrdersScreen.routeName);
    case OtpVerificationScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: OtpVerificationScreen(),
          routeName: OtpVerificationScreen.routeName);
    case VendorDashboardScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: VendorDashboardScreen(),
          routeName: VendorDashboardScreen.routeName);
    case VendorEarningScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: VendorEarningScreen(),
          routeName: VendorEarningScreen.routeName);
    case VendorWalletScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: VendorWalletScreen(),
          routeName: VendorWalletScreen.routeName);
    case ChatDetail.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: ChatDetail(),
          routeName: ChatDetail.routeName);
    case EditVendorProductScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: EditVendorProductScreen(),
          routeName: EditVendorProductScreen.routeName);
    case UserCartScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: UserCartScreen(),
          routeName: UserCartScreen.routeName);
    case EditVendorProduce.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: EditVendorProduce(),
          routeName: EditVendorProduce.routeName);
    case PostVideoScreen.routeName:
      print(settings.name);
      return routeOne(
          settings: settings,
          widget: PostVideoScreen(),
          routeName: PostVideoScreen.routeName);
    default:
      print("default");
      return routeOne(
          settings: settings,
          widget: LoginScreen(),
          routeName: LoginScreen.routeName);
  }
}
