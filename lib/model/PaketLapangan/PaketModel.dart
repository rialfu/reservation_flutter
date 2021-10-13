import 'package:reservation/model/PaketLapangan/JenisPaketModel.dart';
import 'package:reservation/model/PaketLapangan/TimePaketModel.dart';

class PaketModel {
  final String field;
  final int paket;
  final int jumLap;
  final List<JenisPaketModel> paketList;
  final List<TimePaketModel> timeList;

  PaketModel(
      this.field, this.paket, this.jumLap, this.paketList, this.timeList);

  factory PaketModel.fromJson(var snap) {
    String field = snap['field'];
    int paket = snap['paket'];
    int jumLap = snap['jumLap'];
    List tl = snap['time_list'];
    List<TimePaketModel> timeList =
        tl.map((e) => TimePaketModel.fromMap(e)).toList();
    timeList.sort((a, b) => a.start.compareTo(b.start));

    List jenis = snap['paket_list'];
    List<JenisPaketModel> listJenis =
        jenis.map((e) => JenisPaketModel.fromMap(e)).toList();
    return PaketModel(field, paket, jumLap, listJenis, timeList);
  }
  Map<String, dynamic> toJson() =>
      {'field': this.field, 'jumLap': this.jumLap, 'paket': this.paket};
}
