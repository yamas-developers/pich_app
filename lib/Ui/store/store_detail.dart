
// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:farmer_app/Ui/app_components/app_back_button.dart';
import 'package:farmer_app/Ui/store/store_form.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:farmer_app/Ui/app_components/input_field.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

class StoreDetail extends StatefulWidget {
  static const String routeName = "/store_detail";

  const StoreDetail({Key? key}) : super(key: key);

  @override
  State<StoreDetail> createState() => _StoreDetailState();
}

class _StoreDetailState extends State<StoreDetail> {
  TextEditingController latCtrl = TextEditingController();
  TextEditingController lngCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = {};

  static final CameraPosition _pakistanLoc = CameraPosition(
    target: LatLng(30.37532114456455, 69.34511605650187),
    zoom: 16,
  );

  LatLng currentLatLng = _kGooglePlex.target;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  // String lttext ='';
  // String lontext ="";
  goToLocation(LatLng latLng) async {
    GoogleMapController controller = await _controller.future;
    setState(() {
      currentLatLng = latLng;
    });
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 16)));
  }

  getPageData() async {
    LocationData locationData = (await Constraints.getCurrentLocation())!;
    if (locationData != null) {
      goToLocation(LatLng(locationData.latitude!, locationData.longitude!));
    }
  }

  @override
  void initState() {
    getPageData();
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    super.initState();
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
              height: 107,
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
                        AppBackButton(
                          width: 30,
                          color: Colors.white,
                        ),
                        // Image.asset(
                        //   "assets/icons/vendor.png",
                        //   height: 55,
                        // ),
                        SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(context, StoreForm.routeName);
                              },
                              child: Text(
                                "Location",
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "Select store location",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: Stack(alignment: Alignment.center, children: [
                      GoogleMap(
                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(
                              () => PanGestureRecognizer())),
                        zoomControlsEnabled: true,
                        mapType: MapType.normal,
                        zoomGesturesEnabled: true,
                        myLocationButtonEnabled: true,
                        markers: markers,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          if (latCtrl.text.length > 0) {
                            setState(() {
                              markers.add(
                                Marker(
                                  markerId: MarkerId('1'),
                                  position: LatLng(
                                    double.parse(latCtrl.text),
                                    double.parse(lngCtrl.text),
                                  ),
                                ),
                              );
                            });
                          }
                        },
                        onTap: (LatLng latLng) async {
                          print("tap");
                          // print(latLng);
                          // print(lttext);
                          // setState(() {
                          //   lttext = latLng.latitude.toString();
                          //   lontext = latLng.longitude.toString();
                          // });

                          // print(currentLatLng.longitude.toString());
                        },
                        initialCameraPosition: _kGooglePlex,
                        onCameraMove: (CameraPosition? position) async {
                          currentLatLng = position!.target;
                          print(
                              '${position.target.longitude} - ${position.target.latitude}');
                        },
                        onCameraIdle: () async {
                          print("idle");
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                  currentLatLng.latitude,
                                  currentLatLng.longitude);
                          if (placemarks.length > 0) {
                            Placemark place = placemarks[0];
                            print(place);
                            // nameCtrl.text = place.name.toString();
                            addressCtrl.text = place.name.toString() +
                                " " +
                                place.street.toString() +
                                " " +
                                place.country.toString();
                            setState(() {
                              latCtrl.text = currentLatLng.latitude.toString();
                              print(currentLatLng.longitude.toString());
                              lngCtrl.text = currentLatLng.longitude.toString();
                            });
                          }
                        },
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/home_produces_tree.png",
                            width: 60,
                            height: 60,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IgnorePointer(
                      ignoring: true,
                      child: Text("${addressCtrl.text}")
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IgnorePointer(
                      ignoring: true,
                      child: CircularInputField(
                        label: "Latitude",
                        type: TextInputType.text,
                        controller: latCtrl,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IgnorePointer(
                      ignoring: true,
                      child: CircularInputField(
                        label: "Longitude",
                        type: TextInputType.text,
                        controller: lngCtrl,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: GestureDetector(
                  onTap: () async {
                    Map args = {
                      'lat': latCtrl.text,
                      'lng': lngCtrl.text,
                      'address': addressCtrl.text
                    };
                    Navigator.pop(context, args);
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kYellowColor,
                      borderRadius: BorderRadius.circular(19),
                    ),
                    child: Center(
                      child: Text(
                        "Add Location",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
