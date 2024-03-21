import 'dart:convert';

import 'package:farmer_app/api/mj_api_service.dart';
import 'package:farmer_app/api/mj_apis.dart';
import 'package:farmer_app/helpers/constraints.dart';
import 'package:farmer_app/helpers/db/db_helper.dart';
import 'package:farmer_app/helpers/session_helper.dart';
import 'package:farmer_app/models/cart.dart';
import 'package:farmer_app/models/store_produce_bag.dart';
import 'package:farmer_app/models/store_product.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/cupertino.dart';

class CartHelper extends DBHelper<Cart> with ChangeNotifier, MjApiService {
  List<Cart> _list = [];
  List<StoreProduct> _storeProductList = [];
  List<StoreProduceBag> _storeProduceBagList = [];
  int _cartTotal = 0;
  String _currentStoreId = '0';

  int get cartTotal => _cartTotal;
  bool _loading = false;

  List<Cart> get list => _list;

  List<StoreProduct> get storeProductList => _storeProductList;

  List<StoreProduceBag> get storeProduceBagList => _storeProduceBagList;

  bool get loading => _loading;

  Future<int> calculateCartTotal() async {
    // var data = await getCartData();
    _cartTotal = 0;
    for (int i = 0; i < _list.length; i++) {
      print(_cartTotal);
      _cartTotal += convertNumber(_list[i].price) * convertNumber(_list[i].qty);
    }
    notifyListeners();
    return _cartTotal;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  set list(List<Cart> value) {
    _list.clear();
    _list.addAll(value);
    notifyListeners();
  }

  set storeProductList(List<StoreProduct> value) {
    _storeProductList.clear();
    _storeProductList.addAll(value);
    notifyListeners();
  }

  set storeProduceBagList(List<StoreProduceBag> value) {
    _storeProduceBagList.clear();
    _storeProduceBagList.addAll(value);
    notifyListeners();
  }

  CartHelper() {
    init(Cart(), Cart.query, Cart.STORE_NAME);
  }

  Map isProduceAdded(int? id) {
    int quantity = 0;
    String cartId = '0';
    if (id != null) {
    _storeProduceBagList.forEach((element) {
      if (element.id == id) {
        quantity = convertNumber(element.qty);
        cartId = element.cartId ?? '0';
      }
    });
    }
    return {'quantity': quantity, 'cartId': cartId};
  }

  Map isProductAdded(int? id) {
    int quantity = 0;
    String cartId = '0';
    if (id != null) {
      _storeProductList.forEach((element) {
        if (element.id == id) {
          quantity = convertNumber(element.qty);
          cartId = element.cartId ?? '0';
        }
      });
    }
    return {'quantity': quantity, 'cartId': cartId};
  }

  Future<bool> addToCart(
      {required storeProductId,
      required quantity,
      required store_id,
      required price,
      required type}) async {
    loading = true;
    if (_currentStoreId != '0') {
      if (_currentStoreId != store_id.toString()) {
        await clearCart();
      }
    } else {
      _list = Cart().fromMapList(await getAll());
      if (_list.isNotEmpty) {
        _currentStoreId = _list.first.storeId ?? '0';
        if (_currentStoreId != '0' && _currentStoreId != store_id.toString()) {
          await clearCart();
        }
      }
    }
    _currentStoreId = store_id.toString();

    int itemQuantity = 0;
    Map cartData = {};

    if (type == 'produce') {
      cartData = isProduceAdded(storeProductId);
      itemQuantity = cartData['quantity'];
    } else {
      cartData = isProductAdded(storeProductId);
      itemQuantity = cartData['quantity'];
    }

    var data;

    if (itemQuantity > 0) {
      if (type == 'produce') {
        updateBagCartQuantity(cartData['cartId'], itemQuantity + 1);
      } else {
        updateProductCartQuantity(cartData['cartId'], itemQuantity + 1);
      }
      data = true;
    } else {
      data = await insert(Cart(
          storeProductId: storeProductId.toString(),
          qty: quantity.toString(),
          storeId: store_id.toString(),
          price: price.toString(),
          type: type.toString()));
      await getCartData();
    }
    loading = false;
    notifyListeners();
    return data != null;
  }

  Future<void> updateBagCartQuantity(String id, int quantity) async {
    if (quantity < 1) {
      print('quantity less than one');
      removeFromCart(id);
      await getCartData();
      notifyListeners();
      return;
    }
    _storeProduceBagList.forEach((element) async {
      if (element.cartId == id) {
        element.qty = quantity.toString();
        print('quantity: ${element.qty}');

        notifyListeners();
        // return;
      }
    });
    int m = await updateWhere(
        ['qty'], [quantity.toString()], ['id'], [id.toString()]);
    await getCartData();
  }

  Future<void> updateProductCartQuantity(String id, int quantity) async {
    if (quantity < 1) {
      print('quantity less than one');
      removeFromCart(id);
      await getCartData();
      notifyListeners();
      return;
    }
    _storeProductList.forEach((element) {
      if (element.cartId == id) {
        element.qty = quantity.toString();
        notifyListeners();
        // return;
      }
    });
    await updateWhere(['qty'], [quantity.toString()], ['id'], [id.toString()]);
    await getCartData();
  }

  Future<bool> removeFromCart(cartId) async {
    // get
    var data = await deleteOne('id', cartId);
    return data != null;
  }

  Future<bool> clearCart() async {
    // get
    var data = await deleteAll();
    await getCartData();
    return data != null;
  }

  getCartData() async {
    _list = Cart().fromMapList(await getAll());
    print('list from db: ${_list.map((e) => e.toMap(e))}');
    calculateCartTotal();
    await getStoreProducts();
    notifyListeners();
    return true;
  }

  refreshCart() async {
    await clearCart();
    List<Cart> newList = [];
    for (int i = 0; i < storeProductList.length; i++) {}
  }

  getStoreProducts() async {
    loading = true;
    User user = (await getUser())!;
    if(user.id == null){
      _list.clear();
      notifyListeners();
      return;
    }
    var payload = {"cartList": jsonEncode(Cart().toRequestMapList(list))};
    print('payload cart: ${payload}');
    var response =
        await postRequest(MJ_Apis.check_cart + "/${user.id}", payload);

    if (response != null) {
      print(response);
      var produceList = response['produce_bags'];
      var productList = response['products'];
      List<StoreProduceBag> produceObjList = [];
      List<StoreProduct> productObjList = [];
      storeProduceBagList = [];
      storeProductList = [];
      for (int i = 0; i < produceList.length; i++) {
        produceObjList.add(StoreProduceBag.fromJson(produceList[i]));
      }
      storeProduceBagList = produceObjList;
      for (int i = 0; i < productList.length; i++) {
        productObjList.add(StoreProduct.fromJson(productList[i]));
      }
      storeProductList = productObjList;
    }
    loading = false;
    notifyListeners();
  }
}
