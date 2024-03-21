import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
// import 'package:farmer_app/Ui/store/store.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:farmer_app/Ui/store/store.dart' as st;


class OtherVendorStoreItem extends StatelessWidget {
  OtherVendorStoreItem({
    Key? key,
    required this.store,
    required this.colorVary,
  }) : super(key: key);
  final Store store;
  final int colorVary;

  @override
  Widget build(BuildContext context) {
    print(colorVary);
    // colorVary++;
    return TouchableOpacity(
      onTap: (){
        Navigator.pushNamed(context, st.Store.routeName, arguments: store);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            color: colorVary % 2 == 0
                ? Theme.of(context).primaryColor
                : Theme.of(context).accentColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red,
                    child: CacheImage(
                      url: "${MJ_Apis.APP_BASE_URL}${store.storeIcon}",
                      width: 20,
                      height: 20,
                    )
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${store.storeName}" ,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      if(store.address != null)
                        Text(
                          "${store.address}",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                    ],
                  ),
                ),
                // Container(
                //   height: 30,
                //   width: 30,
                //   padding: EdgeInsets.fromLTRB(8,6,8,6),
                //   decoration: BoxDecoration(
                //     color: Colors.red,
                //     borderRadius: BorderRadius.circular(100),
                //   ),
                //   child: Center(
                //     child: Text(
                //       "${colorVary+1}",
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
