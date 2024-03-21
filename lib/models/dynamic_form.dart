class DynamicForm {
  int? id;
  String? formName;
  String? status;
  List<Field>? field;
  UserForm? userForm;

  DynamicForm({this.id, this.formName, this.status, this.field, this.userForm});

  DynamicForm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formName = json['form_name'];
    status = json['status'];
    if (json['field'] != null) {
      field = <Field>[];
      json['field'].forEach((v) {
        field!.add(new Field.fromJson(v));
      });
    }
    userForm = json['user_form'] != null
        ? new UserForm.fromJson(json['user_form'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['form_name'] = this.formName;
    data['status'] = this.status;
    if (this.field != null) {
      data['field'] = this.field!.map((v) => v.toJson()).toList();
    }
    if (this.userForm != null) {
      data['user_form'] = this.userForm!.toJson();
    }
    return data;
  }
}
class Field {
  int? id;
  String? itemId;
  String? name;
  String? type;
  String? inputType;
  int? isRequired;
  int? formId;
  String? status;
  List<Dropdown>? dropdown;

  Field(
      {this.id,
        this.itemId,
        this.name,
        this.type,
        this.inputType,
        this.isRequired,
        this.formId,
        this.status,
        this.dropdown});

  Field.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    name = json['name'];
    type = json['type'];
    inputType = json['input_type'];
    isRequired = json['is_required'];
    formId = json['form_id'];
    status = json['status'];
    if (json['dropdown'] != null) {
      dropdown = <Dropdown>[];
      json['dropdown'].forEach((v) {
        dropdown!.add(new Dropdown.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['input_type'] = this.inputType;
    data['is_required'] = this.isRequired;
    data['form_id'] = this.formId;
    data['status'] = this.status;
    if (this.dropdown != null) {
      data['dropdown'] = this.dropdown!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dropdown {
  int? id;
  String? name;
  int? fieldId;
  String? status;

  Dropdown({this.id, this.name, this.fieldId, this.status});

  Dropdown.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fieldId = json['field_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['field_id'] = this.fieldId;
    data['status'] = this.status;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return name!;
  }
}

class UserForm {
  int? id;
  int? userId;
  int? formId;
  String? data;
  String? createdAt;

  UserForm({this.id, this.userId, this.formId, this.data, this.createdAt});

  UserForm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    formId = json['form_id'];
    data = json['data'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['form_id'] = this.formId;
    data['data'] = this.data;
    data['created_at'] = this.createdAt;
    return data;
  }
}