import 'package:flutter/material.dart';
import 'package:reservation/services/UserRepository.dart';
import 'package:provider/provider.dart';
import 'package:reservation/screens/Home.dart';
import 'package:reservation/screens/Started.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Flutter Demo Home Page');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepository.instance(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
          Widget screen;
          switch (user.status) {
            case Status.Uninitialized:
              screen = pr();
              break;
            case Status.Unauthenticated:
            case Status.Authenticating:
              screen = Started();
              break;
            case Status.Authenticated:
              screen = Homescreen();
              break;
            default:
              screen = Container();
          }
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: screen,
          );
        },
      ),
    );
  }

  Widget pr() {
    return Scaffold(
      body: Container(
          child: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }
}
