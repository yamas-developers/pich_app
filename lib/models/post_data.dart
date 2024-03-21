import 'package:farmer_app/models/user.dart';

class PostData {
  int? id;
  int? userId;
  String? description;
  int? clicks;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? postLikesCount;
  int? postMyLikesCount;
  int? postCommentsCount;
  User? postUser;
  List<PostImages>? postImages;
  List<PostVideos>? postVideos;
  List<PostTags>? postTags;

  PostData(
      {this.id,
        this.userId,
        this.description,
        this.clicks,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.postLikesCount,
        this.postCommentsCount,
        this.postUser,
        this.postImages,
        this.postVideos,
        this.postMyLikesCount,
        this.postTags});

  PostData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    description = json['description'];
    clicks = json['clicks'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    postLikesCount = json['post_likes_count'];
    postMyLikesCount = json['post_my_likes_count'];
    postCommentsCount = json['post_comments_count'];
    postUser = json['post_user'] != null
        ? new User.fromJson(json['post_user'])
        : null;
    if (json['post_images'] != null) {
      postImages = <PostImages>[];
      json['post_images'].forEach((v) {
        postImages!.add(new PostImages.fromJson(v));
      });
    }
    if (json['post_videos'] != null) {
      postVideos = <PostVideos>[];
      json['post_videos'].forEach((v) {
        postVideos!.add(new PostVideos.fromJson(v));
      });
    }
    if (json['post_tags'] != null) {
      postTags = <PostTags>[];
      json['post_tags'].forEach((v) {
        postTags!.add(new PostTags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['description'] = this.description;
    data['clicks'] = this.clicks;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['post_likes_count'] = this.postLikesCount;
    data['post_my_likes_count'] = this.postMyLikesCount;
    data['post_comments_count'] = this.postCommentsCount;
    if (this.postUser != null) {
      data['post_user'] = this.postUser!.toJson();
    }
    if (this.postImages != null) {
      data['post_images'] = this.postImages!.map((v) => v.toJson()).toList();
    }
    if (this.postVideos != null) {
      data['post_videos'] = this.postVideos!.map((v) => v.toJson()).toList();
    }
    if (this.postTags != null) {
      data['post_tags'] = this.postTags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class PostUserOld {
//   int? id;
//   String? username;
//   String? firstname;
//   String? lastname;
//   String? email;
//   String? phoneNumber;
//   String? profileImage;
//   String? coverImage;
//   Null? age;
//   Null? address;
//   Null? lat;
//   Null? lng;
//   Null? googleId;
//   Null? facebookId;
//   Null? referalId;
//   int? rolesId;
//   String? status;
//   String? isPhoneVerified;
//   String? createdAt;
//   String? updatedAt;
//   int? clicks;
//
//   PostUser(
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
//         this.clicks});
//
//   PostUser.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     username = json['username'];
//     firstname = json['firstname'];
//     lastname = json['lastname'];
//     email = json['email'];
//     phoneNumber = json['phone_number'];
//     profileImage = json['profile_image'];
//     coverImage = json['cover_image'];
//     age = json['age'];
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
//     return data;
//   }
// }

class PostImages {
  int? id;
  int? postId;
  String? image;
  String? status;

  PostImages({this.id, this.postId, this.image, this.status});

  PostImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}

class PostVideos {
  int? id;
  int? postId;
  String? video;
  String? status;

  PostVideos({this.id, this.postId, this.video, this.status});

  PostVideos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    video = json['video'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['video'] = this.video;
    data['status'] = this.status;
    return data;
  }
}

class PostTags {
  int? id;
  String? tags;
  int? postId;

  PostTags({this.id, this.tags, this.postId});

  PostTags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tags = json['tags'];
    postId = json['post_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tags'] = this.tags;
    data['post_id'] = this.postId;
    return data;
  }
}
