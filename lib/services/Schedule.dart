import 'package:reservation/model/Order.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Schedule extends ChangeNotifier {
  String path = "Products";
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Order?>? orders;

  Stream<QuerySnapshot> fetchProductsAsStream() {
    notifyListeners();
    return firestore.collection('orders').where('date').snapshots();
  }

  // Future<Product> getProductById(String id) async {
  //   var doc = await _api.getDocumentById(id);
  //   notifyListeners();
  //   return Product.fromMap(doc.data, doc.documentID);
  // }
}
