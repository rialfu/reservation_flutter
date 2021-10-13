import 'DataOrderModel.dart';

class OrderModel {
  final DateTime tanggal;
  final String field;
  List<DataOrderModel> orderData = [];
  OrderModel(this.tanggal, this.field);
  void addDataOrder(DataOrderModel data) {
    this.orderData.add(data);
  }

  void mergeDataOrder(List<DataOrderModel> data) {
    this.orderData = []..addAll(this.orderData)..addAll(data);
  }
}
