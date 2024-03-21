import 'package:farmer_app/Ui/orders/user/order_user_item.dart';
import 'package:farmer_app/Ui/user_profile/profile_current_order_section.dart';
import 'package:farmer_app/Ui/user_profile/profile_previous_order_section.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';

class ProfileOrderSection extends StatefulWidget {
  const ProfileOrderSection({Key? key, required this.userId}) : super(key: key);
final String userId;
  @override
  State<ProfileOrderSection> createState() => _ProfileOrderSectionState();
}

class _ProfileOrderSectionState extends State<ProfileOrderSection> {
  bool isCurrent = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 0,
        ),
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
                  setState(() {
                    isCurrent = true;
                  });
                },
                child: Container(
                    alignment: Alignment.center,
                    height: 45,
                    width: 140,
                    decoration: BoxDecoration(
                        color: isCurrent ? kYellowColor : kGrey,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "Current",
                      style: TextStyle(
                          color: isCurrent ? Colors.white : Colors.black),
                    )),
              ),
              GestureDetector(
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
                      borderRadius: BorderRadius.circular(20)),
                  child: GestureDetector(
                    child: Text(
                      "Previous",
                      style: TextStyle(
                          color: isCurrent ? Colors.black : Colors.white),
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
        Expanded(

            child: isCurrent ? ProfileCurrentOrderSection(userId: widget.userId) : ProfilePreviousOrderSection(userId: widget.userId))
      ],
    );
  }
}
