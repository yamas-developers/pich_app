// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:farmer_app/Ui/app_components/app_color_button.dart';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/input_field.dart';
import 'package:farmer_app/Ui/app_components/touchable_opacity.dart';
import 'package:farmer_app/Ui/store/store.dart';
import 'package:farmer_app/Ui/store/store_detail.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/config/mj_config.dart';
import 'package:farmer_app/helpers/color_circular_progress_indicator.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/store.dart' as store;
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/store/vendor_store_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../helpers/color_constants.dart';

class EditStoreForm extends StatefulWidget {
  static const String routeName = "/edit_store_form";
  final TextEditingController latCtrl = TextEditingController();
  final TextEditingController lngCtrl = TextEditingController();

  EditStoreForm();

  @override
  State<EditStoreForm> createState() => _EditStoreFormState();
}

class _EditStoreFormState extends State<EditStoreForm> {
  String? _dropdownvalue;
  store.Store? storeData;
  TextEditingController txtStoreName = TextEditingController();
  final TextEditingController txtAddress = TextEditingController();
  List<String> images = [];

  bool isinit = false;

  bool isLoading = false;

  // File? image_1, image_2, image_3, image_4,storeIcon;
  int selectedType = 0;
  User? user;
  String img1 = '', img2 = '', img3 = '', img4 = '', iconImage = '';

  selectImage(type) async {
    // switch(type){
    //   case 1:
    //
    // }
    if (isLoading) {
      showToast("please wait till previous file uploads");
      return;
    }
    selectedType = type;
    selectGalleryImage();
  }

  cameraBottomSheet() async {}

  selectGalleryImage() async {
    try {
      var pickedfile = await ImagePicker().pickMultiImage(imageQuality: 12);
      print("--------->");
      print(pickedfile.length);
      if (pickedfile != null) {
        if (selectedType == -1 && pickedfile.length > 1) {
          var list = [];
          list.addAll(pickedfile);
          pickedfile.clear();
          pickedfile.add(list.first);
        }
        for (int i = 0; i < pickedfile.length; i++) {
          setState(() {
            isLoading = true;
          });
          showProgressDialog(context, "Uploading image ${i + 1}",
              isDismissable: false);
          var response = await MjApiService().postMultiPartRequest(
              MJ_Apis.upload_image + "/store",
              {"image": File(pickedfile[i].path)});
          hideProgressDialog(context);

          setState(() {
            isLoading = false;
          });
          String url = '';
          if (response != null) {
            url = response['url'];
          } else {
            return;
          }
          if (url.isEmpty) {
            showToast("image uploading failed");
            return;
          }
          if (selectedType != -1) {
            selectedType = i + 1;
          }
          switch (selectedType) {
            case -1:
              if (iconImage.isNotEmpty) {
                deleteImage(iconImage);
              }
              iconImage = url;
              break;
            default:
              images.add(url);
              break;
          }
          setState(() {
            images = images;
            iconImage = iconImage;
          });
        }
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error:" + e.toString());
    }
  }

  deleteImage(String url) async {
    if (url.startsWith('/')) {
      url = url.substring(1);
    }
    // print(url);
    MjApiService().postRequest(MJ_Apis.delete_file, {"path": url});
  }

  selectCameraImage(type) async {}

  submit() async {
    // print(image_1!.path);
    if (images.isEmpty) {
      showToast("Need to upload atleast 1 shop images");
      return;
    }
    if (iconImage.isEmpty) {
      showToast("Cannot submit your request without store icon.");
      return;
    }
    if (widget.latCtrl.text.isEmpty || widget.lngCtrl.text.isEmpty) {
      showToast("Please select store location before submiting");
      return;
    }
    img1 = '';
    img2 = '';
    img3 = '';
    img4 = '';
    for(int i = 0 ; i < images.length ; i++){
      if(i == 0){
        img1 = images[i];
      }
      if(i == 1){
        img2 = images[i];
      }
      if(i == 2){
        img3 = images[i];
      }
      if(i == 3){
        img4 = images[i];
      }
    }

    var data = {
      "store_name": txtStoreName.text,
      "image_1": img1,
      "image_2": img2,
      "image_3": img3,
      "image_4": img4,
      "images": jsonEncode(images),
      "lat": widget.latCtrl.text,
      "lng": widget.lngCtrl.text,
      "icon": iconImage,
      "address": txtAddress.text
    };
    showProgressDialog(context, MJConfig.please_wait, isDismissable: false);
    var response = await MjApiService()
        .postRequest(MJ_Apis.update_store + "/" + user!.id! + "/" + storeData!.id.toString(), data);
    hideProgressDialog(context);
    if (response != null) {
      showToast("Store Updated Successfully");
      var mapList = response;
      var list = <store.Store>[];
      for (int i = 0; i < mapList.length; i++) {
        list.add(store.Store.fromJson(mapList[i]));
      }
      context.read<VendorStoreProvider>().set(list);
      Navigator.pop(context);
    }
    print(response);
  }

  getPageData() async {
    user = (await getUser())!;
  }
  setPageData() async {
    txtStoreName.text = storeData!.storeName ?? '';
    txtAddress.text = storeData!.address ?? '';

    setState(() {
      iconImage = storeData!.storeIcon ?? '';
      img1 = storeData!.image1 ?? '';
      img2 = storeData!.image2 ?? '';
      img3 = storeData!.image3 ?? '';
      img4 = storeData!.image4 ?? '';
      // images = storeData!.images
      widget.latCtrl.text = storeData!.lat ?? '';
      widget.lngCtrl.text = storeData!.lng ?? '';
    });
    images.addAll([img1, img2, img3, img4]);
    images.removeWhere((element) => element.isEmpty);
  }

  @override
  void dispose() {
    // progressController.stop();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  initState() {
    getPageData();
    // progressController.drive(Constraints.colorTween);
    // progressController.repeat();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(storeData == null){
      storeData = ModalRoute.of(context)!.settings.arguments as store.Store?;
      print("storeData in didchangedepend: ${storeData!.storeName}");
      if (storeData != null)setPageData();
      isinit = true;
    }

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
              height: 100,
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
                            "Edit Your Store",
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
                            "Please specify modifications below",
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
              padding: const EdgeInsets.fromLTRB(13, 15, 13, 10),
              child: CircularInputField(
                label: "Store Name",
                controller: txtStoreName,
                bgColor: inputGreyColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Upload store icon",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            isLoading
                ? ColorCircularProgressIndicator(
              message: "uploading",
            )
                : TouchableOpacity(
              onTap: () {
                selectImage(-1);
              },
              child: Container(
                height: 100,
                child: CacheImage(
                  height: 30,
                  width: 100,
                  url: MJ_Apis.APP_BASE_URL + iconImage,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 15, 13, 10),
              child: GestureDetector(
                onTap: () async {
                  var args =
                  await Navigator.pushNamed(context, StoreDetail.routeName);
                  if (args != null) {
                    setState(() {
                      var data = args as Map;
                      widget.latCtrl.text = data['lat'];
                      widget.lngCtrl.text = data['lng'];
                      txtAddress.text = data['address'];
                    });
                    print('$args');
                  }
                  // Navigator.pushNamed(context, StoreDetail.routeName);
                },
                child: Container(
                  height: 44,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: inputGreyColor,
                      border: Border.all(color: kprimaryColor.withOpacity(.4))),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Text(
                      widget.latCtrl.text.length < 1
                          ? "Select Location"
                          : "${txtAddress.text} ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Place the image of the store",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 100,
              child: ListView(
                padding: EdgeInsets.all(6.0),
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(images.length < 1)
                        AnimatedContainer(
                          duration: Duration(milliseconds:400),
                          width: getWidth(context),
                          child: Center(
                            child: TouchableOpacity(
                              onTap: () {
                                selectImage(-2);
                              },
                              child: Image.asset("assets/images/add_image.png",
                                width: 70, height: 70,),
                            ),
                          ),
                        ),
                      for (int j = 0; j < images.length; j++)
                        Row(
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CacheImage(
                                    height: 90,
                                    width: 100,
                                    url: MJ_Apis.APP_BASE_URL + images[j],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(.8),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: TouchableOpacity(
                                    onTap: () {
                                      deleteImage(images[j]);
                                      images.removeAt(j);
                                      setState(() {});
                                    },
                                    child: Icon(Icons.delete,color: Colors.white,),
                                    // color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 6,
                            ),
                          ],
                        ),

                      TouchableOpacity(
                        onTap: () {
                          selectImage(-2);
                        },
                        child: Image.asset("assets/images/add_image.png",
                          width: 70, height: 70,),
                      )
                    ],
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                  width: getWidth(context) / 2,
                  height: 40,
                  child: AppColorButton(
                    onPressed: () {
                      submit();
                      // Navigator.pushNamed(context, Products.routeName);
                    },
                    elevation: 0,
                    fontSize: 12,
                    color: kYellowColor,
                    name: "Save",
                  )

              ),
            ),
          ],
        ),
      ),
    );
  }
}
