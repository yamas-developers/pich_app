import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:location/location.dart';
import 'package:location/location.dart' as mLocation;
import 'package:permission_handler/permission_handler.dart';

class CurrentLocationProvider extends ChangeNotifier {
  bool _error = false;
  String _message = '';
  bool _isLoading = false;
  LatLng? _currentLocation;
  List<Store> _nearestStores = [];
  bool _isListLoading = false;

  String get message => _message;

  List<Store> get nearestStores => _nearestStores;

  bool get isLoading => _isLoading;

  LatLng get currentLocation => _currentLocation!;

  bool get error => _error;

  set error(bool value) {
    _error = value;
  }

  set message(String value) {
    _message = value;
  }

  set nearestStores(value) {
    _nearestStores.clear();
    _nearestStores.addAll(value);
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set currentLocation(LatLng value) {
    _currentLocation = value;
    notifyListeners();
  }

  Store? getTopStore() {
    return nearestStores.length > 0 ? nearestStores.first : null;
  }

  getCurrentLocation() async {
    // return;
    message = "Getting Current Location";
    isLoading = true;
    mLocation.LocationData location = (await Constraints.getCurrentLocation())!;
    isLoading = false;
    print("================================");
    print(location);
    if (location != null) {
      currentLocation = LatLng(location.latitude!, location.longitude!);
      error = false;
      getCurrentLocationStores();
    } else {
      message = "Cannot get your location";
      error = true;
    }
    // -122.08402063697578 - 37.42295222869878
    // currentLocation = LatLng(37.42295222869878, -122.08402063697578);
    // getCurrentLocationStores();
  }

  onChangeLocation() async {
    // var location = mLocation.Location();
    // location.onLocationChanged.listen((event) {
    //   print(event);
    // });
  }

  getCurrentLocationStores() async {
    // return;
    User user = (await getUser())!;
    if (user == null) return;
    message = "Getting Stores!";
    isLoading = true; 
    var payload = {
      'lat': currentLocation.latitude.toString(),
      'lng': currentLocation.longitude.toString(),
    };
    var response = await MjApiService().postRequest(
        MJ_Apis.get_current_location_stores + "/${user.id}", payload);
    isLoading = false;
    if (response != null) {
      print(response);
      List<Store> list = [];
      for (int i = 0; i < response.length; i++) {
        list.add(Store.fromJson(response[i]));
      }
      nearestStores = list;
      error = false;
      if (nearestStores.length < 1) {
        error = true;
        message = 'No Store Found Nearby';
      }
    } else {
      error = true;
      message = "Cannot get stores";
    }
  }
}
