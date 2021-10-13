import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:reservation/model/PaketLapangan/Paket.dart';
import 'package:reservation/model/PaketLapangan/JenisPaket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaftarHarga extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Paket? data;
  List<JenisPaket> daftarHarga = [];

  Future<void> getData(String field, DateTime now) async {
    try {
      String day = DateFormat('E').format(now);
      if (day == 'Fri') {
        day = 'jumat';
      } else if (day == 'Sat' || day == 'Sun') {
        day = 'sabtu';
      } else {
        day = 'senin';
      }
      List<JenisPaket> daftarHarga = [];
      QuerySnapshot qs = await firestore
          .collection('daftar_harga')
          .where('field', isEqualTo: field.toLowerCase())
          .get();
      if (qs.docs.length == 1) {
        QueryDocumentSnapshot doc = qs.docs[0];
        List<JenisPaket> listJenis = [];
        List jenis = doc['jenis'];
        for (int i = 0; i < jenis.length; i++) {
          var detail = jenis[i];
          JenisPaket jp = JenisPaket(
              detail['tipe'], detail['hari'], detail['waktu'], detail['harga']);
          listJenis.add(jp);
          if (detail['hari'] == day) {
            daftarHarga.add(jp);
          }
        }
        Paket paket = Paket(doc['field'], doc['paket'], listJenis);
        this.daftarHarga = daftarHarga;
        this.data = paket;
      }
      notifyListeners();
    } catch (e) {}
  }

  void clearData() {
    data = null;
    notifyListeners();
  }
}
