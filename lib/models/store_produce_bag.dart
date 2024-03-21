import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/store_product.dart';

class StoreProduceBag {
  int? id;
  String? produceBagTitle;
  int? price;
  int? storeId;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? qty;// ONLY when we use in cart
  String? cartType;// ONLY when we use in cart
  String? cartId;// ONLY when we use in cart
  List<ProduceBagProduct>? produceBagProduct;
  Store? store; // Can be null in some cases

  StoreProduceBag(
      {this.id,
        this.produceBagTitle,
        this.price,
        this.storeId,
        this.status,
        this.qty,
        this.cartType,
        this.cartId,
        this.createdAt,
        this.updatedAt,
        this.produceBagProduct});

  StoreProduceBag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    produceBagTitle = json['produce_bag_title'];
    price = json['price'];
    storeId = json['store_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    qty = json['qty'];
    cartType = json['cart_type'];
    cartId = json['cart_id'];
    store = json['store'] != null
        ? new Store.fromJson(json['store'])
        : null;
    if (json['produce_bag_product'] != null) {
      produceBagProduct = <ProduceBagProduct>[];
      json['produce_bag_product'].forEach((v) {
        produceBagProduct!.add(new ProduceBagProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['produce_bag_title'] = this.produceBagTitle;
    data['qty'] = this.qty;
    data['cart_type'] = this.cartType;
    data['cart_id'] = this.cartId;
    data['price'] = this.price;
    data['store_id'] = this.storeId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    if (this.produceBagProduct != null) {
      data['produce_bag_product'] =
          this.produceBagProduct!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProduceBagProduct {
  int? id;
  int? produceBagId;
  int? storeProductId;
  int? quantity;
  String? size;
  String? createdAt;
  StoreProduct? storeProduct;

  ProduceBagProduct(
      {this.id,
        this.produceBagId,
        this.storeProductId,
        this.quantity,
        this.size,
        this.createdAt,
        this.storeProduct});

  ProduceBagProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    produceBagId = json['produce_bag_id'];
    storeProductId = json['store_product_id'];
    quantity = json['quantity'];
    size = json['size'];
    createdAt = json['created_at'];
    storeProduct = json['store_product'] != null
        ? new StoreProduct.fromJson(json['store_product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['produce_bag_id'] = this.produceBagId;
    data['store_product_id'] = this.storeProductId;
    data['quantity'] = this.quantity;
    data['size'] = this.size;
    data['created_at'] = this.createdAt;
    if (this.storeProduct != null) {
      data['store_product'] = this.storeProduct!.toJson();
    }
    return data;
  }
}
