class Complaint {
  int? id;
  int? userId;
  String? title;
  String? description;
  String? status;
  String? createdAt;

  Complaint(
      {this.id,
        this.userId,
        this.title,
        this.description,
        this.status,
        this.createdAt});

  Complaint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    createdAt = json['created_at'];
  }


}
