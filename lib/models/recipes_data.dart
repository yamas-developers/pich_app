class RecipesData {
  int? id;
  String? title;
  String? description;
  String? recipesImage;
  int? productId;
  String? status;
  String? createdAt;
  String? updatedAt;

  RecipesData(
      {this.id,
        this.title,
        this.description,
        this.recipesImage,
        this.productId,
        this.status,
        this.createdAt,
        this.updatedAt});

  RecipesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    recipesImage = json['recipes_image'];
    productId = json['product_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['recipes_image'] = this.recipesImage;
    data['product_id'] = this.productId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
