import 'package:farmer_app/models/user_voucher.dart';
import 'package:flutter/cupertino.dart';

class UserVoucherProvider extends ChangeNotifier {
  int _currentPage = 0;
  int _maxPages = 0;
  List<Voucher> _list = [];
  List<Voucher> _selectedVouchers = [];
  bool _isLoading = false;

  int get currentPage => _currentPage;

  int get maxPages => _maxPages;

  bool get isLoading => _isLoading;

  List<Voucher> get list => _list;

  List<Voucher> get selectedVouchersList => _selectedVouchers;

  set selectedVouchersList(List<Voucher> value) {
    _selectedVouchers = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  set maxPages(int value) {
    _maxPages = value;
    notifyListeners();
  }

  set list(List<Voucher> value) {
    _list = value;
    notifyListeners();
  }

  addMore(List<Voucher> value) {
    _list.addAll(value);
    notifyListeners();
  }
  int get selectedVoucherTotal {
    int total = 0;
    _selectedVouchers.forEach((element) {
      total += element.voucherPrice!;
    });
    return total;
  }

  void selectVoucher(int? id) {
    if (id == null) return;
    _selectedVouchers.add(_list.firstWhere((element) => element.id == id));
    print('SelectedVouchers: ${_selectedVouchers}');
    notifyListeners();
  }
  void unselectVoucher(int? id) {
    print('id: $id');
    if (id == null) return;
    _selectedVouchers.removeWhere( (element) => element.id == id);
    notifyListeners();
  }

  bool isSelectedVoucher(int? id) {
    if (id == null) return false;
    // int index;
    Voucher voucher = _list.firstWhere((element) => element.id == id);
    var v = _selectedVouchers.where((element) => element.id == voucher.id);
    // index = _selectedVouchers.indexOf(voucher);
    // print('isSelected: ${_list.map((e) => e.id)}');
    // print('isSelected: ${_selectedVouchers.map((e) => e.id)}');
    if (v.length > 0) {
      return true;
    }

    return false;
  }
}
