class HargaPaketModel {
  final String tipe;
  final String hari;
  final String waktu;
  final int harga;
  HargaPaketModel(this.tipe, this.hari, this.waktu, this.harga);
  HargaPaketModel.fromMap(Map data)
      : this.tipe = data['tipe'],
        this.hari = data['hari'],
        this.waktu = data['waktu'],
        this.harga = data['harga'];
}
