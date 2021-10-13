class DataOrderModel {
  final String uid;
  // final String name;
  final String lap;
  final int biaya;
  final int start;
  final int finish;
  final DateTime batas;
  bool bayar = false;
  DataOrderModel(
      this.uid, this.lap, this.biaya, this.start, this.finish, this.batas,
      {this.bayar = false});
}
