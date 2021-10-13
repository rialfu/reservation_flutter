import 'package:flutter/material.dart';
import '../screens/DaftarBookingScreen.dart';
import 'package:reservation/screens/MyBookingListScreen.dart';
// import 'package:flutter_app/extensions/StringManipulation.dart';
import 'package:reservation/services/UserRepository.dart';
import 'package:provider/provider.dart';

class Navdrawer extends StatelessWidget {
  // final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    // String name = user == null ? 'R' : user.name;
    // String email = user == null ? 'R' : user.email;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey[800],
            ),
            accountEmail: Text(''),
            accountName: Text(user.userData?.name ?? ''),
            currentAccountPicture: CircleAvatar(
              child: Text(user.userData?.name ?? ''),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              // var route = MaterialPageRoute(builder: (context) => Homescreen());
              // Navigator.push(context, route);
              // Navigator.pushReplacement(context, mp);
            },
          ),
          ListTile(
            leading: Icon(Icons.schedule),
            title: Text("Jadwal"),
            onTap: () {
              var route = MaterialPageRoute(
                  builder: (context) => DaftarBookingScreen());

              Navigator.push(context, route);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("My Booking"),
            onTap: () {
              var route = MaterialPageRoute(
                  builder: (context) => MyBookingListScreen());

              Navigator.push(context, route);
            },
          ),
          ListTile(
            leading: Icon(Icons.warning),
            title: Text("Tata Tertib"),
            onTap: () {
              print("Tata Tertib Clicked");
            },
          ),
          ListTile(
            leading: Icon(Icons.dangerous),
            title: Text("Logout"),
            onTap: () => user.signOut(),
          ),
        ],
      ),
    );
  }
}
