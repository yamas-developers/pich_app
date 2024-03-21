import 'dart:convert';

import 'package:farmer_app/Ui/app_components/app_back_button.dart';
import 'package:farmer_app/Ui/app_components/input_field.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/color_circular_progress_indicator.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/encryption.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/complaint_model.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CustomerSupportScreen extends StatefulWidget {
  static const String routeName = '/customer_support';

  const CustomerSupportScreen({Key? key}) : super(key: key);

  @override
  State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

User? user = User();
  @override
  void initState() {
    getPageData();
    super.initState();
  }

  getPageData() async {
    user = (await getUser())!;
    List<Complaint> list = await getAllComplaints();
    print('dataQuery: ${list}');
    setState(() {
      queries = list;
    });

  }

  bool submitLoading = false;
  List<Complaint> queries = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(color: Colors.white,scale: 3,),
        backgroundColor: kprimaryColor,
        elevation: 0,
        title: const Text('Customer Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16,0,16,16),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 20,),
                  const SizedBox(
                    height: 150,
                    child: Image(
                      image: AssetImage('assets/images/customer_support.png'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Contact us',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Contact us regarding your queries our team will respond to your queries!',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CircularInputField(
                    label: "Enter Title",
                    controller: _titleController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CircularInputField(
                    label: "Enter Description",
                    maxLines: 8,
                    minLines: 4,
                    controller: _descriptionController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: default_button(
                      text: "Submit",
                      press: () async {
                        var title = _titleController.text;
                        var description =
                        _descriptionController.text;
                        if (title.isEmpty) {
                          showToast('Please enter title');
                        } else if (description.isEmpty) {
                          showToast('Please enter description');
                        } else {
                          //submit request
                          setState(() {
                            submitLoading=true;
                          });
                          Map data = {
                            'title': title,
                            'description': description
                          };
                          _titleController.text = '';
                          _descriptionController.text = '';
                          showProgressDialog(context, 'Submitting your query');

                          dynamic response = await MjApiService().postRequest(MJ_Apis.support+"/${user!.id}", data);

                          hideProgressDialog(context);
                          getPageData();

                          setState(() {
                            submitLoading=false;
                          });

                          showToast(response['status']);
                          if (response != null) {

                            if (response['status'] == 1) {
                              ////complaint submitted
                              debugPrint(response['status'].toString());
                            } else {
                              //something went wrong
                            }
                          } else {
                            //complaint not submitted
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Previous Complaints',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
              ),
            ];
          },
          body:
            submitLoading ? Center(child: ColorCircularProgressIndicator(),) : (queries.length < 1) ?
                     Center(child: Text('No previous complaints found'),)
                  : ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: queries.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: 8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kGrey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Complaint No. ${queries[index].id}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: kprimaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                queries[index].title.toString(),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kYellowColor),
                              ),
                              Text(
                                queries[index].description.toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "${DateFormat('hh:mm a - MMM dd, yyyy').format(DateTime.parse(queries[index].createdAt!))}",
                                style: TextStyle(
                                  color: kYellowColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                            color: kYellowColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            queries[index].status.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              })
          // FutureBuilder(
          //   future: getAllComplaints(),
          //   builder: (context, snapshot) {
          //     List<Complaint> data = snapshot.data as List<Complaint>;
          //     print('in future builder: ${data.length}');
          //
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(
          //           child: CircularProgressIndicator(
          //             color: Colors.orange,
          //           ));
          //     } else {
          //       if (snapshot.hasData) {
          //         //debugPrint('here...${snapshot.data.toString()}');
          //         if(data.length < 1){
          //           return Center(child: Text('No previous complaints found'),);
          //         }
          //         return ListView.builder(
          //             scrollDirection: Axis.vertical,
          //             itemCount: data.length,
          //             itemBuilder: (context, index) {
          //               return Container(
          //                 padding: const EdgeInsets.all(12),
          //                 margin: const EdgeInsets.symmetric(
          //                     vertical: 4, horizontal: 8),
          //                 width: double.infinity,
          //                 decoration: BoxDecoration(
          //                   color: Colors.grey.shade300,
          //                   borderRadius: BorderRadius.circular(16),
          //                 ),
          //                 child: Row(
          //                   children: [
          //                     Expanded(
          //                         child: Column(
          //                           crossAxisAlignment: CrossAxisAlignment.start,
          //                           children: <Widget>[
          //                             Text(
          //                               'Complaint No. ${data[index].id}',
          //                               style: const TextStyle(
          //                                   fontSize: 12,
          //                                   color: Colors.green,
          //                                   fontWeight: FontWeight.w500),
          //                             ),
          //                             Text(
          //                               data[index].title.toString(),
          //                               style: const TextStyle(
          //                                   fontSize: 16,
          //                                   fontWeight: FontWeight.w600,
          //                                   color: Colors.orange),
          //                             ),
          //                             Text(
          //                               data[index].description.toString(),
          //                               style: const TextStyle(fontSize: 14),
          //                             ),
          //                           ],
          //                         )),
          //                     Container(
          //                       padding: const EdgeInsets.symmetric(
          //                           vertical: 4, horizontal: 8),
          //                       decoration: BoxDecoration(
          //                           color: Colors.orange,
          //                           borderRadius: BorderRadius.circular(8)),
          //                       child: Center(
          //                         child: Text(
          //                           data[index].status.toString(),
          //                           style: const TextStyle(
          //                               color: Colors.white,
          //                               fontSize: 12,
          //                               fontWeight: FontWeight.w300),
          //                         ),
          //                       ),
          //                     )
          //                   ],
          //                 ),
          //               );
          //             });
          //       } else if (snapshot.hasError) {
          //         //error occured
          //         return const Center(
          //           child: Text('Error Occurred!'),
          //         );
          //       } else {
          //         return const Center(
          //           child: Text('Something Went Wrong!'),
          //         );
          //       }
          //     }
          //   },
          // ),
        ),
      ),
    );
  }

  // Future submitComplaintApi(dynamic data) async {
  //   dynamic responseJson;
  //   String url = "https://pich.dodson-development.com/api/mjcoder/support/1";
  //   try {
  //     final http.Response response =
  //     await http.post(Uri.parse(url), body: data);
  //     if (response.statusCode == 200) {
  //       responseJson = jsonDecode(response.body);
  //       return responseJson;
  //     } else {
  //       return responseJson;
  //     }
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }

  Future<List<Complaint>> getAllComplaints() async {
    try {

      setState(() {
        submitLoading = true;
      });

        dynamic response = await MjApiService().getRequest(MJ_Apis.support_list+"/${user!.id}");

      setState(() {
        submitLoading = false;
      });
        if(response != null){
        var data = response
            .map((e) => Complaint.fromJson(e))
            .toList();



        // allComplaints.addAll([..._allComplaints]);
        debugPrint('debugPrint: ${data.toString()}' );
        return [...data];
        }
        else {
          return [];
        }
      }
     catch (e) {
      debugPrint(e.toString());
      throw Exception();
      return [];
    }
  }
}
