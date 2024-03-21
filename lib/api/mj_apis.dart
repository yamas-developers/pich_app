class MJ_Apis {
  //https://pich.unitedsoftservices.com/api/mjcoder/register
  // static const APP_BASE_URL = "https://pich.dodson-development.com/";
  static const APP_BASE_URL = "https://pich.dodsondevelopment.tech/";

  // static const APP_BASE_URL = "https://pich.mjcoders.ml/";
  static const BASE_URL = APP_BASE_URL + "api/mjcoder/";
  static const signup = "register";
  static const login = "login";
  static const create_post = "create_post";
  static const create_store = "create_store";
  static const upload_post_image = "upload_image/post";
  static const upload_store_image = "upload_image/store";
  static const upload_video = "upload_video";
  static const post_list = "post_list";
  static const update_user = "update_user";
  static const update_user_status = "update_user_status";
  static const delete_file = "delete_file";
  static const vendor_stores = "get_vendor_stores";
  static const upload_image = "upload_image";
  static const get_all_products = "all_products";
  static const add_store_product = "pich_store_product";
  static const create_produce_bag = "create_produce_bag";
  static const get_store_product_bag = "get_store_product_bag";
  static const edit_store_product = "edit_store_product";
  static const get_store_products = "get_store_products";
  static const get_post_list = "post_list";
  static const get_profile_post_list = "profile_post_list";
  static const get_profile = "get_profile";
  static const get_home_stores = "get_home_stores"; // {user_id}
  static const get_current_location_stores =
      "get_current_location_stores"; // {user_id}
  static const get_home_product_bag = "get_home_product_bag"; // {user_id}
  static const get_home_products = "get_home_products"; // {user_id}
  static const get_product_recipes = "get_product_recipes"; // {user_id}
  static const get_profiles = "get_profiles"; // {user_id} ?swarc
  static const get_social_profiles =
      "get_social_profiles"; // {user_id} type ?swarc
  static const follow = "follow"; // {user_id}
  static const check_cart = "check_cart";

  static const get_user_voucher = 'get_user_voucher'; // {user_id}
  static const get_user_other_voucher = 'get_user_other_voucher'; // {user_id}
  static const add_like = 'add_like'; // {user_id}
  static const report_post = 'report_post'; // post
  static const block_user = 'block_user'; //{user_id}/{block_user_id}
  static const submit_order = 'submit_order'; // {user_id}
  static const get_store_by_id = 'get_store_by_id'; // {store_id}
  static const get_post_comments = 'get_post_comments'; // {user_id} / {post_id}
  static const add_comment = 'add_comment'; // {user_id} / {post_id}
  static const get_all_orders = 'get_all_orders'; // {user_id} / post_request
  static const today_store_data = 'today_store_data'; // {store_id} / get_req

  static const user_chats = 'user_chats'; // {user_id} / {post_id}
  static const check_chat = 'check_chat'; // {user_id} / {post_id}
  static const get_chat = 'get_chat'; // {user_id} / {post_id}

  static const update_chat = 'update_chat'; // {user_id} / {post_id}

  static const get_forms = 'get_forms'; // {user_id}
  static const add_user_form = 'add_form_data'; // {user_id}/{form_id}
  static const edit_produces = 'edit_produces'; // {produce_id}/{post_req}
  static const get_user_notification = 'user_notifications'; // {user_id}
  static const post_detail = 'post_detail'; // {user_id} // post id (get)
  static const support_list = 'support_list'; // {user_id}
  static const support = 'support'; // {user_id} post_post
  static const order_status =
      'order_status'; // {order_id} post_post e.g {"order_status" : "Completed"}
  static const get_followers = 'get_followers'; // {user_id}
  static const get_following = 'get_following'; // {user_id}
  static const get_store_earning = 'get_store_earning'; // {user_id}/{store_id}
  static const withdraw_request = 'withdraw_request'; // {user_id}/{store_id}
  static const payment_request = "payment_request"; // /{user_id}/{store_id}
  static const get_request_orders =
      'get_request_orders'; // /{user_id}/{request_id}
  static const update_store = 'update_store'; // /{user_id}/{store_id} //post

}
