import 'package:farmer_app/models/product.dart';
import 'package:farmer_app/models/store.dart';
import 'package:farmer_app/models/user.dart';

class OrderData {
  int? id;
  int? userId;
  int? storeId;
  int? total;
  String? orderStatus;
  String? createdAt;
  String? updatedAt;
  User? user;
  Store? store;
  List<OrderProduct>? orderProduct;
  List<OrderProduce>? orderProduce;
  List<OrderVoucher>? orderVoucher;
  String? paymentStatus;//nullable

  OrderData(
      {this.id,
      this.userId,
      this.storeId,
      this.total,
      this.orderStatus,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.store,
        this.paymentStatus,
      this.orderProduct,
      this.orderProduce,
      this.orderVoucher});

  OrderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    total = json['total'];
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentStatus = json['payment_status'];
    if (json['user'] != null) {
      user = User.fromJson(json['user']);
    }
    if (json['store'] != null) {
      store = Store.fromJson(json['store']);
    }
    if (json['order_product'] != null) {
      orderProduct = <OrderProduct>[];
      json['order_product'].forEach((v) {
        orderProduct!.add(new OrderProduct.fromJson(v));
      });
    }
    if (json['order_produce'] != null) {
      orderProduce = <OrderProduce>[];
      json['order_produce'].forEach((v) {
        orderProduce!.add(new OrderProduce.fromJson(v));
      });
    }
    if (json['order_voucher'] != null) {
      orderVoucher = <OrderVoucher>[];
      json['order_voucher'].forEach((v) {
        orderVoucher!.add(new OrderVoucher.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['total'] = this.total;
    data['order_status'] = this.orderStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['payment_status'] = this.paymentStatus;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    if (this.orderProduct != null) {
      data['order_product'] =
          this.orderProduct!.map((v) => v.toJson()).toList();
    }
    if (this.orderProduce != null) {
      data['order_produce'] =
          this.orderProduce!.map((v) => v.toJson()).toList();
    }
    if (this.orderVoucher != null) {
      data['order_voucher'] =
          this.orderVoucher!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class User {
//   int? id;
//   String? username;
//   String? firstname;
//   String? lastname;
//   String? email;
//   String? phoneNumber;
//   Null? profileImage;
//   Null? coverImage;
//   Null? age;
//   Null? address;
//   Null? lat;
//   Null? lng;
//   Null? googleId;
//   Null? facebookId;
//   Null? referalId;
//   int? rolesId;
//   String? fcmToken;
//   String? status;
//   String? isPhoneVerified;
//   String? createdAt;
//   String? updatedAt;
//   int? clicks;
//
//   User(
//       {
//         this.id,
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
//         this.fcmToken,
//         this.status,
//         this.isPhoneVerified,
//         this.createdAt,
//         this.updatedAt,
//         this.clicks});
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
//     age = json['age'];
//     address = json['address'];
//     lat = json['lat'];
//     lng = json['lng'];
//     googleId = json['google_id'];
//     facebookId = json['facebook_id'];
//     referalId = json['referal_id'];
//     rolesId = json['roles_id'];
//     fcmToken = json['fcm_token'];
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
//     data['fcm_token'] = this.fcmToken;
//     data['status'] = this.status;
//     data['is_phone_verified'] = this.isPhoneVerified;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['clicks'] = this.clicks;
//     return data;
//   }
// }

// class Store {
//   int? id;
//   String? storeName;
//   String? storeIcon;
//   String? address;
//   String? lat;
//   String? lng;
//   String? image1;
//   String? image2;
//   String? image3;
//   String? image4;
//   String? status;
//   int? isDeleted;
//   String? createdAt;
//   String? updatedAt;
//   int? userId;
//
//   Store(
//       {
//         this.id,
//         this.storeName,
//         this.storeIcon,
//         this.address,
//         this.lat,
//         this.lng,
//         this.image1,
//         this.image2,
//         this.image3,
//         this.image4,
//         this.status,
//         this.isDeleted,
//         this.createdAt,
//         this.updatedAt,
//         this.userId
//       });
//
//   Store.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     storeName = json['store_name'];
//     storeIcon = json['store_icon'];
//     address = json['address'];
//     lat = json['lat'];
//     lng = json['lng'];
//     image1 = json['image_1'];
//     image2 = json['image_2'];
//     image3 = json['image_3'];
//     image4 = json['image_4'];
//     status = json['status'];
//     isDeleted = json['is_deleted'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     userId = json['user_id'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['store_name'] = this.storeName;
//     data['store_icon'] = this.storeIcon;
//     data['address'] = this.address;
//     data['lat'] = this.lat;
//     data['lng'] = this.lng;
//     data['image_1'] = this.image1;
//     data['image_2'] = this.image2;
//     data['image_3'] = this.image3;
//     data['image_4'] = this.image4;
//     data['status'] = this.status;
//     data['is_deleted'] = this.isDeleted;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['user_id'] = this.userId;
//     return data;
//   }
// }

class OrderProduct {
  int? id;
  int? orderId;
  int? productId;
  int? storeProductId;
  int? price;
  int? quantity;
  String? size;
  String? createdAt;
  String? updatedAt;
  Product? product;

  OrderProduct(
      {this.id,
      this.orderId,
      this.productId,
      this.storeProductId,
      this.price,
      this.quantity,
      this.size,
      this.createdAt,
      this.updatedAt,
      this.product});

  OrderProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    storeProductId = json['store_product_id'];
    price = json['price'];
    quantity = json['quantity'];
    size = json['size'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['store_product_id'] = this.storeProductId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['size'] = this.size;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

// class Product {
//   int? id;
//   String? productName;
//   String? productDescription;
//   int? hasSize;
//   String? image;
//   String? iconImage;
//   String? status;
//   int? addedBy;
//   String? createdAt;
//   String? updatedAt;
//
//   Product(
//       {
//         this.id,
//         this.productName,
//         this.productDescription,
//         this.hasSize,
//         this.image,
//         this.iconImage,
//         this.status,
//         this.addedBy,
//         this.createdAt,
//         this.updatedAt
//       });
//
//   Product.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productName = json['product_name'];
//     productDescription = json['product_description'];
//     hasSize = json['has_size'];
//     image = json['image'];
//     iconImage = json['icon_image'];
//     status = json['status'];
//     addedBy = json['added_by'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['product_name'] = this.productName;
//     data['product_description'] = this.productDescription;
//     data['has_size'] = this.hasSize;
//     data['image'] = this.image;
//     data['icon_image'] = this.iconImage;
//     data['status'] = this.status;
//     data['added_by'] = this.addedBy;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }

class OrderProduce {
  int? id;
  int? produceBagId;
  int? orderId;
  int? price;
  int? quantity;
  String? createdAt;
  List<ProduceProducts>? produceProducts;

  OrderProduce(
      {this.id,
      this.produceBagId,
      this.orderId,
      this.price,
      this.quantity,
      this.createdAt,
      this.produceProducts});

  OrderProduce.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    produceBagId = json['produce_bag_id'];
    orderId = json['order_id'];
    price = json['price'];
    quantity = json['quantity'];
    createdAt = json['created_at'];
    if (json['produce_products'] != null) {
      produceProducts = <ProduceProducts>[];
      json['produce_products'].forEach((v) {
        produceProducts!.add(new ProduceProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['produce_bag_id'] = this.produceBagId;
    data['order_id'] = this.orderId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['created_at'] = this.createdAt;
    if (this.produceProducts != null) {
      data['produce_products'] =
          this.produceProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProduceProducts {
  int? id;
  int? orderId;
  int? orderProduceId;
  int? storeProduceBagId;
  int? storeProduceBagProductId;
  int? productId;
  int? storeProductId;
  String? productSize;
  int? qty;
  Product? product;

  ProduceProducts(
      {this.id,
      this.orderId,
      this.orderProduceId,
      this.storeProduceBagId,
      this.storeProduceBagProductId,
      this.productId,
      this.storeProductId,
      this.productSize,
      this.qty,
      this.product});

  ProduceProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    orderProduceId = json['order_produce_id'];
    storeProduceBagId = json['store_produce_bag_id'];
    storeProduceBagProductId = json['store_produce_bag_product_id'];
    productId = json['product_id'];
    storeProductId = json['store_product_id'];
    productSize = json['product_size'];
    qty = json['qty'];
    product =
        json['product'] != null ? new Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['order_produce_id'] = this.orderProduceId;
    data['store_produce_bag_id'] = this.storeProduceBagId;
    data['store_produce_bag_product_id'] = this.storeProduceBagProductId;
    data['product_id'] = this.productId;
    data['store_product_id'] = this.storeProductId;
    data['product_size'] = this.productSize;
    data['qty'] = this.qty;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}

class OrderVoucher {
  int? id;
  int? orderId;
  int? voucherId;
  int? voucherPrice;
  String? voucherCode;
  String? withdrawStatus;
  String? createdAt;
  List<Voucher>? voucher;

  OrderVoucher(
      {this.id,
      this.orderId,
      this.voucherId,
      this.voucherPrice,
      this.voucherCode,
      this.withdrawStatus,
      this.createdAt,
      this.voucher});

  OrderVoucher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    voucherId = json['voucher_id'];
    voucherPrice = json['voucher_price'];
    voucherCode = json['voucher_code'];
    withdrawStatus = json['withdraw_status'];
    createdAt = json['created_at'];
    if (json['voucher'] != null) {
      voucher = <Voucher>[];
      json['voucher'].forEach((v) {
        voucher!.add(new Voucher.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['voucher_id'] = this.voucherId;
    data['voucher_price'] = this.voucherPrice;
    data['voucher_code'] = this.voucherCode;
    data['withdraw_status'] = this.withdrawStatus;
    data['created_at'] = this.createdAt;
    if (this.voucher != null) {
      data['voucher'] = this.voucher!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Voucher {
  int? id;
  String? voucherCode;
  int? voucherPrice;
  String? status;
  String? expiryDate;
  String? updatedAt;
  String? createdAt;

  Voucher(
      {this.id,
      this.voucherCode,
      this.voucherPrice,
      this.status,
      this.expiryDate,
      this.updatedAt,
      this.createdAt});

  Voucher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    voucherCode = json['voucher_code'];
    voucherPrice = json['voucher_price'];
    status = json['status'];
    expiryDate = json['expiry_date'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['voucher_code'] = this.voucherCode;
    data['voucher_price'] = this.voucherPrice;
    data['status'] = this.status;
    data['expiry_date'] = this.expiryDate;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}

// class OrderData {
//   int? id;
//   int? userId;
//   int? storeId;
//   int? total;
//   String? orderStatus;
//   String? createdAt;
//   String? updatedAt;
//   List<OrderProduct>? orderProduct;
//   List<OrderProduce>? orderProduce;
//   List<OrderVoucher>? orderVoucher;
//
//   OrderData(
//       {this.id,
//         this.userId,
//         this.storeId,
//         this.total,
//         this.orderStatus,
//         this.createdAt,
//         this.updatedAt,
//         this.orderProduct,
//         this.orderProduce,
//         this.orderVoucher});
//
//   OrderData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     storeId = json['store_id'];
//     total = json['total'];
//     orderStatus = json['order_status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     if (json['order_product'] != null) {
//       orderProduct = <OrderProduct>[];
//       json['order_product'].forEach((v) {
//         orderProduct!.add(new OrderProduct.fromJson(v));
//       });
//     }
//     if (json['order_produce'] != null) {
//       orderProduce = <OrderProduce>[];
//       json['order_produce'].forEach((v) {
//         orderProduce!.add(new OrderProduce.fromJson(v));
//       });
//     }
//     if (json['order_voucher'] != null) {
//       orderVoucher = <OrderVoucher>[];
//       json['order_voucher'].forEach((v) {
//         orderVoucher!.add(new OrderVoucher.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['store_id'] = this.storeId;
//     data['total'] = this.total;
//     data['order_status'] = this.orderStatus;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.orderProduct != null) {
//       data['order_product'] =
//           this.orderProduct!.map((v) => v.toJson()).toList();
//     }
//     if (this.orderProduce != null) {
//       data['order_produce'] =
//           this.orderProduce!.map((v) => v.toJson()).toList();
//     }
//     if (this.orderVoucher != null) {
//       data['order_voucher'] =
//           this.orderVoucher!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class OrderProduct {
//   int? id;
//   int? orderId;
//   int? productId;
//   int? storeProductId;
//   int? price;
//   int? quantity;
//   String? size;
//   String? createdAt;
//   String? updatedAt;
//   Product? product;
//
//   OrderProduct(
//       {this.id,
//         this.orderId,
//         this.productId,
//         this.storeProductId,
//         this.price,
//         this.quantity,
//         this.size,
//         this.createdAt,
//         this.updatedAt,
//         this.product});
//
//   OrderProduct.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     orderId = json['order_id'];
//     productId = json['product_id'];
//     storeProductId = json['store_product_id'];
//     price = json['price'];
//     quantity = json['quantity'];
//     size = json['size'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     product =
//     json['product'] != null ? new Product.fromJson(json['product']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['order_id'] = this.orderId;
//     data['product_id'] = this.productId;
//     data['store_product_id'] = this.storeProductId;
//     data['price'] = this.price;
//     data['quantity'] = this.quantity;
//     data['size'] = this.size;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     if (this.product != null) {
//       data['product'] = this.product!.toJson();
//     }
//     return data;
//   }
// }
//
// class Product {
//   int? id;
//   String? productName;
//   String? productDescription;
//   int? hasSize;
//   String? image;
//   String? iconImage;
//   String? status;
//   int? addedBy;
//   String? createdAt;
//   String? updatedAt;
//
//   Product(
//       {this.id,
//         this.productName,
//         this.productDescription,
//         this.hasSize,
//         this.image,
//         this.iconImage,
//         this.status,
//         this.addedBy,
//         this.createdAt,
//         this.updatedAt});
//
//   Product.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     productName = json['product_name'];
//     productDescription = json['product_description'];
//     hasSize = json['has_size'];
//     image = json['image'];
//     iconImage = json['icon_image'];
//     status = json['status'];
//     addedBy = json['added_by'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['product_name'] = this.productName;
//     data['product_description'] = this.productDescription;
//     data['has_size'] = this.hasSize;
//     data['image'] = this.image;
//     data['icon_image'] = this.iconImage;
//     data['status'] = this.status;
//     data['added_by'] = this.addedBy;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     return data;
//   }
// }
//
// class OrderProduce {
//   int? id;
//   int? produceBagId;
//   int? orderId;
//   int? price;
//   int? quantity;
//   String? createdAt;
//   List<ProduceProducts>? produceProducts;
//
//   OrderProduce(
//       {this.id,
//         this.produceBagId,
//         this.orderId,
//         this.price,
//         this.quantity,
//         this.createdAt,
//         this.produceProducts});
//
//   OrderProduce.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     produceBagId = json['produce_bag_id'];
//     orderId = json['order_id'];
//     price = json['price'];
//     quantity = json['quantity'];
//     createdAt = json['created_at'];
//     if (json['produce_products'] != null) {
//       produceProducts = <ProduceProducts>[];
//       json['produce_products'].forEach((v) {
//         produceProducts!.add(new ProduceProducts.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['produce_bag_id'] = this.produceBagId;
//     data['order_id'] = this.orderId;
//     data['price'] = this.price;
//     data['quantity'] = this.quantity;
//     data['created_at'] = this.createdAt;
//     if (this.produceProducts != null) {
//       data['produce_products'] =
//           this.produceProducts!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ProduceProducts {
//   int? id;
//   int? orderId;
//   int? orderProduceId;
//   int? storeProduceBagId;
//   int? storeProduceBagProductId;
//   int? productId;
//   int? storeProductId;
//   String? productSize;
//   int? qty;
//   Product? product;
//
//   ProduceProducts(
//       {this.id,
//         this.orderId,
//         this.orderProduceId,
//         this.storeProduceBagId,
//         this.storeProduceBagProductId,
//         this.productId,
//         this.storeProductId,
//         this.productSize,
//         this.qty,
//         this.product});
//
//   ProduceProducts.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     orderId = json['order_id'];
//     orderProduceId = json['order_produce_id'];
//     storeProduceBagId = json['store_produce_bag_id'];
//     storeProduceBagProductId = json['store_produce_bag_product_id'];
//     productId = json['product_id'];
//     storeProductId = json['store_product_id'];
//     productSize = json['product_size'];
//     qty = json['qty'];
//     product =
//     json['product'] != null ? new Product.fromJson(json['product']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['order_id'] = this.orderId;
//     data['order_produce_id'] = this.orderProduceId;
//     data['store_produce_bag_id'] = this.storeProduceBagId;
//     data['store_produce_bag_product_id'] = this.storeProduceBagProductId;
//     data['product_id'] = this.productId;
//     data['store_product_id'] = this.storeProductId;
//     data['product_size'] = this.productSize;
//     data['qty'] = this.qty;
//     if (this.product != null) {
//       data['product'] = this.product!.toJson();
//     }
//     return data;
//   }
// }
//
// class OrderVoucher {
//   int? id;
//   int? orderId;
//   int? voucherId;
//   int? voucherPrice;
//   String? voucherCode;
//   String? withdrawStatus;
//   String? createdAt;
//   List<Voucher>? voucher;
//
//   OrderVoucher(
//       {this.id,
//         this.orderId,
//         this.voucherId,
//         this.voucherPrice,
//         this.voucherCode,
//         this.withdrawStatus,
//         this.createdAt,
//         this.voucher});
//
//   OrderVoucher.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     orderId = json['order_id'];
//     voucherId = json['voucher_id'];
//     voucherPrice = json['voucher_price'];
//     voucherCode = json['voucher_code'];
//     withdrawStatus = json['withdraw_status'];
//     createdAt = json['created_at'];
//     if (json['voucher'] != null) {
//       voucher = <Voucher>[];
//       json['voucher'].forEach((v) {
//         voucher!.add(new Voucher.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['order_id'] = this.orderId;
//     data['voucher_id'] = this.voucherId;
//     data['voucher_price'] = this.voucherPrice;
//     data['voucher_code'] = this.voucherCode;
//     data['withdraw_status'] = this.withdrawStatus;
//     data['created_at'] = this.createdAt;
//     if (this.voucher != null) {
//       data['voucher'] = this.voucher!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Voucher {
//   int? id;
//   String? voucherCode;
//   int? voucherPrice;
//   String? status;
//   String? expiryDate;
//   String? updatedAt;
//   String? createdAt;
//
//   Voucher(
//       {this.id,
//         this.voucherCode,
//         this.voucherPrice,
//         this.status,
//         this.expiryDate,
//         this.updatedAt,
//         this.createdAt});
//
//   Voucher.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     voucherCode = json['voucher_code'];
//     voucherPrice = json['voucher_price'];
//     status = json['status'];
//     expiryDate = json['expiry_date'];
//     updatedAt = json['updated_at'];
//     createdAt = json['created_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['voucher_code'] = this.voucherCode;
//     data['voucher_price'] = this.voucherPrice;
//     data['status'] = this.status;
//     data['expiry_date'] = this.expiryDate;
//     data['updated_at'] = this.updatedAt;
//     data['created_at'] = this.createdAt;
//     return data;
//   }
// }
