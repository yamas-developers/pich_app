import 'package:farmer_app/helpers/cart/cart_helper.dart';
import 'package:farmer_app/helpers/firebase/firebase_helper.dart';
import 'package:farmer_app/providers/chat/connections_provider.dart';
import 'package:farmer_app/providers/location/current_location_provider.dart';
import 'package:farmer_app/providers/post/post_comment_provider.dart';
import 'package:farmer_app/providers/post/post_provider.dart';
import 'package:farmer_app/providers/post/profile_posts_provider.dart';
import 'package:farmer_app/providers/produce_bag/home_produce_bag_provider.dart';
import 'package:farmer_app/providers/produce_bag/vendor_produce_bag_provider.dart';
import 'package:farmer_app/providers/product/home_store_product.dart';
import 'package:farmer_app/providers/product/product.dart';
import 'package:farmer_app/providers/product/store_product.dart';
import 'package:farmer_app/providers/recipes/recipes_provider.dart';
import 'package:farmer_app/providers/search/profiles_provider.dart';
import 'package:farmer_app/providers/store/home_store_list_provider.dart';
import 'package:farmer_app/providers/store/vendor_payment_request_provider.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:farmer_app/providers/user/my_profile_provider.dart';
import 'package:farmer_app/providers/user/user_dynamic_form_provider.dart';
import 'package:farmer_app/providers/user/user_notification_provider.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:farmer_app/providers/voucher/user_voucher_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:farmer_app/providers/social/social_provider.dart';

import 'chat/conversation_provider.dart';
import 'order/user_order_provider.dart';

List<SingleChildWidget> providers = [
  ...independentProviders
];

List<SingleChildWidget> independentProviders = [
  ChangeNotifierProvider(create: (_) => UserProvider()),
  ChangeNotifierProvider(create: (_) => VendorStoreProvider()),
  ChangeNotifierProvider(create: (_) => ProductProvider()),
  ChangeNotifierProvider(create: (_) => StoreProductProvider()),
  ChangeNotifierProvider(create: (_) => VendorProduceBagProvider()),
  ChangeNotifierProvider(create: (_) => PostProvider()),
  ChangeNotifierProvider(create: (_) => ProfilePostProvider()),
  ChangeNotifierProvider(create: (_) => MyProfileProvider()),
  ChangeNotifierProvider(create: (_) => HomeStoreListProvider()),
  ChangeNotifierProvider(create: (_) => HomeProduceBagProvider()),
  ChangeNotifierProvider(create: (_) => HomeStoreProductProvider()),
  ChangeNotifierProvider(create: (_) => CurrentLocationProvider()),
  ChangeNotifierProvider(create: (_) => RecipesProvider()),
  ChangeNotifierProvider(create: (_) => ProfilesProvider()),
  ChangeNotifierProvider(create: (_) => CartHelper()),
  ChangeNotifierProvider(create: (_) => UserVoucherProvider()),
  ChangeNotifierProvider(create: (_) => PostCommentProvider()),
  ChangeNotifierProvider(create: (_) => UserCurrentOrderProvider()),
  ChangeNotifierProvider(create: (_) => UserPreviousOrderProvider()),
  ChangeNotifierProvider(create: (_) => ConversationProvider()),
  ChangeNotifierProvider(create: (_) => UserDynamicFormProvider()),
  ChangeNotifierProvider(create: (_) => FirebaseHelper()),
  ChangeNotifierProvider(create: (_) => UserNotificationProvider()),
  ChangeNotifierProvider(create: (_) => FollowingsProvider()),
  ChangeNotifierProvider(create: (_) => FollowersProvider()),
  ChangeNotifierProvider(create: (_) => VendorPaymentRequestProvider()),
  ChangeNotifierProvider(create: (_) => SocialProvider()),


];
