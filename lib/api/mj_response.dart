import 'dart:convert';
import 'package:http/http.dart';

import '../helpers/constraints.dart';

class MJ_Response{
  MJ_Response(Response response) {
    code = response.statusCode;

    if (isSuccessful(jsonDecode(response.body))) {
      // print("12121");
      body = response.body;
      errorMessage = '';
    } else {
      body = null;
      try {
        final dynamic hashMap = json.decode(response.body);
        print(hashMap['message']);
        errorMessage = hashMap['message'];
      } catch (error) {
        print('Timeout Error');
        errorMessage = 'Timeout Error';
      }
    }
  }
  int? code;
  String? body;
  String? errorMessage;

  bool isSuccessful(hashMap) {
    // print(convertNumber(hashMap['status']!.toString()) > 0 && convertNumber(hashMap['status']!.toString()) < 10);
    // print(convertNumber(hashMap['status']!.toString()));
    return convertNumber(hashMap['status']!.toString()) > 0 && convertNumber(hashMap['status']!.toString()) < 10;
  }
}
