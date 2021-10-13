import 'PesananModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String jenis;
  String userId;
  final int harga;
  DateTime batas;
  DateTime waktu;
  bool lunas;
  bool dp;
  bool delete = false;

  List<PesananModel> listPesanan = [];

  OrderModel(this.id, this.jenis, this.userId, this.harga, this.batas,
      this.waktu, this.dp, this.lunas, this.listPesanan);

  factory OrderModel.fromJson(var data, String id) {
    String jenis = data['jenis'];
    String userId = data['userId'];
    int harga = data['harga'];
    DateTime batas = data['batas'].toDate();
    DateTime waktu = data['waktu'].toDate();
    bool dp = data['dp'];
    bool lunas = data['lunas'];
    List pesanan = data['pesanan'];

    List<PesananModel> lp =
        pesanan.map((e) => PesananModel.fromMap(e)).toList();
    return OrderModel(id, jenis, userId, harga, batas, waktu, dp, lunas, lp);
  }
  factory OrderModel.makeTemplate(
      String jenis, DateTime waktu, List<PesananModel> pesanan, int harga) {
    DateTime batas = DateTime.now(); //change
    bool dp = false; //default
    bool lunas = false; //default
    return OrderModel('', jenis, '', harga, batas, waktu, dp, lunas, pesanan);
  }
  static List<OrderModel> findWithTimeAndLap(int st, int fi, List<OrderModel> o,
      {String lap = ''}) {
    List<OrderModel> f;
    f = o.where((el) {
      var d = el.listPesanan.where((e) {
        // if (lap != '') {
        return st >= e.start && e.finish >= fi && e.lap == lap;
        // }
        // return start >= e.start && e.finish >= finish;
      });
      return d.isNotEmpty;
    }).toList();
    return f;
  }

  // static List<String> findDataWithTimeAndLap(
  //     int st, int fi, List<OrderModel> o, String lap) {
  //   // List<OrderModel> f;
  //   o = o.where((el) {
  //     var d = el.listPesanan.where((e) {
  //       // if (lap != '') {
  //       return st >= e.start && e.finish >= fi && e.lap == lap;
  //       // }
  //       // return start >= e.start && e.finish >= finish;
  //     });
  //     return d.isNotEmpty;
  //   }).toList();
  //   List<String> data = o.map((e) => e.id).toList();
  //   return data;
  // }

  Map<String, dynamic> toSaveFireStore() => {
        'batas': Timestamp.fromDate(this.batas),
        'dp': this.dp,
        'harga': this.harga,
        'jenis': this.jenis,
        'userId': this.userId,
        'lunas': this.lunas,
        'pesanan': this.listPesanan.map((e) => e.toJson()).toList(),
        'waktu': Timestamp.fromDate(this.waktu),
      };
}
