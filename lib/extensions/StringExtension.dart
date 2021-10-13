import 'dart:math';

extension StringExtension on String {
  String get firstChar => '${this[0].toUpperCase()}${this.substring(1)}';
  String get onlyfirstChar => this.split(' ')[0].toLowerCase();
  String get capFirstofEach =>
      this.split(" ").map((str) => str.firstChar).join(" ");
  String get singkatan =>
      this.split(" ").map((str) => str[0].toUpperCase()).join('');
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

class StringMa {
  static String randomString({int len = 10}) {
    String _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    var r = Random();
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }
}
