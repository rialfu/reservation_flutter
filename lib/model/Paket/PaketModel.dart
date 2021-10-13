import 'TimePaketModel.dart';
import 'HargaPaketModel.dart';

class PaketModel {
  final String jenis;
  final int long;
  final List<String> listLap;
  final List<TimePaketModel> tpm;
  final List<HargaPaketModel> hpm;

  PaketModel(this.jenis, this.long, this.listLap, this.tpm, this.hpm);

  factory PaketModel.fromJson(var data) {
    String jenis = data['jenis'];
    int long = data['long'];
    List ll = data['list_lap'];
    List<String> listLap = ll.map((e) => e.toString()).toList();
    listLap.sort((a, b) => a.compareTo(b));

    List timeList = data['time_list'];
    List<TimePaketModel> tpm =
        timeList.map((e) => TimePaketModel.fromMap(e)).toList();
    tpm.sort((a, b) => a.start.compareTo(b.start));

    List paketList = data['paket_list'];
    List<HargaPaketModel> hpm =
        paketList.map((e) => HargaPaketModel.fromMap(e)).toList();
    return PaketModel(jenis, long, listLap, tpm, hpm);
  }
  static String? getDifferent(List<String> lap, List<String> listLap) {
    // List lap = jumlah == 2 ? ['a', 'b'] : ['a', 'b', 'c'];
    var a = listLap.where((val) => !lap.contains(val));
    if (a.isEmpty) {
      return null;
    } else {
      return a.first;
    }
  }
}
