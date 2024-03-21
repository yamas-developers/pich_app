import 'package:farmer_app/models/dynamic_form.dart';
import 'package:farmer_app/models/store.dart' as store;
import 'package:farmer_app/models/store.dart';
import 'package:flutter/cupertino.dart';

class UserDynamicFormProvider extends ChangeNotifier {
  List<DynamicForm> _list = [];
  List<DynamicForm> get list => _list;
  dynamic formData;
  bool loading = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, TextEditingController> inputControllers = {};
  Map<String, String> dropdowns = {};
  Map<String, bool> checkBoxs = {};

  set isLoading(value){
    _isLoading = value;
    notifyListeners();
  }

  set(list) {
    _list.clear();
    _list.addAll(list);
    notifyListeners();
  }
  getCurrentStore(int? id){
    if (id == null) return;
    DynamicForm store = _list.firstWhere((element) => element.id == id);
    print('store: ${store}');
    return store;
    // if (index >= 0) {
    //   return true;
    // }
    //
    // return false;
  }
  bool addDropdownField({required formId, required fieldId,required Dropdown dropdown}){
    try{
      var formIndex = list.indexWhere((element) => formId == element.id);
      if(formIndex > -1) {
        var fieldIndex = list[formIndex].field!.indexWhere((
            element) => fieldId == element.id);
        if (fieldIndex > -1) {
          list[formIndex].field![fieldIndex].dropdown!.add(dropdown);
          notifyListeners();
          return true;
        }
      }
      return false;
    }catch(e){
      debugPrint(e.toString());
      return false;
    }

  }

}
