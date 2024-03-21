import 'dart:convert';
import 'dart:io';
import 'package:farmer_app/Ui/registeration/login_screen.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../helpers/constraints.dart';
import '../helpers/encryption.dart';
import 'mj_apis.dart';
import 'package:get/get.dart' as XGet;

class MjApiService {
  getMultiPartHeaders() async {
    if (await isLogin()) {
      var token = (await getUser())!.token!;
      print('token: $token');
      String br = token;
      if(br == null) {
        showToast("Session Expired");
        XGet.Get.offAll(LoginScreen());
        return null;
      }
      return <String, String>{
        "Authorization": "Bearer "+br,
        "Accept": "json",
        "token": br,
      };
    } else {
      return <String, String>{
        "Accept": "json"
      };
    }
  }

  getHeaders() async {
    String br = '';
    User? user = await getUser();
    var token = user!.token;
    print('token: $token');
    if (await isLogin()) {
      String? br = token;
      if(br == null) {
        showToast("Session Expired");
        XGet.Get.offAll(LoginScreen());
        return null;
      }
      return <String, String>{
        "Authorization": "Bearer "+br,
        "Accept": "json",
        "token": br,
      };
    } else {
      return <String, String>{
        'Accept': 'json',
      };
    }
  }

  Future<dynamic?> simplePostRequest(String url, Map data) async {
    final Client client = http.Client();
    try {
      print('${MJ_Apis.BASE_URL}$url');
      final Response response = await client.post(
          Uri.parse('${MJ_Apis.BASE_URL}$url'),
          body: data,
          headers: {"Accept":"application/json"});
      print('${MJ_Apis.BASE_URL}$url');
      print('myResponse ' + response.body.toString());
      // final MJ_Response psApiResponse = MJ_Response(response);
      final hashMap = json.decode(response.body);
      // print('myHashmapStatus: ${hashMap['status']}');
      if (hashMap['status'] == 1) {
        String decData = await decryptString(hashMap['response']);
        // print(decData);
        hashMap['response'] = jsonDecode(decData);
        // print("here");
        return hashMap;
      }
      print("res==>" + hashMap.toString());
      showToast(hashMap['message']);
      return null;
    } catch (e) {
      print("error no request => " + e.toString());
      showToast("Unfortunate error");
      return null;
    } finally {
      client.close();
    }
  }

  Future<dynamic?> postRequest(String url, Map data) async {
    final Client client = http.Client();
    try {
      final Response response = await client.post(
          Uri.parse('${MJ_Apis.BASE_URL}$url'),
          body: data,
          headers: await getHeaders());
      print(data);
      print('${MJ_Apis.BASE_URL}$url');
      debugPrint('myResponse ' + response.body.toString());
      // final MJ_Response psApiResponse = MJ_Response(response);
      final hashMap = jsonDecode(response.body);
      print('myHashmapStatus: ${hashMap['status']}');
      if (hashMap['status'] == 1) {
        String decData = await decryptString(hashMap['response']);
        print('data is in if: ${decData}');
        dynamic data = json.decode(decData);
        print(data);
        return data;
      }
      showToast(hashMap['message']);
      return null;
    } catch (e) {
      print(e.toString() + '=>$url');
      return null;
      // return MJResource<R>(MJStatus.ERROR, e.toString(), null); //e.message ??
    } finally {
      client.close();
    }
  }

  Future<dynamic?> postMultiPartRequest(
      url, Map<String, File> files,
      {Map<String, String>? data}) async {
    try {
      Uri uri = Uri.parse('${MJ_Apis.BASE_URL}$url');

      print('url: ${MJ_Apis.BASE_URL}$url');

      var request = MultipartRequest("POST", uri);

      for (int i = 0; i < files.length; i++) {
        request.files.add(await MultipartFile.fromPath(
            files.keys.elementAt(i), files[files.keys.elementAt(i)]!.path));
      }
      request.headers.addAll(await getMultiPartHeaders());
      if (data != null) request.fields.addAll(data);
      var response = await request.send();

      var res = await http.Response.fromStream(response);
      print(res.body.toString());
      final hashMap = json.decode(res.body);

      if (hashMap['status'] == 1) {
        String decData = await decryptString(hashMap['response']);
        print("DecData: ${decData}");
        dynamic data = json.decode(decData);

        return data;
      }
      showToast(hashMap['message']);
      return null;
    } catch (exp) {
      print("MJ Error :" + exp.toString());
      showToast("Unfortunate Error");
      return null;
    }
  }

  Future<dynamic?> getRequest(String url) async {
    print('in getRequest');
    final Client client = http.Client();
    try {
      print('${MJ_Apis.BASE_URL}$url');
      final Response response = await client.get(
          Uri.parse('${MJ_Apis.BASE_URL}$url'),
          headers: await getHeaders());
      print(response.body.toString());
      final hashMap = json.decode(response.body);
      // print(hashMap);
      print('myHashmapStatus: ${hashMap['status']}');
      if (hashMap['status'] == 1) {
        String decData = await decryptString(hashMap['response']);
        print('data is in if: ${decData}');
        dynamic data = jsonDecode(decData);
        return data;
      }
      showToast(hashMap['message']);
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    } finally {
      client.close();
    }
  }

  Future<dynamic?> multipartPostRequest(String url, Map data) async {

    try{
      print('${MJ_Apis.BASE_URL}$url');
      Uri uri = Uri.parse('${MJ_Apis.BASE_URL}$url');
      var request = http.MultipartRequest("POST", uri);

      request.fields['description'] = data['description'];
      request.headers.addAll(await getMultiPartHeaders());

      List<String?> imgPaths = data['image'];
      List<String?> videoPaths = data['video'];

      if(imgPaths.length >= 1){
        for(var path in imgPaths){

          request.files.add(await MultipartFile.fromPath(
              'image[]', path!));

        }
      }
      if(videoPaths.length >= 1){
        for(var path in videoPaths){
          request.files.add(await MultipartFile.fromPath(
              'video[]', path!));

          // request.files.add(http.MultipartFile('image', stream, length));
        }
        //File.fromUri(Uri.parse(path))
      }




      http.Response response =
      await http.Response.fromStream(await request.send());

      print('${MJ_Apis.BASE_URL}$url');
      print('myResponse ' + response.body.toString());

      final hashMap = json.decode(response.body);
      print('myHashmapStatus: ${hashMap['status']}');
      if (hashMap['status'] == 1) {
        String decData = await decryptString(hashMap['response']);
        dynamic data = json.decode(decData);
        print('data is in if: ${data}');
        return data;
      }
      showToast(hashMap['message']);
      return null;
    }
    catch (e) {
      print(e.toString());
      return null;
    } finally {
    }


    // if (response.statusCode == 200)
    //   ImageUrl =
    //   jsonDecode(response.body)['response']['url'];
  }

}
