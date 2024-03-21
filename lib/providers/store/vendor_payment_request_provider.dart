import 'package:farmer_app/models/payment_request_data.dart';
import 'package:farmer_app/models/search_profile.dart';
import 'package:farmer_app/models/user.dart';
import 'package:flutter/cupertino.dart';

class VendorPaymentRequestProvider extends ChangeNotifier{
  int _currentPage = 0;
  int _maxPages = 0;
  List<PaymentRequest> _pendingRequests = [];
  List<PaymentRequest> _completedRequests = [];
  bool _isLoading = false;

  int get currentPage => _currentPage;
  int get maxPages => _maxPages;
  bool get isLoading => _isLoading;
  List<PaymentRequest> get pendingRequests => _pendingRequests;
  List<PaymentRequest> get completedRequests => _completedRequests;

  set isLoading(bool value){
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
  set pendingRequests(List<PaymentRequest> value) {
    _pendingRequests = value;
    notifyListeners();
  }
  set completedRequests(List<PaymentRequest> value) {
    _completedRequests = value;
    notifyListeners();
  }
  addMoreCompletedRequests(List<PaymentRequest> value){
    _completedRequests.addAll(value);
    notifyListeners();
  }

}
