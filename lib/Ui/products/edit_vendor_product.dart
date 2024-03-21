// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dropdown_search/dropdown_search.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/input_field.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/home_produces/single_item_cart.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/config/mj_config.dart';
import 'package:farmer_app/helpers/color_circular_progress_indicator.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/models/product.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:farmer_app/providers/product/product.dart';
import 'package:farmer_app/providers/product/store_product.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/color_constants.dart';


class EditVendorProductScreen extends StatefulWidget {
  static const String routeName = "/edit_vendor_product_screen";

  @override
  State<EditVendorProductScreen> createState() =>
      _EditVendorProductScreenState();
}

class _EditVendorProductScreenState extends State<EditVendorProductScreen> {
  String? _storeName;
  String? _productName;
  int quantity = 1;
  Enum selectedSize = Size.MEDIUM;
  final _multiKey = GlobalKey<DropdownSearchState<String>>();
  bool isLoading = false;
  List<Product> products = [];
  Product? _selectedProduct;
  TextEditingController txtPrice = TextEditingController();
  String status = "Active";
  StoreProduct? currentProduct;

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
    String size = '';
    size = getSize(selectedSize);
    Store currentStore;
    currentStore = context.read<VendorStoreProvider>().getStore;
    if (currentStore == null) {
      showToast("Cannot get store data.");
      return;
    }
    if (currentProduct == null) {
      showToast("Cannot get related product.");
      return;
    }

    if (txtPrice.text.isEmpty) {
      showToast("Please enter price.");
      return;
    }
    var payload = {
      "product_id": currentProduct!.products!.id.toString(),
      "store_id": currentStore.id.toString(),
      "size": size,
      "price": txtPrice.text,
      "status":status,
    };
    showProgressDialog(context, MJConfig.please_wait);
    var response = await MjApiService().postRequest(
        "${MJ_Apis.edit_store_product}/${currentProduct!.id}",
        payload);
    hideProgressDialog(context);
    if (response != null) {
      List<StoreProduct> list = [];
      for (int i = 0; i < response.length; i++) {
        list.add(StoreProduct.fromJson(response[i]));
      }
      context.read<StoreProductProvider>().set(list);
      Navigator.of(context).pop();
    }
  }

  getPageData() async {
    var data = ModalRoute.of(context)!.settings.arguments;
    currentProduct = data as StoreProduct;
    if (currentProduct != null) {
      setState(() {
        selectedSize = setSize(currentProduct!.size);
        txtPrice.text = currentProduct!.price.toString();
        status = currentProduct!.status!;
      });
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
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: kYellowColor,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 147,
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
                            "Edit Single Items",
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
                            "Update single items related information",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            Consumer<VendorStoreProvider>(builder: (key, provider, widget) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(13, 8, 13, 0),
                child: Container(
                  // width: getWidth(context)/,
                  padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                  decoration: BoxDecoration(
                    color: kprimaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.store,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "${provider.currentStore!.storeName!}",
                        maxLines: 1,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            }),
            SizedBox(
              height: 6,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 0, 13, 8),
              child: Container(
                // width: getWidth(context)/,
                padding: const EdgeInsets.fromLTRB(4, 13, 4, 13),
                decoration: BoxDecoration(
                  color: kprimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CacheImage(
                        url:
                            "${MJ_Apis.APP_BASE_URL}${currentProduct!.products!.image}",
                        width: 40,
                        height: 40,
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${currentProduct!.products!.productName}",
                              maxLines: 1,
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Text(
                              "${currentProduct!.products!.productDescription}",
                              maxLines: 1,
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
              child: CircularInputField(
                controller: txtPrice,
                label: "Price",
                type: TextInputType.number,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //SIZE AND QTY
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Size",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TouchableOpacity(
                            onTap: () {
                              setState(() {
                                selectedSize = Size.SMALL;
                              });
                            },
                            child: Container(
                              height: 33,
                              width: 32,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  "S",
                                  style: TextStyle(
                                    color: selectedSize == Size.SMALL
                                        ? kprimaryColor
                                        : Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TouchableOpacity(
                            onTap: () {
                              setState(() {
                                selectedSize = Size.MEDIUM;
                              });
                            },
                            child: Container(
                              height: 33,
                              width: 32,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  "M",
                                  style: TextStyle(
                                    color: selectedSize == Size.MEDIUM
                                        ? kprimaryColor
                                        : Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TouchableOpacity(
                            onTap: () {
                              setState(() {
                                selectedSize = Size.LARGE;
                              });
                            },
                            child: Container(
                              height: 33,
                              width: 32,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11),
                                  color: Colors.white),
                              child: Center(
                                child: Text(
                                  "L",
                                  style: TextStyle(
                                    color: selectedSize == Size.LARGE
                                        ? kprimaryColor
                                        : Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       "Quantity",
                  //       style: TextStyle(color: Colors.grey.shade700),
                  //     ),
                  //     SizedBox(
                  //       height: 8,
                  //     ),
                  //     Container(
                  //       height: 33,
                  //       width: 114,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(11),
                  //           color: Colors.white),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //         children: [
                  //           GestureDetector(
                  //             onTap: () {
                  //               setState(() {
                  //                 updateQuantity("delete");
                  //               });
                  //             },
                  //             child: Text(
                  //               "-",
                  //               style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 30,
                  //                 fontWeight: FontWeight.w600,
                  //               ),
                  //             ),
                  //           ),
                  //           Text(
                  //             "${quantity}",
                  //             style: TextStyle(
                  //               color: Colors.black,
                  //               fontSize: 15,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //           GestureDetector(
                  //             onTap: () {
                  //               setState(() {
                  //                 updateQuantity("add");
                  //               });
                  //             },
                  //             child: Text(
                  //               "+",
                  //               style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 25,
                  //                 fontWeight: FontWeight.w600,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            productStatusWidget(context, (val) {
              setState(() {
                status = val;
              });
            }, status),
            SizedBox(
              height: 20,
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(13, 15, 13, 10),
            //   child: defaulTextField(
            //     labelText: "Quantity of Product",
            //   )
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(13, 15, 13, 10),
            //   child: defaulTextField(
            //     labelText: "Weight of product",
            //   )
            // ),
            /* Padding(
                padding: const EdgeInsets.fromLTRB(13, 15, 13, 10),
                child: defaulTextField(
                  labelText: "Size of Product",
                )),*/
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: default_button(
                  text: "Submit",
                  press: () {
                    submit();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
