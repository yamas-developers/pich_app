class User {
  String? id = '';
  String? username = '';
  String? password = '';
  String? firstname = '';
  String? lastname = '';
  String? email = '';
  String? phoneNumber = '';
  String? profileImage = '';
  String? coverImage = '';
  String? age = '';
  String? token = '';
  String? address = '';
  String? lat = '';
  String? lng = '';
  String? googleId = '';
  String? facebookId = '';
  String? referalId = '';
  String? rolesId = '';
  String? status = '';
  String? isPhoneVerified = '';
  String? createdAt = '';
  String? updatedAt = '';
  String? clicks = '';
  String? followersCount; //nullable
  Roles? roles; //nullable
  int? followingCount;//nullable
  int? postsCount;//nullable

  User(
      {
        this.id,
        this.username,
        this.password,
        this.firstname,
        this.lastname,
        this.email,
        this.phoneNumber,
        this.profileImage,
        this.coverImage,
        this.age,
        this.token,
        this.address,
        this.lat,
        this.lng,
        this.googleId,
        this.facebookId,
        this.referalId,
        this.rolesId,
        this.status,
        this.isPhoneVerified,
        this.createdAt,
        this.updatedAt,
        this.clicks,
        this.followersCount,
        this.followingCount,
        this.postsCount,
        this.roles
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    username = json['username'];
    password = json['password'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    age = json['age'].toString();
    token = json['token'].toString();
    address = json['address'] ?? 'No Location';
    lat = json['lat'].toString();
    lng = json['lng'].toString();
    googleId = json['google_id'].toString();
    facebookId = json['facebook_id'].toString();
    referalId = json['referal_id'].toString();
    rolesId = json['roles_id'].toString();
    status = json['status'];
    isPhoneVerified = json['is_phone_verified'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    clicks = json['clicks'].toString();
    followingCount = json['following_count'];
    followersCount = json['followers_count'].toString();
    postsCount = json['posts_count'];
    roles = json['roles'] != null ? new Roles.fromJson(json['roles']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['profile_image'] = this.profileImage;
    data['cover_image'] = this.coverImage;
    data['age'] = this.age;
    data['token'] = this.token;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['google_id'] = this.googleId;
    data['facebook_id'] = this.facebookId;
    data['referal_id'] = this.referalId;
    data['roles_id'] = this.rolesId;
    data['status'] = this.status;
    data['is_phone_verified'] = this.isPhoneVerified;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['clicks'] = this.clicks;
    data['followers_count'] = this.followersCount;
    data['following_count'] = this.followingCount;
    data['posts_count'] = this.postsCount;
    if (this.roles != null) {
      data['roles'] = this.roles!.toJson();
    }
    return data;
  }
}

class Roles {
  int? id;
  String? name;
  String? role;

  Roles({this.id, this.name, this.role});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['role'] = this.role;
    return data;
  }
}

// class User {
//   String? userId;
//   String? createdAt;
//   String? updatedAt;
//   String? userName;
//   String? fullName;
//   String? rolesId;
//   String? email;
//   String? age;
//   String? address;
//   String? lat;
//   String? lng;
//   String? profileImage;
//   String? coverImage;
//   String? activationCode;
//   String? googleId;
//   String? facebookId;
//   String? referalId;
//   String? isPhoneVerified;
//   String? phone;
//   String? password;
//
//   User(
//       {this.userId,
//         this.createdAt,
//         this.updatedAt,
//         this.userName,
//         this.fullName,
//         this.rolesId,
//         this.email,
//         this.age,
//         this.address,
//         this.lat,
//         this.lng,
//         this.profileImage,
//         this.coverImage,
//         this.activationCode,
//         this.googleId,
//         this.facebookId,
//       this.referalId,
//       this.isPhoneVerified,
//         this.phone,
//         this.password,
//       });
//
//   User.fromJson(Map<String, dynamic> json) {
//     userId = json['id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     userName = json['user_name'];
//     fullName = json['full_name'];
//     rolesId = json['roles_id'];
//     email = json['email'];
//     age = json['age'];
//     address = json['address'];
//     profileImage = json['profile_image'];
//     coverImage = json['cover_image'];
//     phone = json['phone_number'];
//     lat = json['lat'];
//     lng = json['lng'];
//     googleId = json['google_id'];
//     facebookId = json['facebook_id'];
//     referalId = json['referal_id'];
//     isPhoneVerified = json['is_phone_verified'];
//     password = json['password'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.userId;
//     data['full_name'] = this.fullName;
//     data['user_name'] = this.userName;
//     data['email'] = this.email;
//     data['age'] = this.age;
//     data['address'] = this.address;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['roles_id'] = this.rolesId;
//     data['lat'] = this.lat;
//     data['lng'] = this.lng;
//     data['profile_image'] = this.profileImage;
//     data['cover_image'] = this.coverImage;
//     data['google_id'] = this.googleId;
//     data['facebook_id'] = this.facebookId;
//     data['referal_id'] = this.referalId;
//     data['activation_code'] = this.activationCode;
//     data['is_phone_verified'] = this.isPhoneVerified;
//     data['phone_number'] = this.phone;
//     data['password'] = this.password;
//     return data;
//   }
// }
