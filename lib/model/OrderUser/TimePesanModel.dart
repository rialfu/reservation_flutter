import 'PesananModel.dart';
import 'OrderModel.dart';

class TimePesanModel {
  final int start;
  final int finish;
  final String ket;
  bool canOrder = true;
  bool choose = false;
  List<PesananModel> pesanan = [];
  List<OrderModel> orders = [];

  TimePesanModel(this.start, this.finish, this.ket);

  static String makeKet(int start, int end) {
    String startText = (start == 24 ? 0 : start).toString().padLeft(2, '0');
    String finishText = (end > 23 ? end - 24 : end).toString().padLeft(2, '0');
    return startText + '.00 - ' + finishText + '.00';
  }
}
