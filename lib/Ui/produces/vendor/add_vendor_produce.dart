// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:farmer_app/Ui/app_components/app_color_button.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/input_field.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/home_produces/single_item_cart.dart';
import 'package:farmer_app/Ui/produces/vendor/vendor_produces_list.dart';
import 'package:farmer_app/Ui/vendor_profile/vendor_profile.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/config/mj_config.dart';
import 'package:farmer_app/helpers/color_circular_progress_indicator.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/store_produce_bag.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:farmer_app/providers/produce_bag/vendor_produce_bag_provider.dart';
import 'package:farmer_app/providers/product/store_product.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

import '../../../helpers/color_constants.dart';


class AddVendorProduce extends StatefulWidget {
  static const String routeName = "/add_vendor_produce_screen";

  AddVendorProduce({Key? key}) : super(key: key);

  @override
  State<AddVendorProduce> createState() => _AddVendorProduceState();
}

class _AddVendorProduceState extends State<AddVendorProduce> {
  int quantity = 1;
  TextEditingController txtBagName = TextEditingController();
  Enum selectedSize = Size.MEDIUM;
  String? _storeproduct;
  String? _quantity;
  String? _price;
  var size, height, width;
  List<ProduceBagProduct> bagProducts = [];
  late Store store = context.read<VendorStoreProvider>().currentStore!;
  bool isStoreProductLoading = false;
  StoreProduct? _selectedProduct;

  getPageData() async {
    if (store == null) {
      showToast("cannot find store");
      return;
    }
    setState(() {
      isStoreProductLoading = true;
    });
    var response = await MjApiService()
        .getRequest("${MJ_Apis.get_store_products}/${store.id}");
    setState(() {
      isStoreProductLoading = false;
    });
    if (response != null) {
      List<StoreProduct> list = [];
      for (int i = 0; i < response.length; i++) {
        list.add(StoreProduct.fromJson(response[i]));
      }
      context.read<StoreProductProvider>().set(list);
    }
  }

  updateQuantity(String type) {
    switch (type) {
      case 'add':
        quantity++;
        break;
      case 'delete':
        if (quantity > 1) quantity--;
        break;
      default:
        break;
    }
    setState(() {
      quantity = quantity;
    });
  }

  submit() async {
    if (txtBagName.text.isEmpty) {
      showToast("Please enter bag title.");
      return;
    }
    if (store == null) {
      showToast("Cannot find store try again next time");
      return;
    }
    if (convertNumber(_price) < 5) {
      showToast("Invalid Price");
      return;
    }
    dynamic listProducts = [];
    for (int i = 0; i < bagProducts.length; i++) {
      listProducts.add({
        "store_product_id": bagProducts[i].storeProduct!.id,
        "quantity": bagProducts[i].quantity,
        "size": bagProducts[i].storeProduct!.size,
      });
    }
    var payload = {
      // "product_id": _selectedProduct!.id.toString(),
      "bag_title": txtBagName.text,
      "price": _price,
      "products": jsonEncode(listProducts)
    };
    showProgressDialog(context, MJConfig.please_wait);
    var response = await MjApiService().postRequest(
        "${MJ_Apis.create_produce_bag}/${store.id}",
        payload);
    hideProgressDialog(context);
    if (response != null) {
      print(response);
      List<StoreProduceBag> list = [];
      for (int i = 0; i < response.length; i++) {
        list.add(StoreProduceBag.fromJson(response[i]));
      }
      context.read<VendorProduceBagProvider>().set(list);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getPageData();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

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
        body: SingleChildScrollView(
          child: Column(children: [
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
                child: Column(children: [
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
                            "Create Food Box",
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
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 15, 13, 0),
              child: Column(
                children: [
                  CircularInputField(
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    label: "Food Box Name",
                    controller: txtBagName,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    //margin: const EdgeInsets.only(left: 5, right: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kprimaryColor)),
                    height: 44,
                    width: double.infinity,
                    // alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(9, 4, 7, 3),
                    child: DropdownButton(
                      isExpanded: true,
                      underline:
                          DropdownButtonHideUnderline(child: Container()),
                      value: _price,
                      hint: Text(
                        "Select Price",
                      ),
                      iconSize: 30.0,
                      items: getPriceArray(5).map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              "\$${val}",
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
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
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: getWidth(context),
              child: Text(
                "Single Items Information?",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 8, 13, 10),
              child: Consumer<StoreProductProvider>(
                builder: (key, provider, widget) => isStoreProductLoading &&
                        provider.list.isEmpty
                    ? ColorCircularProgressIndicator(message: "Loading")
                    : DropdownSearch<StoreProduct>(
                        validator: (value) => value == null ? "empty" : null,
                        // key: _openDropDownProgKey,
                        items: provider.list,
                        showSearchBox: true,
                        popupElevation: 0,
                        popupTitle: Container(
                            width: getWidth(context),
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            decoration: BoxDecoration(color: kprimaryColor),
                            child: Center(
                              child: Text(
                                "Search Single Items",
                                style: TextStyle(
                                  color: Colors.white,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                        searchFieldProps: TextFieldProps(),
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Single Items",
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (val) {
                          setState(() {
                            _selectedProduct = val;
                          });
                        },
                        selectedItem: _selectedProduct,
                        popupItemBuilder: (context, data, isSelected) =>
                            customPopupItemBuilderExample(
                                context,
                                Text(
                                  data.products!.productName!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Price: \$${data.price!} - Size: ${data.size}",
                                  maxLines: 2,
                                ),
                                MJ_Apis.APP_BASE_URL +
                                    data.products!.iconImage!,
                                isSelected),
                        // showSelectedItems: true,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: kYellowColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "Size",
                    //       style: TextStyle(color: Colors.grey.shade700),
                    //     ),
                    //     SizedBox(
                    //       height: 8,
                    //     ),
                    //     Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         TouchableOpacity(
                    //           onTap: () {
                    //             setState(() {
                    //               selectedSize = Size.SMALL;
                    //             });
                    //           },
                    //           child: Container(
                    //             height: 33,
                    //             width: 32,
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(11),
                    //                 color: Colors.white),
                    //             child: Center(
                    //               child: Text(
                    //                 "S",
                    //                 style: TextStyle(
                    //                   color: selectedSize == Size.SMALL
                    //                       ? kprimaryColor
                    //                       : Colors.black,
                    //                   fontSize: 15,
                    //                   fontWeight: FontWeight.w500,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         TouchableOpacity(
                    //           onTap: () {
                    //             setState(() {
                    //               selectedSize = Size.MEDIUM;
                    //             });
                    //           },
                    //           child: Container(
                    //             height: 33,
                    //             width: 32,
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(11),
                    //                 color: Colors.white),
                    //             child: Center(
                    //               child: Text(
                    //                 "M",
                    //                 style: TextStyle(
                    //                   color: selectedSize == Size.MEDIUM
                    //                       ? kprimaryColor
                    //                       : Colors.black,
                    //                   fontSize: 15,
                    //                   fontWeight: FontWeight.w500,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         TouchableOpacity(
                    //           onTap: () {
                    //             setState(() {
                    //               selectedSize = Size.LARGE;
                    //             });
                    //           },
                    //           child: Container(
                    //             height: 33,
                    //             width: 32,
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(11),
                    //                 color: Colors.white),
                    //             child: Center(
                    //               child: Text(
                    //                 "L",
                    //                 style: TextStyle(
                    //                   color: selectedSize == Size.LARGE
                    //                       ? kprimaryColor
                    //                       : Colors.black,
                    //                   fontSize: 15,
                    //                   fontWeight: FontWeight.w500,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   "Quantity",
                        //   style: TextStyle(color: Colors.grey.shade700),
                        // ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          height: 43,
                          width: 114,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: Colors.white),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    updateQuantity("delete");
                                  });
                                },
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                "${quantity}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    updateQuantity("add");
                                  });
                                },
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: getWidth(context) / 2,
                      height: 44,
                      child: AppColorButton(
                        name: "Add",
                        color: kYellowColor,
                        elevation: 0,
                        fontSize: 14,
                        onPressed: () {
                          if (_selectedProduct == null) {
                            showToast("Please select some product");
                            return;
                          }
                          if (quantity < 1) {
                            showToast("please add more then 0 quantity");
                            return;
                          }
                          if (bagProducts
                                  .where((element) =>
                                      _selectedProduct!.id ==
                                      element.storeProduct!.id)
                                  .length >
                              0) {
                            showToast("Product already added");
                            return;
                          }
                          ProduceBagProduct _pbProduct = ProduceBagProduct();
                          _pbProduct.storeProduct = _selectedProduct;
                          _pbProduct.quantity = quantity;
                          bagProducts.add(_pbProduct);
                          _selectedProduct = null;
                          setState(() {
                            bagProducts = bagProducts;
                          });
                          // Navigator.pushNamed(
                          //     context, VendorProduceBagsScreen.routeName);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (bagProducts.length > 1)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AppColorButton(
                  color: kYellowColor,
                  onPressed: () {
                    submit();
                  },
                  elevation: 0,
                  name: "Submit",
                ),
              ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: List.generate(
                  bagProducts.length,
                  (index) => ProducesListContainer(
                      context: context,
                      bagProduct: bagProducts[index],
                      onDelete: () {
                        bagProducts.removeAt(index);
                        setState(() {
                          bagProducts = bagProducts;
                        });
                      }
                      // price: 10.56,
                      // numberOfItems: 6,
                      ),
                ),
              ),
            ),
          ]),
        ));
  }
}

Container ProducesListContainer({
  required BuildContext context,
  required ProduceBagProduct bagProduct,
  required Function onDelete,
  // required double price,
  // required int numberOfItems,
}) {
  return Container(
    margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
    height: 80,
    decoration: BoxDecoration(
      color: itmGreyColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Padding(
            padding: const EdgeInsets.all(18.0),
            child: CacheImage(
              url:
                  "${MJ_Apis.APP_BASE_URL}${bagProduct.storeProduct!.products!.image}",
              width: 50,
              // height: 29,
              fit: BoxFit.contain,
            )),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${bagProduct.storeProduct!.products!.productName}",
                style: TextStyle(
                    fontSize: 15, color: Theme.of(context).primaryColor),
              ),
              Text(
                "Qty ${bagProduct.quantity}",
                style: TextStyle(fontSize: 10, color: Colors.blueGrey),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            onDelete();
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
                    style: TextStyle(color: Colors.white, fontSize: 12),
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
