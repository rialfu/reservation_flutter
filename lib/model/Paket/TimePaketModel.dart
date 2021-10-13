class TimePaketModel {
  final int start;
  final int finish;
  final String waktu;
  TimePaketModel.fromMap(Map data)
      : this.start = data['start'],
        this.finish = data['finish'],
        this.waktu = data['waktu'];
}
