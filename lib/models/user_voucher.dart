class Voucher {
  int? id;
  String? voucherCode;
  int? voucherPrice;
  String? status;
  String? expiryDate;
  String? updatedAt;
  String? createdAt;

  Voucher(
      {
        this.id,
        this.voucherCode,
        this.voucherPrice,
        this.status,
        this.expiryDate,
        this.updatedAt,
        this.createdAt
      });

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
