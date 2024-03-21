import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/models/store.dart';
import 'package:flutter/material.dart';
import 'package:farmer_app/Ui/store/store.dart' as st;


class PopularStoreItem extends StatelessWidget {
  PopularStoreItem({Key? key,@required this.store}) : super(key: key);
  Store? store;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.fromLTRB(0, 8, 8, 8),
      child:TouchableOpacity(
        onTap: (){
          Navigator.pushNamed(context, st.Store.routeName, arguments: store);
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(19),
              color: containerGreyShade),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CacheImage(
                    url: '${MJ_Apis.APP_BASE_URL}${store!.storeIcon}',
                    width: 18,
                    height: 18,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text('${store!.storeName}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
