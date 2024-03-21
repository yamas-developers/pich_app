import 'dart:convert';

import 'package:farmer_app/Ui/app_components/app_back_button.dart';
import 'package:farmer_app/Ui/app_components/app_color_button.dart';
import 'package:farmer_app/Ui/app_components/input_field.dart';
import 'package:farmer_app/Ui/home_screen.dart';
import 'package:farmer_app/Ui/registeration/login_screen.dart';
import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/cart/cart_helper.dart';
import 'package:farmer_app/helpers/color_constants.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/public_methods.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/dynamic_form.dart';
import 'package:farmer_app/models/user.dart';
import 'package:farmer_app/providers/mj_providers.dart';
import 'package:farmer_app/providers/user/user_dynamic_form_provider.dart';
import 'package:farmer_app/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class UserDynamicForms extends StatefulWidget {
  static const String routeName = "/user_form";

  const UserDynamicForms({Key? key}) : super(key: key);

  @override
  State<UserDynamicForms> createState() => _UserDynamicFormsState();
}

class _UserDynamicFormsState extends State<UserDynamicForms> {
  User user = User();
  PageController pageController = PageController();
  Map<String, dynamic> inputControllers = {};
  Map<String, dynamic> dropdowns = {};
  Map<String, dynamic> checkBoxs = {};
  Map<String, dynamic> otherInputs = {};
  int pageChanged = 0;
  bool isLoading = false;
  int formId = 0;

  getPageData() async {
    user = (await getUser())!;
    context.read<UserProvider>().currentUser = user;
    setState(() {
      user = user;
    });
    getFormData();
  }

  getFormData() async {
    context.read<UserDynamicFormProvider>().isLoading = true;
    var response =
        await MjApiService().getRequest(MJ_Apis.get_forms + "/${user.id}");
    context.read<UserDynamicFormProvider>().isLoading = false;
    if (response != null) {
      List<DynamicForm> list = [];
      print(response);
      for (int i = 0; i < response.length; i++) {
        if (response[i]['field'] == null) {
          continue;
        }
        if (response[i]['field'].length < 1) {
          continue;
        }
        if (DynamicForm.fromJson(response[i]).userForm == null) {
          list.add(DynamicForm.fromJson(response[i]));
        }
      }
      context.read<UserDynamicFormProvider>().set(list);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageData();
  }

  addFormData(formId) async {
    var formData = context
        .read<UserDynamicFormProvider>()
        .list
        .where((element) => element.id == formId)
        .first;
    Map<String, dynamic> mapData = {};
    bool errors = false;
    for (int i = 0; i < formData.field!.length; i++) {
      Field formField = formData.field![i];
      if (formField.type == "Check") {
        mapData["${formField.itemId}"] = {
          'val': checkBoxs["${formField.itemId}"]['val'],
          'id': checkBoxs["${formField.itemId}"]['id'],
          'name': formField.name,
        };
      } else if (formField.type == "Dropdown") {
        mapData["${formField.itemId}"] = {
          'val': dropdowns["${formField.itemId}"]['val'],
          'id': dropdowns["${formField.itemId}"]['id'],
          'name': formField.name,
        };
        if (dropdowns["${formField.itemId}"]['val'] == null &&
            dropdowns["${formField.itemId}"]['is_required'].toString() == "1") {
          dropdowns["${formField.itemId}"]['error'] =
              '${formField.name} Cannot be empty';
          errors = true;
        }
      } else if (formField.type == "Input") {
        mapData["${formField.itemId}"] = {
          'val': inputControllers["${formField.itemId}"]['val'].text,
          'id': inputControllers["${formField.itemId}"]['id'],
          'name': formField.name,
        }; //checkBoxs["${formField.itemId}"];
        if (inputControllers["${formField.itemId}"]['val'].text.isEmpty &&
            inputControllers["${formField.itemId}"]['is_required'].toString() ==
                '1') {
          inputControllers["${formField.itemId}"]['error'] =
              '${formField.name} Cannot be empty';
          errors = true;
        }
      } else if (formField.type != "Heading") {
        print(formField.type);
        mapData["${formField.itemId}"] = {
          'val': otherInputs["${formField.itemId}"]['val'],
          'id': otherInputs["${formField.itemId}"]['id'],
          'name': formField.name,
        }; //checkBoxs["${formField.itemId}"];
        if (otherInputs["${formField.itemId}"]['val'] == null &&
            otherInputs["${formField.itemId}"]['is_required'].toString() ==
                '1') {
          otherInputs["${formField.itemId}"]['error'] =
              '${formField.name} Cannot be empty';
          errors = true;
        }
      }
    }
    if (errors) {
      setState(() {
        inputControllers = inputControllers;
        dropdowns = dropdowns;
      });
      return;
    }

    var payload = {"data": jsonEncode(mapData).toString()};
    // print(payload);
    setState(() {
      isLoading = true;
    });
    var response = await MjApiService()
        .postRequest(MJ_Apis.add_user_form + "/${user.id}/${formId}", payload);
    setState(() {
      isLoading = false;
    });
    if (response != null) {
      List<DynamicForm> list = [];
      for (int i = 0; i < response.length; i++) {
        if (response[i]['field'] == null) {
          continue;
        }
        if (response[i]['field'].length < 1) {
          continue;
        }
        if (DynamicForm.fromJson(response[i]).userForm == null) {
          list.add(DynamicForm.fromJson(response[i]));
        }
      }
      context.read<UserDynamicFormProvider>().set(list);
      if (list.length < 1) {
        var routeData = ModalRoute.of(context)!.settings.arguments;
        var data = routeData as Map;
        if (data["from"] == 'home') {
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        } else {
          Navigator.pop(context);
        }
      } else {
        setState(() {
          pageController.animateToPage(0,
              duration: Duration(milliseconds: 800), curve: Curves.easeInOut);
        });
      }
    } else {
      showAlertDialog(context, "Error",
          "Cannot submit request please try again later and check your internet connection",
          type: AlertType.ERROR);
    }
  }

  onPageChange() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // : SizedBox(
        //     height: 10,
        //     child: AppBackButton(width: 10,color: Colors.white,)),
        title: Text("Forms"),
        actions: [
          TextButton(
            child: Text('Logout', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              if (await logout()) {
                context.read<CartHelper>().clearCart();
                clearVendorData(context);
                showToast("You are now logged out");
                Navigator.pushReplacementNamed(context, LoginScreen.routeName);
              } else {
                showToast("Cannot logout right now");
              }
            },
          )
        ],
      ),
      body: Consumer<UserDynamicFormProvider>(builder: (key, provider, widget) {
        return provider.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : provider.list.length < 1
                ? Center(
                    child: Text("No form for you right now"),
                  )
                : PageView(
                    onPageChanged: (index) {
                      setState(() {
                        pageChanged = index;
                      });
                      print(pageChanged);
                    },
                    scrollDirection: Axis.horizontal,
                    controller: pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: provider.list.map((e) {
                      if (e.field != null) {
                        for (int i = 0; i < e.field!.length; i++) {
                          if (e.field![i].type == 'Dropdown') {
                            if (dropdowns['${e.field![i].itemId}'] == null) {
                              // dropdowns['${e.field![i].itemId}'] = '';
                              dropdowns['${e.field![i].itemId}'] = {
                                'val': null,
                                'id': e.id,
                                "data": e.field![i].name,
                                'is_required': e.field![i].isRequired,
                                'error': '',
                              };
                            }
                          } else if (e.field![i].type == 'Check') {
                            if (checkBoxs['${e.field![i].itemId}'] == null) {
                              // checkBoxs['${e.field![i].itemId}'] = '';
                              checkBoxs['${e.field![i].itemId}'] = {
                                'val': false,
                                'id': e.id,
                                "data": e.field![i].name,
                                'is_required': e.field![i].isRequired,
                                'error': '',
                              };
                            }
                          } else if (e.field![i].type == 'Input') {
                            if (inputControllers['${e.field![i].itemId}'] ==
                                null) {
                              inputControllers['${e.field![i].itemId}'] = {
                                'val': TextEditingController(),
                                'id': e.id,
                                "data": e.field![i].name,
                                'is_required': e.field![i].isRequired,
                                'error': '',
                              };
                            }
                          } else if (e.field![i].type != 'Heading') {
                            if (otherInputs['${e.field![i].itemId}'] == null) {
                              otherInputs['${e.field![i].itemId}'] = {
                                'val': null,
                                'id': e.id,
                                "data": e.field![i].name,
                                'is_required': e.field![i].isRequired,
                                'error': '',
                              };
                            }
                          }
                        }
                      }
                      print(dropdowns);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 4, 4, 22),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
                                child: Text(
                                  "${e.formName}",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("ID Number"),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Container(
                                            padding: EdgeInsets.all(10),
                                            width: getWidth(context),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                border: Border.all(
                                                    color: kprimaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text("${user.id}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ],
                                    ),
                                  ),
                                  ...e.field!.map((et) {
                                    // for(int i = 0 ; i < drop )
                                    if (et.type == 'MultiDropdown') {
                                      return Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 10, 10, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("${et.name}"),
                                            MultiSelectDialogField(
                                              items: et.dropdown!
                                                  .map((e) => MultiSelectItem(
                                                      e, "${e.name}"))
                                                  .toList(),
                                              listType:
                                                  MultiSelectListType.CHIP,
                                              title: Text(
                                                "Select options",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                              chipDisplay:
                                                  MultiSelectChipDisplay(
                                                chipColor: kprimaryColor,
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              // selectedColor: ,
                                              buttonText: Text(
                                                "Select options",
                                                maxLines: 1,
                                                // softWrap: true,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              searchable: true,
                                              onConfirm: (values) {
                                                // print(values);
                                                String val = '';
                                                for (int i = 0;
                                                    i < values.length;
                                                    i++) {
                                                  val += values[i].toString();
                                                  if (i != values.length - 1)
                                                    val += ', ';
                                                }
                                                setState(() {
                                                  otherInputs[et.itemId!]
                                                      ['val'] = val;
                                                  formId = e.id!;
                                                  otherInputs[et.itemId!]
                                                      ['error'] = '';
                                                });
                                                print(val);
                                                // _selectedAnimals = values;
                                              },
                                            ),
                                            if (otherInputs[et.itemId!]
                                                    ['error'] !=
                                                null)
                                              if (otherInputs[et.itemId!]
                                                          ['error']
                                                      .length >
                                                  0)
                                                Text(
                                                  otherInputs[et.itemId!]
                                                      ['error'],
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.red),
                                                ),
                                          ],
                                        ),
                                      );
                                    } else if (et.type == 'Dropdown')
                                      return Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 10, 10, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("${et.name}"),
                                                DropdownButton(
                                                  isExpanded: true,
                                                  // underline: DropdownButtonHideUnderline(
                                                  //     child: Container()),
                                                  value: dropdowns[et.itemId]
                                                      ['val'],
                                                  hint: Text(
                                                    "Select options",
                                                  ),
                                                  iconSize: 30.0,
                                                  items: et.dropdown!.map(
                                                    (val) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: val.name,
                                                        child: Text(
                                                          "${val.name}",
                                                          style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade700),
                                                        ),
                                                        // alignment: AlignmentDirectional.center,
                                                      );
                                                    },
                                                  ).toList(),
                                                  onChanged: (val) {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            FocusNode());
                                                    if (val.toString().trim() ==
                                                            "other" ||
                                                        val.toString().trim() ==
                                                            "Other") {
                                                      showOtherDialog(
                                                          context: context,
                                                          key: et.itemId!,
                                                          question: et.name
                                                              .toString(),
                                                          onClick:
                                                              (data) async {
                                                            Dropdown d =
                                                                new Dropdown();
                                                            d.name = data;
                                                            d.status = 'Active';
                                                            // et.dropdown!.add(d);
                                                            bool isAdded = provider
                                                                .addDropdownField(
                                                                    formId:
                                                                        e.id,
                                                                    fieldId:
                                                                        et.id,
                                                                    dropdown:
                                                                        d);
                                                            // debugPrint(isAdded.toString());
                                                            setState(() {});
                                                            await Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        500));
                                                            if (isAdded) {
                                                              setState(() {
                                                                dropdowns[et
                                                                        .itemId!]
                                                                    [
                                                                    'val'] = data;
                                                                formId = e.id!;
                                                                dropdowns[et
                                                                        .itemId!]
                                                                    [
                                                                    'error'] = '';
                                                              });
                                                            }
                                                          });
                                                      return;
                                                    }
                                                    setState(
                                                      () {
                                                        dropdowns[et.itemId!]
                                                                ['val'] =
                                                            val.toString();
                                                        formId = e.id!;
                                                        dropdowns[et.itemId!]
                                                            ['error'] = '';
                                                      },
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                            if (dropdowns[et.itemId!]
                                                    ['error'] !=
                                                null)
                                              if (dropdowns[et.itemId!]['error']
                                                      .length >
                                                  0)
                                                Text(
                                                  dropdowns[et.itemId!]
                                                      ['error'],
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.red),
                                                ),
                                          ],
                                        ),
                                      );
                                    else if (et.type == 'Check')
                                      return SizedBox();
                                    else if (et.type == 'Heading')
                                      return Container(
                                        width: getWidth(context),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              '${et.name}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      );
                                    else
                                      return Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 10, 10, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("${et.name}"),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            CircularInputField(
                                              // label: "${et.name!}",
                                              controller:
                                                  inputControllers[et.itemId]
                                                      ['val'],
                                              type: et.inputType == 'Number'
                                                  ? TextInputType.number
                                                  : TextInputType.text,
                                              onChanged: (val) {
                                                formId = e.id!;
                                                setState(() {
                                                  inputControllers[et.itemId!]
                                                      ['error'] = '';
                                                });
                                              },
                                            ),
                                            if (inputControllers[et.itemId!]
                                                    ['error'] !=
                                                null)
                                              if (inputControllers[et.itemId!]
                                                          ['error']
                                                      .length >
                                                  0)
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    Text(
                                                      "*${inputControllers[et.itemId!]['error']}",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.red),
                                                    ),
                                                  ],
                                                ),
                                          ],
                                        ),
                                      );
                                  }).toList()
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kprimaryColor,
        onPressed: isLoading
            ? null
            : () {
                if (formId < 1 || formId == null) {
                  formId = context
                      .read<UserDynamicFormProvider>()
                      .list[pageChanged]
                      .id!;
                  showToast("please fill require fields");
                  print(formId);
                  return;
                }
                addFormData(formId);
              },
        child: isLoading
            ? SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ))
            : Icon(
                FontAwesomeIcons.check,
                color: Colors.white,
              ),
      ),
    );
  }

  showOtherDialog(
      {required BuildContext context,
      required String key,
      required String question,
      required final onClick}) {
    String data = '';
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  // height: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${question}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      CircularInputField(
                        label: "Answer",
                        onChanged: (String val) {
                          data = val;
                        },
                        minLines: 3,
                        maxLines: 3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            flex: 10,
                            child: AppColorButton(
                              onPressed: () {
                                // onClick(data);
                                Navigator.of(context).pop();
                              },
                              name: "Cancel",
                              color: Colors.red,
                            ),
                          ),
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                            flex: 10,
                            child: AppColorButton(
                              onPressed: () {
                                if (data.isEmpty) {
                                  showToast("Answer cannot be empty");
                                  return;
                                }
                                onClick(data);
                                Navigator.of(context).pop();
                              },
                              name: "Done",
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
