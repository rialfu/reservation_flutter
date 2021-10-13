import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation/services/UserRepository.dart';
import '../../model/Paket/PaketModel.dart';
import '../../model/OrderUser/TimePesanModel.dart';
import '../../model/OrderUser/OrderModel.dart';

class TableWidget extends StatelessWidget {
  final PaketModel paket;
  final List<TimePesanModel> listTime;
  final List<OrderModel> orders;
  final Function event;
  TableWidget({
    required this.paket,
    required this.listTime,
    required this.orders,
    required this.event,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 36,
      child: Column(
        children: [
          //Table Header
          tableHeader(),
          //Table Content
          tableContent(context),
        ],
      ),
    );
  }

  Widget tableHeader() {
    final border = BorderSide(width: 1);
    List<String> listLap = this.paket.listLap;
    if (listLap.isEmpty) listLap = ['A', 'B', 'C'];
    final tb = TableBorder(
      top: border,
      left: border,
      right: border,
      verticalInside: border,
    );
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 20),
            Table(
              border: tb,
              children: [
                TableRow(
                  children: List.generate(
                    listLap.length,
                    (index) {
                      return Container(height: 30, color: Colors.grey.shade300);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        Table(
          children: [
            TableRow(
              children: List.generate(
                listLap.length,
                (index) {
                  return eachRowTableHeader(listLap[index]);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget eachRowTableHeader(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: Colors.black,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(right: 10, left: 10),
            height: 35,
            // width: 50,
            child: Center(
              child: Text(
                text,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color filterColor(bool admin, List<OrderModel> data, String idUser) {
    if (data.isNotEmpty) {
      if (data.where((e) => e.userId == idUser).isNotEmpty) return Colors.green;
      bool dpbought = data.where((e) => e.dp == false).isEmpty;
      if (admin && !dpbought) return Colors.red;
      if (dpbought) return Colors.grey.shade600;
    }
    return Colors.white;
  }

  Widget tableContent(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    bool admin = user.userData?.admin ?? false;
    double fontSize = 18, padding = 10;
    String lap = '', uid = user.user?.uid ?? '';
    List<String> listLap = this.paket.listLap;
    if (listLap.isEmpty) listLap = ['A', 'B', 'C'];
    List<TimePesanModel> tpm = this.listTime;
    int length = tpm.length, lenLap = listLap.length;
    int start, finish;
    Color? color;
    return Table(
      border: TableBorder.all(width: 1),
      children: List.generate(
        length,
        (iTPM) {
          return TableRow(
            children: List.generate(
              lenLap,
              (iLap) {
                start = tpm[iTPM].start;
                finish = tpm[iTPM].finish;
                lap = listLap[iLap];
                List<OrderModel> data = OrderModel.findWithTimeAndLap(
                  start,
                  finish,
                  this.orders,
                  lap: lap,
                );
                color = filterColor(admin, data, uid);
                return GestureDetector(
                  onTap: () =>
                      data.isEmpty || admin == false ? null : this.event(data),
                  child: Container(
                    color: color,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: padding),
                      child: Container(
                        child: Center(
                          child: Text(
                            this.listTime[iTPM].ket,
                            style: TextStyle(fontSize: fontSize),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
// class TableWidget extends StatefulWidget {
//   final PaketModel paket;
//   final List<TimePesanModel> listTime;
//   final List<OrderModel> orders;
//   final Function event;
//   TableWidget({
//     required this.paket,
//     required this.listTime,
//     required this.orders,
//     required this.event,
//   });
//   @override
//   _TableWidgetState createState() => _TableWidgetState();
// }

// class _TableWidgetState extends State<TableWidget> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> open(
//       BuildContext context, List<OrderModel> orders, String lap) async {
//     final route = MaterialPageRoute(
//       builder: (context) => BookingListScreen(orders),
//     );
//     final a = await Navigator.of(context).push(route);
//     print(a);
//     // orders.forEach((element) {
//     //   print(element.id);
//     //   element.listPesanan.forEach((el) {
//     //     print(el.start);
//     //   });
//     //   // print();
//     // });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       width: size.width - 36,
//       child: Column(
//         children: [
//           //Table Header
//           tableHeader(),
//           //Table Content
//           tableContent(),
//         ],
//       ),
//     );
//   }

//   Widget tableHeader() {
//     final border = BorderSide(width: 1);
//     List<String> listLap = widget.paket.listLap;
//     if (listLap.isEmpty) listLap = ['A', 'B', 'C'];
//     final tb = TableBorder(
//       top: border,
//       left: border,
//       right: border,
//       verticalInside: border,
//     );
//     return Stack(
//       children: [
//         Column(
//           children: [
//             SizedBox(height: 20),
//             Table(
//               border: tb,
//               children: [
//                 TableRow(
//                   children: List.generate(
//                     listLap.length,
//                     (index) {
//                       return Container(height: 30, color: Colors.grey.shade300);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Table(
//           children: [
//             TableRow(
//               children: List.generate(
//                 listLap.length,
//                 (index) {
//                   return eachRowTableHeader(listLap[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget eachRowTableHeader(String text) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//             side: BorderSide(
//               color: Colors.black,
//             ),
//           ),
//           child: Container(
//             padding: EdgeInsets.only(right: 10, left: 10),
//             height: 35,
//             // width: 50,
//             child: Center(
//               child: Text(
//                 text,
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//   // bool findLap(){

//   // }
//   Widget tableContent() {
//     double fontSize = 18, padding = 10;
//     String lap = '';
//     List<String> listLap = widget.paket.listLap;
//     List<TimePesanModel> tpm = widget.listTime;
//     int length = tpm.length, lenLap = listLap.length, start, finish;
//     if (listLap.isEmpty) listLap = ['A', 'B', 'C'];
//     final user = Provider.of<UserRepository>(context);
//     var color;
//     return Table(
//       border: TableBorder.all(width: 1),
//       children: List.generate(
//         length,
//         (index) {
//           return TableRow(
//             children: List.generate(
//               lenLap,
//               (i) {
//                 start = tpm[index].start;
//                 finish = tpm[index].finish;
//                 lap = listLap[i];
//                 List<OrderModel> orders = OrderModel.findWithTimeAndLap(
//                   start,
//                   finish,
//                   widget.orders,
//                   lap: lap,
//                 );
//                 if (orders.where((e) => e.userId == user.user?.uid).isNotEmpty)
//                   color = Colors.green[300];
//                 else if (orders.isNotEmpty)
//                   color = Colors.grey[300];
//                 else
//                   color = Colors.white;
//                 return GestureDetector(
//                   onTap: () => open(context, orders, listLap[i]),
//                   child: Container(
//                     color: color,
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: padding),
//                       child: Container(
//                         child: Center(
//                           child: Text(
//                             widget.listTime[index].ket,
//                             style: TextStyle(fontSize: fontSize),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
