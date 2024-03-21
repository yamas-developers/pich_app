// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:farmer_app/Ui/app_components/cache_image.dart';
import 'package:farmer_app/Ui/posts/post_detail.dart';
import 'package:farmer_app/Ui/posts/post_video_screen.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/config/mj_config.dart';
import 'package:farmer_app/helpers/color_circular_progress_indicator.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/post_data.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:path_provider/path_provider.dart';

import '../app_components/placeholder_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../api/mj_api_service.dart';

class CreatePost extends StatefulWidget {
  static const String routeName = "/crate_post";

  const CreatePost({Key? key}) : super(key: key);

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  TextEditingController descriptionController = TextEditingController();

  bool isUploading = false;

  // XFile? imageFile;
  XFile? thumb;
  List<List> imageUrlList = [];
  List<String> imageUrls = [];
  List<String> thumbnailList = [];
  Map videoUrlMap = {};

  final ImagePicker imgpicker = ImagePicker();
  List<List> imagefiles = [];
  List<XFile?> imageList = [];
  List<XFile?> _videoList = [];
  User user = User();

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      //you can use ImageCourse.camera for Camera capture
      if (pickedfiles != null) {
        if (pickedfiles.length > 5 ||
            (pickedfiles.length + imagefiles.length) > 5) {
          showToast('You can not select more than 5 images');
        } else {
          setState(() {
            for (var file in pickedfiles) {
              imagefiles.add([1, file]);
              imageList.add(file);
            }
            showToast('Uploading Images');
            isUploading = true;
            print(pickedfiles.length);
            // pickedfiles.map((e) => imagefiles.add(e));
          });

          for (var file in pickedfiles) {
            Map<String, File> payload = {"image": File(file.path)};

            String url =
                await uploadAndGetUrl(MJ_Apis.upload_post_image, payload);
            if(url != ''){
            imageUrlList.add([file.path, url]);
            imageUrls.add(url);
            }else{
              imageList.remove(file);
              imagefiles.removeWhere((element) => element.contains(file));
            }
          }
          setState(() {
            isUploading = false;
          });
        }

        print(imagefiles);
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print(e);
      print("error while picking file.");
    }
  }

  _getFromCamera() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      if (imageList.length >= 5) {
        showToast('You can not select more than 5 images');
      } else {
        // imagePathList.add(pickedFile.path);
        setState(() {
          imageList.add(pickedFile);
          imagefiles.add([1, pickedFile]);
          isUploading = true;
        });
        showToast('Uploading Image');
        Map<String, File> payload = {"image": File(pickedFile.path)};
        String url = await uploadAndGetUrl(MJ_Apis.upload_post_image, payload);
        setState(() {
          isUploading = false;
        });
        imageUrlList.add([pickedFile.path, url]);
        imageUrls.add(url);
      }
    }
  }

  final picker = ImagePicker();

  _pickVideo() async {
    var uint8list;
    dynamic pickedFile;
    await picker.pickVideo(source: ImageSource.gallery).then((value) async {
      print('value: ${value!.path}');
      pickedFile = value;

      uint8list = await VideoThumbnail.thumbnailData(
        video: value.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 300,
        // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 100,
      );
    });

    _videoList.add(pickedFile);

    // print(pickedFile!.path);

    // setState(() {
    // _video = pickedFile;
    // imagefiles.add(_video!);
    // });

    Uint8List? imageInUnit8List = uint8list;
    final tempDir = await getTemporaryDirectory();
    print('tempDir: ${tempDir.path}'); //printing temporary directory
    File file = await File('${tempDir.path}/image.jpg').create();
    file.writeAsBytesSync(imageInUnit8List!);

    thumbnailList.add(file.path);

    // File thumb = File.fromRawPath(uint8list!);
    setState(() {
      imageList = [];
      thumb = XFile(file.path);
      imagefiles = [];
      imagefiles.add([2, thumb]);
      isUploading = true;
    });
    showToast('Uploading Video');
    Map<String, File> payload = {"video": File(pickedFile!.path)};
    String url = await uploadAndGetUrl(MJ_Apis.upload_video, payload);
    setState(() {
      isUploading = false;
    });
    videoUrlMap = {'path': pickedFile!.path, 'url': url};
  }

  Future<String> uploadAndGetUrl(url, Map<String, File> mapData) async {
    print('uploadandgeturl: $mapData');

    MjApiService apiService = MjApiService();
    String imgUrl = '';
    var response = await apiService.postMultiPartRequest(
      url,
      mapData,
    );
    if(response != null){
      print('in not null response: ${response}');
    print('responseURL: ${response!["url"]}');
    imgUrl = response["url"];
    return imgUrl;
    }
    else return '';
  }

  Future<void> deleteFile(url, Map<String, String> mapData) async {
    print(' in delete: $mapData');

    MjApiService apiService = MjApiService();
    var response = await apiService.postRequest(url, mapData);
    print('response: ${response}');
    showToast('Successfuly Deleted');
  }

  getPageData() async {
    user = (await getUser())!;
    setState(() {
      user = user;
    });
  }

  @override
  void initState() {
    getPageData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('videoUrlList: $videoUrlList');
    return Scaffold(
      appBar: AppBar(
        title: Text('Create post'),
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        foregroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
            'assets/images/arrow-left.png',
            color: Colors.black,
            scale: 10,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: isUploading ?  Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ColorCircularProgressIndicator(
                showMessage: false, height: 28, width: 28, stroke: 4,),
            )
                :  TextButton(
              onPressed: () async {
                if (isUploading) {
                  showToast('Please wait while files are uploading');
                  return;
                }
                if (descriptionController.text.isEmpty) {
                  showToast('Description can not be empty');
                  return;
                }

                // String combineUrls = '';
                // combineUrls = '[';
                // for (var url in imageUrls) {
                //   combineUrls += url + ',';
                // }
                // combineUrls += ']';

                MjApiService apiService = MjApiService();
                // print('imageList: $imageList');
                // print('videoList: $_videoList');
                // print('listofstring ${combineUrls}');
                dynamic payload = {
                  if (imageUrls.length > 0) 'image': jsonEncode(imageUrls),
                  if (videoUrlMap.length > 0) 'video[]': videoUrlMap['url'],
                  'description': descriptionController.text,
                };
                print('payload: ${payload}');

                User? user = await getUser();
                showProgressDialog(context, MJConfig.please_wait);
                print('userID: ${user!.id}');
                dynamic response = await apiService.postRequest(
                    MJ_Apis.create_post + "/" + user.id!, payload);
                hideProgressDialog(context);

                if (response != null) {
                  // print('response: ${response}');
                  // PostData postData =
                  //     PostData.fromJson(response['response']);
                  // print('postData: ${postData.toJson()}');


                  showToast("Successfuly posted");
                  Navigator.pop(context);

                }


              },
              child: Text(
                'Post',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // if (isUploading)
            //   TweenAnimationBuilder<Color>(
            //     tween: Tween<Color>(
            //         begin: Theme.of(context).primaryColor,
            //         end: Theme.of(context).accentColor),
            //     duration: const Duration(milliseconds: 0),
            //     builder: (context, value, _) => LinearProgressIndicator(
            //       minHeight: 2,
            //       // value: value,
            //       backgroundColor: Theme.of(context).primaryColor,
            //       valueColor: AlwaysStoppedAnimation<Color>(value),
            //     ),
            //   ),
            SizedBox(
              height: 14,
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CacheImage(
                            url: '${MJ_Apis.APP_BASE_URL}${user.profileImage}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: Text(
                      '${user.firstname} ${user.lastname}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )),
              ],
            ),
            SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                controller: descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  // filled: true,
                  // fillColor: Colors.grey,
                  hintText: 'What\'s on your mind?',
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintStyle: TextStyle(fontSize: 24, letterSpacing: 0.00001),
                  border: InputBorder.none,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () async {},

                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: imagefiles.map((imgList) {
                            return Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: FileImage(
                                    File(imgList[1]!.path),
                                  ),
                                  fit: BoxFit.fitWidth,
                                )),
                                height: 100,
                                width: 130,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Visibility(
                                      visible: imgList[0] != 2,
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              String urlToDelete = '';
                                              List list = imageUrlList
                                                  .firstWhere((element) =>
                                                      element[0] ==
                                                      imgList[1]!.path);
                                              urlToDelete = list[1];
                                              print('url: $urlToDelete');
                                              setState(() {
                                                isUploading = true;
                                                imageUrls.remove(urlToDelete);
                                                imagefiles.remove(imgList);
                                                imageList.removeWhere(
                                                    (element) =>
                                                        element == imgList[1]);
                                              });
                                              deleteFile(MJ_Apis.delete_file, {
                                                "path": urlToDelete
                                              }).then((value) {
                                                imageUrlList.remove(list);
                                                setState(() {
                                                  isUploading = false;
                                                });
                                              });
                                            },
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Colors.grey,
                                                child: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                )),
                                          )),
                                    ),
                                    Expanded(
                                      child: Visibility(
                                          visible: imgList[0] == 2,
                                          child: Container(
                                            color: Colors.black45,
                                            child: Column(
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        String urlToDelete =
                                                            videoUrlMap['url'];
                                                        print(
                                                            'url: $urlToDelete');
                                                        setState(() {
                                                          isUploading = true;
                                                          _videoList.removeWhere(
                                                              (element) =>
                                                                  element
                                                                      ?.path ==
                                                                  videoUrlMap[
                                                                      'path']);
                                                          videoUrlMap = {};
                                                          imagefiles
                                                              .remove(imgList);
                                                        });
                                                        deleteFile(
                                                            MJ_Apis.delete_file,
                                                            {
                                                              "path":
                                                                  urlToDelete
                                                            }).then((value) {
                                                          // videoUrlList.remove(list);
                                                          setState(() {
                                                            isUploading = false;
                                                          });
                                                        });
                                                      },
                                                      child: CircleAvatar(
                                                          radius: 15,
                                                          backgroundColor:
                                                              Colors.grey,
                                                          child: Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          )),
                                                    )),
                                                Spacer(),
                                                Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.white,
                                                  size: 70,
                                                ),
                                                Spacer(),
                                                SizedBox(
                                                  height: 20,
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        //     : Container(
                        //   child: imageFile != null  ? Image(
                        //     image: FileImage(File(imageFile!.path)),
                        //     // width: 120,
                        //     // height: 120,
                        //     fit: BoxFit.cover,
                        //   ) : null,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.attachment_rounded,
        ),
        onPressed: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              context: context,
              builder: (context) {
                TextStyle _sheetItemStyle =
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        onTap: () {
                          if (_videoList.length >= 1) {
                            print(_videoList);
                            showToast(
                                'You can not select an images with video');
                          } else {
                            openImages();
                          }

                          Navigator.of(context).pop();
                        },
                        leading: Image.asset(
                          'assets/icons/upload_icon.png',
                          scale: 3,
                        ),
                        title: Text(
                          'Upload image',
                          style: _sheetItemStyle,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          if (imageList.length >= 1) {
                            showToast('You can not select a video with images');
                          } else {
                            _pickVideo();
                          }
                          Navigator.of(context).pop();
                        },
                        leading: Image.asset(
                          'assets/icons/video_icon.png',
                          scale: 3,
                        ),
                        title: Text(
                          'Upload video',
                          style: _sheetItemStyle,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          if (_videoList.length >= 1) {
                            showToast('You can not upload images with video');
                          } else {
                            _getFromCamera();
                          }
                          Navigator.of(context).pop();
                        },
                        leading: Image.asset(
                          'assets/icons/camera_icon.png',
                          scale: 3,
                        ),
                        title: Text(
                          'Open Camera',
                          style: _sheetItemStyle,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
