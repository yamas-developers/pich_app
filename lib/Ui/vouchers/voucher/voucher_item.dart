import 'package:farmer_app/Ui/app_components/badge.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/models/user_voucher.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class VoucherItem extends StatelessWidget {
  const VoucherItem({
    Key? key,
    required this.voucherData, this.isSelected = false,
    this.showOnclose = false,
    required this.onClose,
  }) : super(key: key);

  final Voucher voucherData;
  final bool isSelected;
  final bool showOnclose;
  final onClose;

  @override
  Widget build(BuildContext context) {
    bool isPortrait = true;
    isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Stack(
      alignment: Alignment.centerRight,

      children: [
        Container(
          height: 100,
          padding: EdgeInsets.fromLTRB(isPortrait ? 10 : 120, 10, 10, 0),
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  isSelected ?
                  "assets/icons/background.png" : "assets/icons/grey_background.png",
                ),
                fit: BoxFit.fill),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(isPortrait ? 60 : 120, 15, 0, 10),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Expiry",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.parse(voucherData.expiryDate!))}",
                          style: TextStyle(fontSize: 13, color: kGreyText),
                        ),
                      ],
                    ),
                    SizedBox(height: 3,),
                    Badge(value: '${voucherData.status}',color: kprimaryColor,),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: isPortrait ? 30.0 : 50),
                child: Text(
                  "\$${voucherData.voucherPrice}",
                  style: TextStyle(
                      color: kprimaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        if(isSelected)CircleAvatar(
          backgroundColor: kprimaryColor,
          radius: 11,
          child: Image.asset(
            "assets/icons/tick.png",
            height: 9,
          ),
        ),
        if(showOnclose)Positioned.fill(
          top: 14,
          right: 10,

          child: Align(
              alignment: Alignment.topRight,
              child: InkWell(
                  onTap: onClose,
                  child: Icon(Icons.remove_circle_outlined, color: Colors.red,size: 20,))),
        ),
      ],
    );
  }
}
