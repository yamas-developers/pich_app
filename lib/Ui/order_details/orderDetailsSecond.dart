// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../helpers/color_constants.dart';

class orderDetailsSecond extends StatefulWidget {
  static const String routeName = "/order_details_second";
  const orderDetailsSecond({Key? key}) : super(key: key);

  @override
  State<orderDetailsSecond> createState() => _orderDetailsSecondState();
}

class _orderDetailsSecondState extends State<orderDetailsSecond> {
  bool isPortrait =true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      appBar: AppBar(
        //   centerTitle: true,
        // title: Text("Order Details",
        // style: TextStyle(
        //   color: Colors.black
        // ),),
        backgroundColor: kprimaryColor,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Image.asset("assets/icons/back-arrow.png", height: 25,)
                    ),
                    Expanded(
                      child: Center(
                        child: Text("Order Confirmation", style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600
                        ),),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20,30,0,10),
                  child: Row(
                    children: [
                      Text("Store Details",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500
                        ),),
                    ],
                  ),
                ),
                Container(
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    color: kprimaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: kRedColor,
                              radius: 25,
                              child: Image.asset("assets/icons/vendor.png",height: 22,),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Billy Vendor", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),),
                                Text("Main Street Downtown",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12
                                  ),),
                              ],
                            ),
                            Spacer(),
                            Image.asset("assets/icons/location_icon.png", height: 20,)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Order Details",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    ],
                  ),
                ),

                Column(
                  children: [
                    Container(
                      height: 290,
                      decoration: BoxDecoration(
                        color: kGrey,
                        borderRadius: BorderRadius.circular(19),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/images/bag.png", height: 25,),
                                SizedBox(width: 10,),
                                Text("1x Food Boxes",
                                    style:TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                    )),
                                Spacer(),
                                Text("\$17.54", style: TextStyle(
                                    color: kprimaryColor,
                                    fontWeight: FontWeight.w600
                                ),)
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  Text("5 items",
                                    style: TextStyle(
                                      color: kYellowColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Image.asset("assets/icons/pear.png",height: 30,),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text("Pear",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  Spacer(),
                                  Text("500g",
                                    style: TextStyle(
                                        color: kprimaryColor,
                                        fontSize: 13
                                    ),)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Image.asset("assets/icons/lemon.png",height: 19,),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text("Lemon",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  Spacer(),
                                  Text("250g",
                                    style: TextStyle(
                                        color: kprimaryColor,
                                        fontSize: 13
                                    ),)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Image.asset("assets/icons/grape.png",height: 30,),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text("Grape",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  Spacer(),
                                  Text("500g",
                                    style: TextStyle(
                                        color: kprimaryColor,
                                        fontSize: 13
                                    ),)
                                ],
                              ),
                            ),  Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Image.asset("assets/icons/watermelon.png",height: 30,),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text("Watermelon",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  Spacer(),
                                  Text("Medium",
                                    style: TextStyle(
                                        color: kprimaryColor,
                                        fontSize: 13
                                    ),)
                                ],
                              ),
                            ),  Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Image.asset("assets/images/banana.png",height: 30,),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text("Banana",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500
                                    ),),
                                  Spacer(),
                                  Text("6",
                                    style: TextStyle(
                                        color: kprimaryColor,
                                        fontSize: 13
                                    ),)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,20,0,10),
                  child: Row(
                    children: [
                      Text("Vouchers",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500
                        ),),
                    ],
                  ),
                ),
                Stack(
                    alignment: Alignment.centerRight,
                    children:[
                      Container(
                        height: 100,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/icons/background.png",
                              ),
                              fit: BoxFit.fill
                          ),
                        ),
                        child:Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding:  EdgeInsets.fromLTRB( isPortrait? 60: 120  ,  15 ,0,10),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text("Expiry",
                                        style: TextStyle(fontSize: 15),),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "12 July 2022",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: kGreyColor),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: EdgeInsets.only(right: isPortrait ? 30.0 : 50),
                              child: Text(
                                "\$50.0",
                                style: TextStyle(
                                    color: kprimaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: kprimaryColor,
                        radius: 11,
                        child: Image.asset("assets/icons/tick.png",
                          height: 9,),
                      ),
                    ]
                ),
              ],
            ),
          ),
        ),
      ),
    );


  }
}
