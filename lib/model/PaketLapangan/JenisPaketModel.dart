class JenisPaketModel {
  String tipe;
  String hari;
  String waktu;
  int harga;
  JenisPaketModel(this.tipe, this.hari, this.waktu, this.harga);
  JenisPaketModel.fromMap(Map snap)
      : this.tipe = snap['tipe'],
        this.hari = snap['hari'],
        this.waktu = snap['waktu'],
        this.harga = snap['harga'];
}
