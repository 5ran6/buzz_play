import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomePopularAlbums.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomeRecommendedAlbum.dart';
import 'package:buzz_play/ui/albumdetails/AlbumScreen.dart';
import 'package:buzz_play/utils/AppConfig.dart';
import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';
import 'package:buzz_play/fetchdataapi/NetwrokUtils.dart';
import 'package:buzz_play/ui/musicplayer/Nowplayingmusic.dart';
import 'package:buzz_play/utils/AppConfig.dart';
import 'package:buzz_play/utils/Dialogs.dart';

import '../../fetchdataapi/Model/myprofilemodel/Favourite_artist.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'EasyListView Demo',
    theme: ThemeData(accentColor: Colors.pinkAccent),
    home: AllAlbumsList(),
  );
}

class AllAlbumsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AllAlbumsListState();
}

class AllAlbumsListState extends State<AllAlbumsList> {
  AppConfig _appConfig;
  TextStyle boldtextStyle;
  NetworkUtil networkUtil;
  TextStyle regulartextstyle;
  List<HomePopularAlbumsItem> homerecalbumlist = new List();
  TextStyle countmusiccountstyle;

  TextStyle regular2textstyle;

  TextStyle unselectd;
  TextStyle chiptextstyle;
  TextStyle recnttexttitle;

  TextStyle recnttextview;
  var itemCount = 10;
  var hasNextPage = false;
  var foregroundWidget = Container(
      alignment: AlignmentDirectional.center,
      child: CircularProgressIndicator());
  ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    Timer(Duration(milliseconds: 3000),
            () => setState(() => foregroundWidget = null));
    networkUtil = new NetworkUtil();


    getrecdalbumlist();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void getrecdalbumlist() async {


    print("user id"+NetworkUtil.userid);

    await networkUtil.getall_album(NetworkUtil.userid).then((value) {});
    homerecalbumlist = HomePopularAlbums.homepopalbumlist;

    setState(() {
//      print(homelistcompnet[0].home_components_name);
    });
  }
  @override
  Widget build(BuildContext context) {
    _appConfig = new AppConfig(context);


    boldtextStyle = TextStyle(
        fontSize: _appConfig.rWP(5),
        fontWeight: FontWeight.w600,
        fontFamily: 'Montserrat');

    regulartextstyle = TextStyle(
        fontSize: _appConfig.rWP(1),
        fontWeight: FontWeight.w400,
        fontFamily: 'Montserrat');

    countmusiccountstyle = TextStyle(
      fontSize: _appConfig.rWP(3),
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
      color: Colors.black,
    );

    regular2textstyle = TextStyle(
        fontSize: _appConfig.rWP(4),
        fontWeight: FontWeight.w900,
        fontFamily: 'Montserrat');

    unselectd = TextStyle(
        fontSize: _appConfig.rWP(4),
        fontWeight: FontWeight.w900,
        color: Colors.grey,
        fontFamily: 'Montserrat');

    recnttexttitle = TextStyle(
        fontSize: _appConfig.rWP(4.3),
        fontWeight: FontWeight.bold,
        color: Color(0xff5d5d5d),
        fontFamily: 'Montserrat');


    chiptextstyle = TextStyle(
        fontSize: _appConfig.rWP(4.3),
        fontWeight: FontWeight.bold,
        color: Color(0xffffffff),
        fontFamily: 'Montserrat');

    return Scaffold(

      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'All Album',
                  style: TextStyle(
                      fontSize: _appConfig.rHP(3), color: Colors.black,fontFamily: 'Montserrat'),
                ),

              ],
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.black54),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.74
        ),
        physics: BouncingScrollPhysics(),

        controller: _controller,
        /* headerSliverBuilder: headerSliverBuilder,*/
//
//        footerBuilder: footerBuilder,
        itemCount: homerecalbumlist.length ,
        // 1 for custom scroll view example.
        itemBuilder: itemBuilder,

      ),
    );
  }
  onLoadMoreEvent() {
    print("onLoadMoreEvent");
    Timer(
      Duration(milliseconds: 2000),
          () => setState(() {
        itemCount += 10;
        hasNextPage = itemCount <= 30;
      }),
    );
  }

  Widget dividerBuilder(context, index) => Divider(
    color: Colors.grey,
    height: 1.0,
  );



  var footerBuilder = (context) => Container(
    color: Colors.green,
    height: 100.0,
    alignment: AlignmentDirectional.center,
    child: Text(
      "This is footer",
      style: TextStyle(
        fontSize: 24.0,
        color: Colors.white,
      ),
    ),
  );



  Widget itemBuilder  (context, index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new AlbumScreen(
                homerecalbumlist[index].album_name,
                homerecalbumlist[index].album_image,
                "Album",
                homerecalbumlist[index].album_id,
                homerecalbumlist[index].viewCount,
                homerecalbumlist[index].is_liked)));
      },
      child: Container(
          margin:
          EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),

          width: _appConfig.rWP(32),
          height: _appConfig.rHP(20),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.black38
                  )
              ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    NetworkUtil.BASE_URL1 +
                        homerecalbumlist[index].album_image,
                    height: _appConfig.rH(15),
                    width: _appConfig.rH(15),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Center(
                child: Text(
                  homerecalbumlist[index].album_name,
                  style: regular2textstyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  textWidthBasis: TextWidthBasis.longestLine,
                ),
              ),
            ],
          )
      ),
    );
  }






}