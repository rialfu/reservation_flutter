class TimePesanModel {
  final int start;
  final int finish;
  final String ket;
  bool canOrder = true;
  bool choose = false;
  final List<String> lapUsed = [];
  final List<String> listIdPesanan = [];

  TimePesanModel(this.start, this.finish, this.ket,
      {this.canOrder = true, this.choose = false});

  Map<String, dynamic> toJson() => {
        'start': start,
        'finish': finish,
        'ket': ket,
        'canOrder': canOrder,
        'choose': choose,
        'lapUsed': this.lapUsed
      };
  void delAllLapUsed() => this.lapUsed.clear();

  void addLapUsed(String value) => this.lapUsed.add(value);

  void delLapUsed(String val) => this.lapUsed.remove(val);

  String? getDifferent({int jumlah = 2}) {
    List lap = jumlah == 2 ? ['a', 'b'] : ['a', 'b', 'c'];
    var a = lap.where((val) => !this.lapUsed.contains(val));
    if (a.isEmpty) {
      return null;
    } else {
      return a.toList()[0];
    }
  }
}
