class Order {
  String uid;
  String nama;
  String jam;
  String hari;
  bool status;
  Order.fromMap(Map snapshot, String id)
      : uid = id,
        nama = snapshot['nama'] ?? '',
        jam = snapshot['jam'] ?? '',
        hari = snapshot['hari'] ?? '',
        status = snapshot['status'] ?? false;
}
