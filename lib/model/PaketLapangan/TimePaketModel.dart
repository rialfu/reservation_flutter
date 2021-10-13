class TimePaketModel {
  int finish;
  int start;
  String waktu;
  TimePaketModel.fromMap(Map snap)
      : finish = snap['finish'],
        start = snap['start'],
        waktu = snap['waktu'];
}
