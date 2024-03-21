class VendorDashboardStoreData {
  int? pendingOrders;
  int? todayOrders;
  int? totalStoreProducts;
  int? completedOrders;
  String? todayEarning;
  int? totalProduces;
  int? todayProduces;
  int? todaySoldItems;

  VendorDashboardStoreData(
      {this.pendingOrders,
        this.todayOrders,
        this.totalStoreProducts,
        this.completedOrders,
        this.todayEarning,
        this.totalProduces,
        this.todayProduces,
        this.todaySoldItems});

  VendorDashboardStoreData.fromJson(Map<String, dynamic> json) {
    pendingOrders = json['pending_orders'];
    todayOrders = json['today_orders'];
    totalStoreProducts = json['total_store_products'];
    completedOrders = json['completed_orders'];
    todayEarning = json['today_earning'].toString();
    totalProduces = json['total_produces'];
    todayProduces = json['today_produces'];
    todaySoldItems = json['today_sold_items'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending_orders'] = this.pendingOrders;
    data['today_orders'] = this.todayOrders;
    data['total_store_products'] = this.totalStoreProducts;
    data['completed_orders'] = this.completedOrders;
    data['today_earning'] = this.todayEarning;
    data['total_produces'] = this.totalProduces;
    data['today_produces'] = this.todayProduces;
    data['today_sold_items'] = this.todaySoldItems;
    return data;
  }
}
