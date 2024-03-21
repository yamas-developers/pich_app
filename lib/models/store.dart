import 'package:farmer_app/helpers/constraints.dart';

class Store {
  int? id;
  String? storeName;
  String? storeIcon;
  String? address;
  String? lat;
  String? lng;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? userId;
  StoreUser? users;
  double? distance;

  Store(
      {
        this.id,
        this.storeName,
        this.storeIcon,
        this.address,
        this.lat,
        this.lng,
        this.image1,
        this.image2,
        this.image3,
        this.image4,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.users,
      this.distance
      });

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['store_name'];
    storeIcon = json['store_icon'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    image1 = json['image_1'];
    image2 = json['image_2'];
    image3 = json['image_3'];
    image4 = json['image_4'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    distance = convertDouble(json['distance'].toString());
    users = json['users'] != null ? new StoreUser.fromJson(json['users']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_name'] = this.storeName;
    data['store_icon'] = this.storeIcon;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['image_1'] = this.image1;
    data['image_2'] = this.image2;
    data['image_3'] = this.image3;
    data['image_4'] = this.image4;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['distance'] = this.distance;
    if (this.users != null) {
      data['users'] = this.users!.toJson();
    }
    return data;
  }
}

class StoreUser {
  int? id;
  String? firstname;
  String? lastname;
  String? email;
  String? phoneNumber;
  String? address;

  StoreUser(
      {this.id,
        this.firstname,
        this.lastname,
        this.email,
        this.phoneNumber,
        this.address});

  StoreUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['address'] = this.address;
    return data;
  }
}
