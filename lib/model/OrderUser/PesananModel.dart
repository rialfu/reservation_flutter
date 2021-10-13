class PesananModel {
  final int start;
  final int finish;
  final String lap;
  PesananModel(this.start, this.finish, this.lap);
  PesananModel.fromMap(Map doc)
      : this.start = doc['start'],
        this.finish = doc['finish'],
        lap = doc['lap'];

  Map<String, dynamic> toJson() =>
      {'start': this.start, 'finish': this.finish, 'lap': this.lap};
}
