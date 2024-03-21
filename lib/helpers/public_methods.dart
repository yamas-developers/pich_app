import 'package:farmer_app/Ui/app_components/app_back_button.dart';
import 'package:farmer_app/Ui/registeration/login_screen.dart';
import 'package:farmer_app/Ui/user_profile/edit_profile.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/helpers/cart/cart_helper.dart';
import 'package:provider/provider.dart';
import 'package:farmer_app/models/post_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

Container getDefaultAppBackButton({color}) {
  if (color == null) {
    color = Colors.black;
  }
  return Container(
    padding: EdgeInsets.all(12),
    child: AppBackButton(
      color: color,
    ),
  );
}

double getHeight(@required context) {
  return MediaQuery.of(context).size.height;
}

double getWidth(@required context) {
  return MediaQuery.of(context).size.width;
}

showProfileMenuBottomSheet(context) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (context) {
        TextStyle _sheetItemStyle =
            TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 6,
              ),
              SizedBox(
                  width: 40,
                  child: Divider(
                    color: Colors.blueGrey,
                    thickness: 3,
                    // endIndent: ,
                  )),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, EditProfile.routeName);
                },
                leading: Icon(
                  Icons.person_outline,
                  color: Colors.black,
                  size: 30,
                ),
                title: Text(
                  'Edit Profile',
                  style: _sheetItemStyle,
                ),
              ),
              ListTile(
                onTap: () async {
                  Navigator.of(context).pop();
                  if (await logout()) {
                    context.read<CartHelper>().clearCart();
                    clearVendorData(context);
                    showToast("You are now logged out");
                    Navigator.pushReplacementNamed(
                        context, LoginScreen.routeName);
                  } else {
                    showToast("cannot logout right now");
                  }
                },
                leading: Icon(
                  Icons.logout_outlined,
                  color: Colors.black,
                  size: 30,
                ),
                title: Text(
                  'Logout',
                  style: _sheetItemStyle,
                ),
              ),
              ListTile(
                onTap: () async {
                  showAlertDialog(context, "Delete Account?",
                      "All of your data will be deleted. You won't be able to access orders, chats and all other added or generated data."
                          " Are you sure you want to delete?",
                      type: AlertType.ERROR,
                      okButtonText: "Sure",
                      showCancelButton: true, onPress: () async {
                    Navigator.pop(context);
                    showProgressDialog(context, 'Deleting');

                    bool res = await context
                        .read<UserProvider>()
                        .update_user_status('Inactive');
                    hideProgressDialog(context);
                    if (res) {
                      if (await logout()) {
                        context.read<CartHelper>().clearCart();
                        clearVendorData(context);
                        // showToast("You are now logged out");
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      } else {
                        showToast("cannot proceed right now");
                      }
                    }
                  });
                },
                leading: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 30,
                ),
                title: Text(
                  'Delete Account',
                  style: _sheetItemStyle.copyWith(color: Colors.red),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        );
      });
}

Widget productStatusWidget(
    @required context, @required onTap, @required status) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: containerGreyShade,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  onTap("Active");
                },
                child: Container(
                  height: 34,
                  decoration: BoxDecoration(
                      color: status == "Inactive"
                          ? null
                          : Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    'Enable',
                    style: TextStyle(
                        color: status == "Inactive"
                            ? Theme.of(context).primaryColor
                            : Colors.white),
                  )),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  onTap("Inactive");
                },
                child: Container(
                  height: 34,
                  decoration: BoxDecoration(
                    color: status == "Inactive"
                        ? Theme.of(context).accentColor
                        : null,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                    'Disable',
                    style: TextStyle(
                        color: status == "Inactive"
                            ? Colors.white
                            : Theme.of(context).primaryColor),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

deleteImage(String url) async {
  if (url.startsWith('/')) {
    url = url.substring(1);
  }
  // print(url);
  var response =
      await MjApiService().postRequest(MJ_Apis.delete_file, {"path": url});
  return response;
}

getThumbnails(PostData postData) async {
  List thumbs = [];
  if ((postData.postVideos?.length ?? 0) > 0) {
    dynamic path = await VideoThumbnail.thumbnailFile(
      video: "${MJ_Apis.APP_BASE_URL}${postData.postVideos![0].video!}",
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 260,
      // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 100,
    );

    return path;
  }
}

clearVendorData(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.remove('store');
  context.read<VendorStoreProvider>().currentStore = null;
  context.read<VendorStoreProvider>().set([]);
}
