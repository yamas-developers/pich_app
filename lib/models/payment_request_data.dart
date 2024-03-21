

import 'package:farmer_app/models/order_data.dart';

class PaymentRequest {
  String? id;
  String? storeId;
  String? userId;
  String? amount;
  String? paymentStatus;
  String? adminRemarks;
  String? adminId;
  String? createdAt;
  String? updatedAt;
  List<PaymentRequestOrder>? paymentRequestOrder;

  PaymentRequest(
      {this.id,
        this.storeId,
        this.userId,
        this.amount,
        this.paymentStatus,
        this.adminRemarks,
        this.adminId,
        this.createdAt,
        this.updatedAt,
        this.paymentRequestOrder});

  PaymentRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    storeId = json['store_id'].toString();
    userId = json['user_id'].toString();
    amount = json['amount'].toString();
    paymentStatus = json['payment_status'];
    adminRemarks = json['admin_remarks'];
    adminId = json['admin_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['payment_request_order'] != null) {
      paymentRequestOrder = <PaymentRequestOrder>[];
      json['payment_request_order'].forEach((v) {
        paymentRequestOrder!.add(new PaymentRequestOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['payment_status'] = this.paymentStatus;
    data['admin_remarks'] = this.adminRemarks;
    data['admin_id'] = this.adminId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.paymentRequestOrder != null) {
      data['payment_request_order'] =
          this.paymentRequestOrder!.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

class PaymentRequestOrder {
  String? paymentRequestId;
  String? id;
  String? orderId;
  List<OrderData>? order; //can be null

  PaymentRequestOrder(
      {this.id, this.paymentRequestId, this.orderId, this.order});

  PaymentRequestOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    paymentRequestId = json['payment_request_id'].toString();
    orderId = json['order_id'].toString();
    if (json['order'] != null) {
      order = [];
      json['order'].forEach((v) {
        order!.add(new OrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['payment_request_id'] = this.paymentRequestId;
    data['order_id'] = this.orderId;
    if (this.order != null) {
      data['order'] = this.order!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
