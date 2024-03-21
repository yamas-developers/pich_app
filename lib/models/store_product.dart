import 'package:farmer_app/models/product.dart';
import 'package:farmer_app/models/store.dart';

class StoreProduct {
  int? id;
  int? productId;
  int? storeId;
  int? price;
  String? size;
  String? status;
  String? createdAt;
  Product? products;
  String? qty;// ONLY when we use in cart
  String? cartType;// ONLY when we use in cart
  String? cartId;// ONLY when we use in cart
  Store? store; //it can be null in many cases

  StoreProduct(
      {this.id,
        this.productId,
        this.storeId,
        this.price,
        this.size,
        this.status,
        this.createdAt,
        this.store,
        this.qty,
        this.cartType,
        this.cartId,
        this.products});

  StoreProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    storeId = json['store_id'];
    price = json['price'];
    size = json['size'];
    status = json['status'];
    createdAt = json['created_at'];
    qty = json['qty'];
    cartType = json['cart_type'];
    cartId = json['cart_id'];
    products = json['products'] != null
        ? new Product.fromJson(json['products'])
        : null;
    store = json['store'] != null
        ? new Store.fromJson(json['store'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['store_id'] = this.storeId;
    data['price'] = this.price;
    data['qty'] =this.qty;
    data['cart_type'] = this.cartType;
    data['cart_id'] = this.cartId;
    data['size'] = this.size;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return this.products!.productName!;
  }
}
