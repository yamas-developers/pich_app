import 'package:farmer_app/helpers/db/sqf_object.dart';

class Cart extends MJObject<Cart> {
  static String STORE_NAME = 'cart';
  static String PRIMARY_KEY = 'id';
  static final query = """CREATE TABLE if not exists """ +
      STORE_NAME +
      """(
   id   INTEGER  NOT NULL PRIMARY KEY
  ,store_product_id   TEXT  NOT NULL
  ,qty TEXT
  ,store_id  TEXT,
  price TEXT,
  type TEXT
  );""";
  String? id;
  String? storeProductId;
  String? qty;
  String? price;
  String? type;
  String? storeId;

  Cart(
      {this.id,
      this.storeProductId,
      this.qty,
      this.storeId,
      this.price,
      this.type});

  @override
  Map<String, dynamic> toMap(Cart cart) {
    Map<String,dynamic> data = {};
    data['id'] = cart.id;
    data['store_product_id'] = cart.storeProductId;
    data['qty'] = cart.qty;
    data['store_id'] = cart.storeId;
    data['price'] = cart.price;
    data['type'] = cart.type;
    return data;
  }
  @override
  Map<String, dynamic> toRequestMap(Cart cart) {
    Map<String,dynamic> data = {};
    data['id'] = cart.id;
    data['store_product_id'] = cart.storeProductId;
    data['qty'] = cart.qty;
    data['store_id'] = cart.storeId;
    data['price'] = cart.price;
    data['type'] = cart.type;
    return data;
  }

  @override
  Cart fromMap(dynamic data) {
    return Cart(
      id: data['id'].toString(),
      storeProductId: data['store_product_id'].toString(),
      qty: data['qty'],
      storeId: data['store_id'],
      price: data['price'],
      type: data['type'],
    );
  }

  toList(List<dynamic> data) {
    List<Cart> list = [];
    for (int i = 0; i < data.length; i++) {
      Cart object = this.fromMap(data[i]);
      list.add(object);
    }
    return list;
  }

  @override
  List<Cart> fromMapList(List data) {
    List<Cart> list = [];
    for (int i = 0; i < data.length; i++) {
      Cart object = this.fromMap(data[i]);
      list.add(object);
    }
    return list;
  }

  @override
  String getPrimaryKey() {
    // TODO: implement getPrimaryKey
    // throw UnimplementedError();
    return this.id!;
  }

  @override
  List<Map<String, dynamic>> toMapList(List<Cart> objectList) {
    List<Map<String, dynamic>> list = [];
    for (int i = 0; i < objectList.length; i++) {
      list.add(this.toMap(objectList[i]));
    }
    return list;
  }
  @override
  List<Map<String, dynamic>> toRequestMapList(List<Cart> objectList) {
    List<Map<String, dynamic>> list = [];
    for (int i = 0; i < objectList.length; i++) {
      list.add(this.toRequestMap(objectList[i]));
    }
    return list;
  }
}
