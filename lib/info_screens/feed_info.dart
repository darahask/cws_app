import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FeedInfo extends StatefulWidget {
  @override
  _FeedInfoState createState() => _FeedInfoState();
}

class _FeedInfoState extends State<FeedInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            CarouselSlider(
              scrollDirection: Axis.horizontal,
              viewportFraction: 0.9,
              aspectRatio: 16 / 9,
              initialPage: 0,
              height: MediaQuery.of(context).size.height * 0.5,
              items: <Widget>[
                FeedItem(str: 'images/imgfeed1.png',),
                FeedItem(str: 'images/imgfeed2.png',),
                FeedItem(str: 'images/rsz_2p1.png',),
              ],
              autoPlay: true,
              pauseAutoPlayOnTouch: Duration(seconds: 2),
              enlargeCenterPage: true,
            ),
            SizedBox(height: 10,),
            Image(
            image: AssetImage('images/rsz_p2.png',),
            fit: BoxFit.fill,
          ),
          ],
        ),
      ),
    );
  }
}

class FeedItem extends StatelessWidget {
  final String str;
  FeedItem({this.str});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Image(
                image: AssetImage(str),
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(10),
                right: Radius.circular(10),
              ),
              gradient: LinearGradient(
                colors: [Color(0xff09a5e0), Color(0xff034198)],
              ),
            ),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Get in touch with us...',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              Icon(
                Icons.message,
                color: Colors.white,
              ),
            ],
              ),
              ),
          ],
        ),
      ),
    );
  }
}