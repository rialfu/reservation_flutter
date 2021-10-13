import 'package:flutter/material.dart';
import 'package:reservation/model/ImageData.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../template/Navdrawer.dart';
import '../screens/BookingScreen.dart';
import 'package:provider/provider.dart';
import 'package:reservation/services/UserRepository.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xff214C71),
      ),
      drawer: Navdrawer(),
      body: Stack(
        children: <Widget>[
          Container(
              height: double.infinity,
              width: double.infinity,
              color: const Color(0xFFF8F9EB)),
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xff214C71),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Selamat datang,',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 12,
                          color: const Color(0x69ffffff),
                          letterSpacing: 0.55,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Divider(
                        height: 15,
                        thickness: 0.5,
                        color: const Color(0xFF008BCE),
                        indent: 160,
                        endIndent: 160,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          '${user.userData?.name}',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 25,
                            color: const Color(0xfffdfef8),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(20),
                    itemCount: imageList.length,
                    itemBuilder: (context, index) => ImageCard(
                      imageData: imageList[index],
                      press: () {
                        final route = MaterialPageRoute(
                          builder: (context) =>
                              BookingScreen(title: imageList[index].title),
                        );
                        Navigator.of(context).push(route);
                      },
                    ),
                    staggeredTileBuilder: (index) =>
                        // StaggeredTile.count(2, index.isEven ? 2 : 1),
                        StaggeredTile.fit((index == 3) ? 2 : 1),
                    mainAxisSpacing: 19.0,
                    crossAxisSpacing: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  final ImageData imageData;
  final VoidCallback press;

  const ImageCard({
    Key? key,
    required this.imageData,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(10.0),
              elevation: 4.0,
              child: ClipRRect(
                child: Image.asset(imageData.image, fit: BoxFit.fitHeight),
              ),
            ),
            Text(
              imageData.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Oswald',
                fontSize: 28,
                color: const Color(0xffFFFFFF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
