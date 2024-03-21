// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/app_components/input_field.dart';
import 'package:farmer_app/Ui/app_components/placeholder_image.dart';
import 'package:farmer_app/Ui/home_produces/Home_Produces.dart';
import 'package:farmer_app/Ui/registeration/login_screen.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/config/mj_config.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/user/my_profile_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/src/provider.dart';

import '../../helpers/color_constants.dart';
import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfile extends StatefulWidget {
  static const String routeName = "/profile_edit";

  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DateTime selectedDate = DateTime.now();
  MjApiService apiService = MjApiService();


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1960),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateOfBirthCtrl.text = DateFormat.yMd().format(selectedDate);
      });
  }

  TextEditingController firstNameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  TextEditingController userNameCtrl = TextEditingController();

  // TextEditingController passwordCtrl = TextEditingController();
  TextEditingController phoneNumberCtrl = TextEditingController();
  TextEditingController dateOfBirthCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  String profilePic = '';

  // File? imageFile;
  _getFromGallery() async {
    try {
      PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
      );
      // File file = File("");
      if (pickedFile != null) {
        File? croppedFile = await ImageCropper().cropImage(
            sourcePath: pickedFile.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: 'Crop Image',
                toolbarColor: kYellowColor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            ));
        if (croppedFile != null) {
          // setState(() {
          //   imageFile = croppedFile;
          // });
          uploadImage(croppedFile);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  uploadImage(File pickedFile) async {
    showProgressDialog(context, "Uploading");
    var response = await apiService.postMultiPartRequest(
        MJ_Apis.upload_image + "/user", {"image": File(pickedFile.path)});
    hideProgressDialog(context);
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
    if (profilePic.isNotEmpty) {
      deleteImage(profilePic);
    }
    setState(() {
      profilePic = url;
      // User usr = await getuser();
      // setState(() {
      //   user = usr;
      // });
      // imageFile = null;
    });
    if (user != null) {
      user.profileImage = url;
    }
    saveImage(profilePic);
    // await setUser(user);
  }
 ////////////////////////////////////////////////////////////
  saveImage(String image) async {
    dynamic paylaod = {
      "profile_image": image,
    };
    print(paylaod);
    // showProgressDialog(context, MJConfig.please_wait);
    dynamic response = await apiService.simplePostRequest(
        MJ_Apis.update_user + "/" + user.id!, paylaod);
    // hideProgressDialog(context);
    print('responseImp: ${response}');
    // print(response['user_name'].toString());
    if (response != null) {
      print('response status: ' + response['status'].toString());
      showToast(response['message']);
      // print('status: ${response['status']}');
      if (response['status'] == 1) {
        var token = this.user.token;
        User user = User.fromJson(response['response']['user']);
        user.token = token;
        setUser(user);
        context.read<MyProfileProvider>().setMyProfile(user);
      }
    }
  }

  save() async {
    dynamic paylaod = {
      "firstname": firstNameCtrl.text,
      "lastname": lastNameCtrl.text,
      "username": userNameCtrl.text,
      "phone_number": phoneNumberCtrl.text,
      "age": dateOfBirthCtrl.text,
      "address": addressCtrl.text,
      "email": user.email!,
      "profile_image": profilePic,
    };
    print(paylaod);
    showProgressDialog(context, MJConfig.please_wait);
    dynamic response = await apiService.simplePostRequest(
        MJ_Apis.update_user + "/" + user.id!, paylaod);
    hideProgressDialog(context);
    print('responseImp: ${response}');
    // print(response['user_name'].toString());
    if (response != null) {
      print('response status: ' + response['status'].toString());
      showToast(response['message']);
      // print('status: ${response['status']}');
      if (response['status'] == 1) {
        var token = this.user.token;
        User user = User.fromJson(response['response']['user']);
        user.token = token;
        setUser(user);
        context.read<MyProfileProvider>().setMyProfile(user);
        Navigator.of(context).pop();
      } else {}
    }
  }

  User user = User();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getuser();
  }

  getuser() async {
    user = (await getUser())!;
    setState(() {});

    if (user != null) {
      firstNameCtrl.text = user.firstname ?? '';
      lastNameCtrl.text = user.lastname ?? '';
      userNameCtrl.text = user.username ?? '';
      phoneNumberCtrl.text = user.phoneNumber!;
      dateOfBirthCtrl.text = dateOfBirthCtrl.text;
      addressCtrl.text = user.address ?? '';
      // passwordCtrl.text = user!.password ?? '';
      setState(() {
        profilePic = user.profileImage ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(243, 243, 243, 1),
      appBar: AppBar(
        // backgroundColor: Theme,
        leading: getDefaultAppBackButton(color: Colors.white),
        elevation: 0,
        toolbarHeight: 50,
        title: Text('${user.firstname} ${user.lastname}'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        _getFromGallery();
                      },
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: profilePic != ""
                              ?
                              // FileImage()
                              CacheImage(
                                  width: 90,
                                  height: 90,
                                  url: "${MJ_Apis.APP_BASE_URL}${profilePic}",
                                  fit: BoxFit.cover,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                      color: Colors.black12,
                                      child: Image.asset(
                                        "assets/icons/profile.png",
                                        color: Colors.grey,
                                        height: 90,
                                        width: 90,
                                        fit: BoxFit.fitHeight,
                                      ))
                                  // : Image.file(File(imageFile!.path), height: 90, width: 90,)
                                  ),
                        ),

                        // child:
                        //   CircleAvatar(
                        //   backgroundColor: Colors.transparent,
                        //   radius: 50,
                        //   child:imageFile== null ?
                        //   Image.asset("assets/icons/profile.png",) : Image.file(File(imageFile!.path,))
                        //   ),
                      )),
                ],
              ),
              Text(
                "Edit profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 10, 0),
                child: Column(
                  children: [
                    profileTextField(
                      controller: firstNameCtrl,
                      labelText: "First Name",
                      icon: Icons.person,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    profileTextField(
                      controller: lastNameCtrl,
                      labelText: "Last Name",
                      icon: Icons.person_outline,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    profileTextField(
                      controller: userNameCtrl,
                      labelText: "Username",
                      icon: Icons.privacy_tip,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // profileTextField(
                    //   controller: passwordCtrl,
                    //   labelText: "Password",
                    //   icon: Icons.password,
                    // ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    profileTextField(
                      controller: phoneNumberCtrl,
                      labelText: "Phone Number",
                      icon: Icons.phone,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    profileTextField(
                      onTap: () {
                        _selectDate(context);
                      },
                      showKeyboard: false,
                      controller: dateOfBirthCtrl,
                      labelText: "Date of Birth",
                      icon: Icons.calendar_today,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    profileTextField(
                      controller: addressCtrl,
                      labelText: "Address",
                      icon: Icons.location_city,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FlatButton(
                      color: kprimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      onPressed: () {
                        save();
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
