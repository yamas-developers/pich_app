import 'package:farmer_app/Ui/app_components/shimmer_ui/voucher_list_shimmer.dart';
import 'package:farmer_app/Ui/vouchers/voucher/voucher_item.dart';
import 'package:farmer_app/Ui/vouchers/voucher_area.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/models/user_voucher.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:farmer_app/providers/voucher/user_voucher_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProfileVoucersSection extends StatefulWidget {
  const ProfileVoucersSection({Key? key}) : super(key: key);

  @override
  State<ProfileVoucersSection> createState() => _ProfileVoucersSectionState();
}

class _ProfileVoucersSectionState extends State<ProfileVoucersSection> {
  int voucherNumber = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: Wrap(
        children: [
          // SizedBox(
          //   height: 18,
          // ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            height: 55,
            // width: 400,
            decoration: BoxDecoration(
                color: kGrey, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if(voucherNumber == 1) return;
                    context.read<UserVoucherProvider>().list = [];
                    setState(() {
                      voucherNumber = 1;
                    });
                  },
                  child: Container(
                      alignment: Alignment.center,
                      height: 45,
                      width: 140,
                      decoration: BoxDecoration(
                          color: voucherNumber == 1 ? kYellowColor : kGrey,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Current",
                        style: TextStyle(
                            color: voucherNumber == 1
                                ? Colors.white
                                : Colors.black),
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    if(voucherNumber == 2) return;
                    context.read<UserVoucherProvider>().list = [];
                    setState(() {
                      voucherNumber = 2;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 140,
                    decoration: BoxDecoration(
                        color: voucherNumber == 2 ? kYellowColor : kGrey,
                        borderRadius: BorderRadius.circular(20)),
                    child: GestureDetector(
                      child: Text(
                        "Previous",
                        style: TextStyle(
                            color: voucherNumber == 2
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          voucherNumber == 1
              ? VoucherArea(
                  key: UniqueKey(),
                  isCurrent: true,
                )
              : VoucherArea(
                  key: UniqueKey(),
                  isCurrent: false,
                ),
          // SizedBox(
          //   height: getHeight(context) - 140,
          //   child: ListView.builder(
          //       itemCount: 4,
          //       itemBuilder: (context, i) {
          //         return Column(
          //           children: [
          //             VoucherItem(amount: '50',expirydate: '12 - 06 - 2022',),
          //           ],
          //         );
          //       }),
          // ),
        ],
      ),
    );
  }
}
