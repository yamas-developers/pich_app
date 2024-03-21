import 'package:farmer_app/Ui/orders/vendor/order_vendor_item.dart';
import 'package:farmer_app/Ui/user_profile/profile_current_order_section.dart';
import 'package:farmer_app/Ui/user_profile/profile_previous_order_section.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../../helpers/color_constants.dart';

class VendorOrdersScreen extends StatefulWidget {
  static const String routeName ="/vendor_order_list";
  const VendorOrdersScreen({Key? key}) : super(key: key);

  @override
  State<VendorOrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen> {
  bool isCurrent = true;
  User? user;

  @override
  void initState() {
    getPageData();
    super.initState();
  }
  getPageData() async {
    user = context.read<UserProvider>().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 0,
        leading: getDefaultAppBackButton(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Orders"),
            Text("All Orders listing",
              textAlign: TextAlign.start,
              style: TextStyle(
              fontSize: 10
            ),),
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 55,
              // width: 400,
              decoration: BoxDecoration(
                  color: kGrey,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isCurrent = true;
                        });
                      },
                      child: Container(
                          alignment: Alignment.center,
                          height: 45,
                          width: 140,
                          decoration: BoxDecoration(
                              color:
                              isCurrent ? kYellowColor : kGrey,
                              borderRadius:
                              BorderRadius.circular(20)),
                          child: Text(
                            "Current",
                            style: TextStyle(
                                color: isCurrent
                                    ? Colors.white
                                    : Colors.black),
                          )),
                    ),
                  ), 
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isCurrent = false;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: 140,
                        decoration: BoxDecoration(
                            color: isCurrent ? kGrey : kYellowColor,
                            borderRadius:
                            BorderRadius.circular(20)),
                        child: GestureDetector(
                          child: Text(
                            "Previous",
                            style: TextStyle(
                                color: isCurrent
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            if (isCurrent)

              Container(
                height: getHeight(context) * .72,
                child: ProfileCurrentOrderSection(userId: user!.id!,isVendor: true,),
              ),
            if (!isCurrent)
              Container(
                height: getHeight(context) * .72,
                child: ProfilePreviousOrderSection(userId: user!.id!,isVendor: true,),
              ),
          ],
        ),
      ),
    );
  }
}
