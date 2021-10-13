import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/OrderLapangan/OrderModel.dart';
// import '../model/OrderLapangan/TimePesanModel.dart';
import '../model/OrderLapangan/DataOrderModel.dart';
import '../extensions/DateExtension.dart';

class OrderRepository extends ChangeNotifier {
  String path = "Products";
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<OrderModel> orderList = [];
  OrderModel? order;
  StreamSubscription? store;
  void fetchProductsAsStream(String title, DateTime now, DateTime end) {
    store = firestore
        .collection('orders')
        .where('field', isEqualTo: title.toLowerCase())
        .where('waktu', isGreaterThanOrEqualTo: now)
        .where('waktu', isLessThanOrEqualTo: end)
        .snapshots()
        .listen((event) async {
      List<OrderModel> orderList = [];
      int indexFound;
      DateTime waktu;
      List time;
      List<DataOrderModel> listdom;
      await Future.forEach(event.docs, (QueryDocumentSnapshot element) {
        listdom = [];
        waktu = element['waktu'].toDate();
        time = element['pesanan'];
        indexFound = orderList.indexWhere((el) => el.tanggal.isSameDate(waktu));
        for (int i = 0; i < time.length; i++) {
          listdom.add(DataOrderModel(
              element.id,
              element['lap'],
              element['biaya'],
              time[i]['start'],
              time[i]['finish'],
              element['batas'].toDate()));
        }
        if (indexFound == -1) {
          OrderModel order =
              OrderModel(new DateTime(waktu.year, waktu.month, waktu.day), '');
          order.mergeDataOrder(listdom);
          orderList.add(order);
        } else {
          orderList[indexFound].mergeDataOrder(listdom);
        }
      });
      var o = orderList.where((element) => element.tanggal.isSameDate(now));
      this.order = o.isNotEmpty ? o.first : null;
      this.orderList = orderList;
    });
  }

  void cancel() {
    store?.cancel();
    store = null;
    notifyListeners();
  }
  // Future<Product> getProductById(String id) async {
  //   var doc = await _api.getDocumentById(id);
  //   notifyListeners();
  //   return Product.fromMap(doc.data, doc.documentID);
  // }
}
