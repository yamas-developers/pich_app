class Product {
  String? id;
  String? productName;
  String? productDescription;
  String? hasSize;
  String? image;
  String? iconImage;
  String? status;
  String? addedBy;
  String? createdAt;
  String? updatedAt;

  Product(
      {
        this.id,
        this.productName,
        this.productDescription,
        this.hasSize,
        this.image,
        this.iconImage,
        this.status,
        this.addedBy,
        this.createdAt,
        this.updatedAt
      });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    productName = json['product_name'];
    productDescription = json['product_description'];
    hasSize = json['has_size'].toString();
    image = json['image'];
    iconImage = json['icon_image'];
    status = json['status'];
    addedBy = json['added_by'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['product_description'] = this.productDescription;
    data['has_size'] = this.hasSize;
    data['image'] = this.image;
    data['icon_image'] = this.iconImage;
    data['status'] = this.status;
    data['added_by'] = this.addedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return this.productName!;
  }
}
