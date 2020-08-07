import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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
    home: AllSongsList(),
  );
}

class AllSongsList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AllSongsListState();
}

class AllSongsListState extends State<AllSongsList> {
  AppConfig _appConfig;
  TextStyle boldtextStyle;
  NetworkUtil networkUtil;
  TextStyle regulartextstyle;

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
  List<Recentplay> recetplay = new List();
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    Timer(Duration(milliseconds: 3000),
            () => setState(() => foregroundWidget = null));
    networkUtil = new NetworkUtil();


    getrecentplaylist();
  }
  List<FavouriteartistItem> favlistartists = new List();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void getrecentplaylist() async {
    await networkUtil.getall_music(NetworkUtil.userid).then((value) {});
    recetplay = RecentplayList.RecentPlayLIst;
    setState(() {
      print(recetplay[0].music_file);
    });
  }
  void getfavartist() async {
    await networkUtil.favoriteartist(NetworkUtil.userid).then((value) {});
    favlistartists = Favouriteartist.RecentPlayLIst;
    setState(() {
      print(favlistartists[0].artist_image);
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
                  'All Songs',
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
      body: Container(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: _controller,
            /* headerSliverBuilder: headerSliverBuilder,*/
//
//        footerBuilder: footerBuilder,
            itemCount: recetplay.length ,
            // 1 for custom scroll view example.
            itemBuilder: itemBuilder,

          ),
        ),
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



  Widget itemBuilder  (context, pos) {
  return  GestureDetector(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) =>
            new NowPlaying(recetplay, pos, 1)));
      },
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 15, 10),
              child: Container(
                width: _appConfig.rH(6),
                height: _appConfig.rH(6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    NetworkUtil.BASE_URL1 +
                        recetplay[pos].music_image,
                    height: _appConfig.rH(6),
                    width: _appConfig.rH(6),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                        width: _appConfig.rW(53),
                        child: Text(
                          recetplay[pos].music_title,
                          style: recnttexttitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          textWidthBasis: TextWidthBasis.longestLine,
                        )),
                    Container(
                      width: _appConfig.rW(20),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          recetplay[pos].is_liked == 0
                              ? Container(
                            margin: EdgeInsets.fromLTRB(
                                15, 0, 0, 0),
                            width: _appConfig.rW(8),
                            child: GestureDetector(
                              onTap: () {
                                likesong(
                                    "1",
                                    "Music",
                                    recetplay[pos]
                                        .music_id);
                                recetplay[pos].is_liked = 1;
                                print("jhjdhhdj");
                              },
                              child: Image.asset(
                                "assets/image/profile/favorite_unpressed.png",
                                height: 22,
                                width: 22,
                              ),
                            ),
                          )
                              : Container(
                            margin: EdgeInsets.fromLTRB(
                                15, 0, 0, 0),
                            width: _appConfig.rW(8),
                            child: GestureDetector(
                              onTap: () {
                                unlikesong(
                                    "1",
                                    "Music",
                                    recetplay[pos]
                                        .music_id);
                                recetplay[pos].is_liked = 0;

                                print("jhjdhhdj");
                              },
                              child: Image.asset(
                                "assets/image/profile/favorite_pressed.png",
                                height: 22,
                                width: 22,
                              ),
                            ),
                          ),
                          Container(
                            margin:
                            EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Text(
                              recetplay[pos]
                                  .like_count
                                  .toString(),
                              style: recnttextview,
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,

                              textWidthBasis: TextWidthBasis.longestLine,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /* Container(
                                    width: _appConfig.rW(6),
                    alignment: FractionalOffset.center,
                                    child: Image.asset(

                                      "assets/image/profile/add.png",
                                      height: 22,
                                      width: 22,

                                    ),
                                  )*/
                  ],
                ),
                recetplay[pos].album_name == ""
                    ? Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
                  width: _appConfig.rW(60),
                  child: Text(
                    recetplay[pos].artistlist.length == 0?"": recetplay[pos]
                        .artistlist[0]
                        .artist_name,
                    style: recnttextview,
                    overflow: TextOverflow.ellipsis,

                    textWidthBasis: TextWidthBasis.longestLine,
                    maxLines: 1,
                  ),
                )
                    : recetplay[pos].artistlist.length == 0
                    ? Container(
                  margin:
                  EdgeInsets.fromLTRB(0, 5, 0, 15),
                  width: _appConfig.rW(60),
                  child: Text(
                    recetplay[pos].album_name,
                    style: recnttextview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                )
                    : Container(
                  margin:
                  EdgeInsets.fromLTRB(0, 5, 0, 15),
                  width: _appConfig.rW(60),
                  child: Text(
                    recetplay[pos].album_name +
                        " - " +
                        recetplay[pos]
                            .artistlist[0]
                            .artist_name,
                    style: recnttextview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  /*var headerSliverBuilder = (context, _) => [
    SliverAppBar(
      expandedHeight: 120.0,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          child: Text(
            "Sliver App Bar",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    ),
  ];*/
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  Future likesong(String user_id, String type, String music_id) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    await networkUtil.islike(user_id, type, music_id);
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    getrecentplaylist();
    getfavartist();
    setState(() {});
  }

  Future unlikesong(String user_id, String type, String music_id) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    await networkUtil.isunlike(user_id, type, music_id);
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    getrecentplaylist();
    getfavartist();
    setState(() {});
  }

}