import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/store/edit_store_form.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class VendorStoreItem extends StatelessWidget {
  VendorStoreItem({
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
        context.read<VendorStoreProvider>().setCurrentStore(store.id);
        context.read<VendorStoreProvider>().getVendorStoreData();
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
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
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.red,
                        child: CacheImage(
                          url: "${MJ_Apis.APP_BASE_URL}${store.storeIcon}",
                          width: 20,
                          height: 20,
                        )
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: Container(
                        // height: 20,
                        // width: 20,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorVary % 2 == 0
                              ? kYellowColor
                              : kprimaryColor,
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Container(
                            // height: 20,
                            // width: 20,
                            // padding: EdgeInsets.fromLTRB(8,6,8,6),
                            decoration: BoxDecoration(
                              // color: Colors.red,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                "${colorVary+1}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  fontSize: 12
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
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
                Container(
                  // height: 30,
                  // width: 30,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: TouchableOpacity(
                      onTap: () async {

                        var a = await Navigator.pushNamed(
                            context, EditStoreForm.routeName, arguments: store);
                        // context.read<VendorStoreProvider>().getVendorStores();
                      },
                      child: Icon(Icons.edit, color: Colors.white,size: 24,)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
