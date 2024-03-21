import 'package:farmer_app/Ui/user_profile/profile_order_section.dart';
import 'package:farmer_app/Ui/user_profile/profile_vouchers_section.dart';
import 'package:farmer_app/Ui/user_profile/user_profile_vendor_stores.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderAndVoucherScreen extends StatefulWidget {
  static const String routeName = "/order_screen";

  const OrderAndVoucherScreen({Key? key}) : super(key: key);

  @override
  State<OrderAndVoucherScreen> createState() => _OrderAndVoucherScreenState();
}

class _OrderAndVoucherScreenState extends State<OrderAndVoucherScreen> {
  User? user;
  String? type = 'data';

  getData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
  }

  @override
  void didChangeDependencies() {
    var data = ModalRoute.of(context)!.settings.arguments;
    if (data != null) {
      type = data as String;
      setState(() {
        type = type;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [
          Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            'assets/icons/arrow-left.png',
                            color: Colors.black,
                            scale: 10,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${type}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: user == null
                  ? emptyWidget(description: "No ${type} found")
                  : type == 'Orders'
                      ? ProfileOrderSection(userId: user!.id ?? '')
                      : ProfileVoucersSection()),
        ]),
      ),
    );
  }
}
