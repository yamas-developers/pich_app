// class User {
//   int? id;
//   String? username;
//   String? firstname;
//   String? lastname;
//   String? email;
//   String? phoneNumber;
//   String? profileImage;
//   String? coverImage;
//   String? age;
//   String? address;
//   String? lat;
//   String? lng;
//   String? googleId;
//   String? facebookId;
//   String? referalId;
//   int? rolesId;
//   String? status;
//   String? isPhoneVerified;
//   String? createdAt;
//   String? updatedAt;
//   int? clicks;
//   int? followersCount;
//   int? followingCount;
//   int? postsCount;
//
//   User(
//       {this.id,
//         this.username,
//         this.firstname,
//         this.lastname,
//         this.email,
//         this.phoneNumber,
//         this.profileImage,
//         this.coverImage,
//         this.age,
//         this.address,
//         this.lat,
//         this.lng,
//         this.googleId,
//         this.facebookId,
//         this.referalId,
//         this.rolesId,
//         this.status,
//         this.isPhoneVerified,
//         this.createdAt,
//         this.updatedAt,
//         this.clicks,
//         this.followersCount,
//         this.followingCount,
//         this.postsCount});
//
//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     username = json['username'];
//     firstname = json['firstname'];
//     lastname = json['lastname'];
//     email = json['email'];
//     phoneNumber = json['phone_number'];
//     profileImage = json['profile_image'];
//     coverImage = json['cover_image'];
//     age = json['age'].toString();
//     address = json['address'];
//     lat = json['lat'];
//     lng = json['lng'];
//     googleId = json['google_id'];
//     facebookId = json['facebook_id'];
//     referalId = json['referal_id'];
//     rolesId = json['roles_id'];
//     status = json['status'];
//     isPhoneVerified = json['is_phone_verified'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     clicks = json['clicks'];
//     followersCount = json['followers_count'];
//     followingCount = json['following_count'];
//     postsCount = json['posts_count'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['username'] = this.username;
//     data['firstname'] = this.firstname;
//     data['lastname'] = this.lastname;
//     data['email'] = this.email;
//     data['phone_number'] = this.phoneNumber;
//     data['profile_image'] = this.profileImage;
//     data['cover_image'] = this.coverImage;
//     data['age'] = this.age;
//     data['address'] = this.address;
//     data['lat'] = this.lat;
//     data['lng'] = this.lng;
//     data['google_id'] = this.googleId;
//     data['facebook_id'] = this.facebookId;
//     data['referal_id'] = this.referalId;
//     data['roles_id'] = this.rolesId;
//     data['status'] = this.status;
//     data['is_phone_verified'] = this.isPhoneVerified;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['clicks'] = this.clicks;
//     data['followers_count'] = this.followersCount;
//     data['following_count'] = this.followingCount;
//     data['posts_count'] = this.postsCount;
//     return data;
//   }
// }
