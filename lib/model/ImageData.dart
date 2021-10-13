class ImageData {
  final String id;
  final String title;
  final String tagtitle;
  final String image;
  ImageData(
      {required this.id,
      required this.title,
      required this.tagtitle,
      required this.image});
}

List<ImageData> imageList = [
  ImageData(
    id: 'A1',
    title: 'FUTSAL',
    tagtitle: 'Futsal',
    image: 'image/Futsal.png',
  ),
  ImageData(
    id: 'A2',
    title: 'Tenis Meja',
    tagtitle: 'Tenis Meja',
    image: 'image/Voli.png',
  ),
  // ImageData(
  //   id: 'A3',
  //   title: 'BASKET',
  //   tagtitle: 'Basket',
  //   image: 'image/Basket.png',
  // ),
  ImageData(
    id: 'A4',
    title: 'BADMINTON',
    tagtitle: 'Badminton',
    image: 'image/Badminton.png',
  ),
  // ImageData(
  //   id: 'A5',
  //   title: '3 in 1',
  //   tagtitle: '3 in 1',
  //   image: 'image/3in1.png',
  // ),
];
