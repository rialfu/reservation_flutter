import 'package:url_launcher/url_launcher.dart';

class OpenApp {
  static Future<void> whatsapp(String id, String hari) async {
    try {
      String phone = "628111124799";
      // String phone = '6282210935688';
      // var phone = "6281318313342";
      String message = 'No Booking:' + id + ' pada ' + hari;
      message += 'telah bayar dengan bukti dibawah ini:';
      // String message =
      //     'No booking:$id pada $hari telah bayar dengan bukti dibawah ini:';
      var whatsappURlAndroid =
          "whatsapp://send?phone=$phone&text=${Uri.encodeFull(message)}";
      if (await canLaunch(whatsappURlAndroid)) {
        await launch(whatsappURlAndroid);
        return;
      } else {
        throw 'whatsapp not installed';
      }
    } catch (e) {
      if (e.runtimeType == String) throw e;
      throw 'Mohon maaf terjadi kesalahan, silahkan coba lagi nanti';
    }
  }
}
