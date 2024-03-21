class PostComment {
  int? id;
  int? postId;
  int? userId;
  String? comment;
  String? status;
  String? createdAt;
  String? updatedAt;
  User? user;

  PostComment(
      {this.id,
        this.postId,
        this.userId,
        this.comment,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.user});

  PostComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    userId = json['user_id'];
    comment = json['comment'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? firstname;
  String? lastname;
  String? email;
  String? phoneNumber;
  String? profileImage;
  String? coverImage;
  String? age;
  String? address;
  String? lat;
  String? lng;
  String? googleId;
  String? facebookId;
  String? referalId;
  int? rolesId;
  String? status;
  String? isPhoneVerified;
  String? createdAt;
  String? updatedAt;
  int? clicks;

  User(
      {this.id,
        this.username,
        this.firstname,
        this.lastname,
        this.email,
        this.phoneNumber,
        this.profileImage,
        this.coverImage,
        this.age,
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
        this.clicks});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    age = json['age'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
    googleId = json['google_id'];
    facebookId = json['facebook_id'];
    referalId = json['referal_id'];
    rolesId = json['roles_id'];
    status = json['status'];
    isPhoneVerified = json['is_phone_verified'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    clicks = json['clicks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['phone_number'] = this.phoneNumber;
    data['profile_image'] = this.profileImage;
    data['cover_image'] = this.coverImage;
    data['age'] = this.age;
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
    return data;
  }
}
