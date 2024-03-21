// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:farmer_app/Ui/app_components/app_color_button.dart';
import 'package:farmer_app/Ui/app_components/input_field.dart';
import 'package:farmer_app/Ui/vendor_profile/vendor_profile.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:flutter/material.dart';

import '../../helpers/color_constants.dart';
class Produces extends StatefulWidget {
  static String routeName = "/produces_screen";
  Produces({Key? key}) : super(key: key);

  @override
  State<Produces> createState() => _ProducesState();
}

class _ProducesState extends State<Produces> {
  String? _storeproduct;
  String? _quantity;
  String? _price;
  var size, height, width;
  @override

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: kYellowColor,
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: kYellowColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(19),
                bottomRight: Radius.circular(19),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 35, 0, 0),
              child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              "assets/images/arrow-left.png",
                              height: 25,
                            )),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Create Produce Bag ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Please fill out the form",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                  ]
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 15, 13, 8),
            child:  Container(
              //margin: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: kprimaryColor
                  )),
              height: 44,
              width: double.infinity,
              // alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(9, 4, 7, 3),
              child: DropdownButton(
                isExpanded: true,
                underline: DropdownButtonHideUnderline(child: Container()),
                hint: _storeproduct == null
                    ? const Text(
                  "Select Store's Single Items",
                  // textAlign: TextAlign.start,
                )
                    : Text(
                  _storeproduct!,
                  // style: const TextStyle(color: Colors.grey.shade700),
                  //textAlign: TextAlign.center,
                ),
                iconSize: 30.0,
                items:
                ['Banana', 'Watermelon', 'Grapes', 'Lemon', 'Potato'].map(
                      (val) {
                    return DropdownMenuItem<String>(
                      value: val,

                      child: Text(val,
                        style: TextStyle(
                            color: Colors.grey.shade700
                        ),),
                      // alignment: AlignmentDirectional.center,

                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                        () {
                      _storeproduct = val.toString();
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 15, 13, 8),
            child:  Container(
              //margin: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: kprimaryColor
                  )),
              height: 44,
              width: double.infinity,
              // alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(9, 4, 7, 3),
              child: DropdownButton(
                isExpanded: true,
                underline: DropdownButtonHideUnderline(child: Container()),
                hint: _quantity == null
                    ? const Text(
                  "Select Quantity",
                  // textAlign: TextAlign.start,
                )
                    : Text(
                  _quantity!,
                  // style: const TextStyle(color: Colors.grey.shade700),
                  //textAlign: TextAlign.center,
                ),
                iconSize: 30.0,
                items:
                ['1', '2', '3', '4', '5'].map(
                      (val) {
                    return DropdownMenuItem<String>(
                      value: val,

                      child: Text(val,
                        style: TextStyle(
                            color: Colors.grey.shade700
                        ),),
                      // alignment: AlignmentDirectional.center,

                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                        () {
                      _quantity = val.toString();
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 15, 13, 8),
            child:  Container(
              //margin: const EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: kprimaryColor
                  )),
              height: 44,
              width: double.infinity,
              // alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(9, 4, 7, 3),
              child: DropdownButton(
                isExpanded: true,
                underline: DropdownButtonHideUnderline(child: Container()),
                hint: _price == null
                    ? const Text(
                  "Select Price",
                  // textAlign: TextAlign.start,
                )
                    : Text(
                  _price!,
                  // style: const TextStyle(color: Colors.grey.shade700),
                  //textAlign: TextAlign.center,
                ),
                iconSize: 30.0,
                items:
                ['\$5', '\$10', '\$15', '\$20', '\$25'].map(
                      (val) {
                    return DropdownMenuItem<String>(
                      value: val,

                      child: Text(val,
                        style: TextStyle(
                            color: Colors.grey.shade700
                        ),),
                      // alignment: AlignmentDirectional.center,

                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                        () {
                      _price = val.toString();
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: getWidth(context)/2,
              height: 44,
              child: AppColorButton(
                name: "Add",
                color: kYellowColor,
                elevation: 0,
                fontSize: 14,
                onPressed: (){
                  Navigator.pushNamed(context, Produces.routeName);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: height- 520,
              child: ListView.builder(
                itemCount: 13,
                itemBuilder: (ctx, i) => ProducesListContainer(
                  context: context,
                  id: i,
                  leadingIcon: 'assets/images/banana.png',
                  title: 'Banana',
                  // price: 10.56,
                  // numberOfItems: 6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Container ProducesListContainer({
  required BuildContext context,
  required int id,
  required String leadingIcon,
  required String title,
  // required double price,
  // required int numberOfItems,

}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
    height: 60,
    decoration: BoxDecoration(
      color: itmGreyColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Padding(
            padding: const EdgeInsets.all(18.0),
            child: Image.asset(
              leadingIcon,
              width: 30,
              // height: 29,
              fit: BoxFit.cover,
            )),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor),
              ),
              Text(
                "Qty@1",
                style: TextStyle(
                    fontSize: 8, color: Colors.blueGrey),
              )

            ],
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.pushNamed(context, VendorProfile.routeName);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Container(
              height: 30,
              width: 53,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: kYellowColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Delete",
                    style: TextStyle(color: Colors.white,fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
