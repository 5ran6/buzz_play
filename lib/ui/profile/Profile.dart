import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';
import 'package:buzz_play/fetchdataapi/Model/myprofilemodel/Favourite_artist.dart';
import 'package:buzz_play/fetchdataapi/Model/myprofilemodel/MyownFavalbum.dart';
import 'package:buzz_play/fetchdataapi/Model/myprofilemodel/MyownFavmusic.dart';
import 'package:buzz_play/fetchdataapi/Model/myprofilemodel/Myownplaylist.dart';
import 'package:buzz_play/fetchdataapi/NetwrokUtils.dart';
import 'package:buzz_play/ui/albumdetails/AlbumScreen.dart';
import 'package:buzz_play/ui/musicplayer/Nowplayingmusic.dart';
import 'package:buzz_play/ui/viewlist/ViewListArtist.dart';
import 'package:buzz_play/utils/AppConfig.dart';
import 'package:buzz_play/utils/Dialogs.dart';
import 'package:buzz_play/theme.dart' as Theme;
import 'package:shared_preferences/shared_preferences.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MediaQuery Demo',
      theme: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
      ),
      home: new Profile(),
    );
  }
}

class Profile extends StatefulWidget  {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with WidgetsBindingObserver{
  AppConfig _appConfig;
  TextStyle boldtextStyle = TextStyle(
      fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Montserrat');

  TextStyle regulartextstyle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Montserrat');
  TextStyle regular2textstyle = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w900, fontFamily: 'Montserrat');
  TextStyle unselectd = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w900,
      color: Colors.grey,
      fontFamily: 'Montserrat');

  TextStyle recnttexttitle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xff5d5d5d),
      fontFamily: 'Montserrat');

  TextStyle recnttextview = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color(0xffD1D1D1),
      fontFamily: 'Montserrat');

  bool issongselectd = false;
  NetworkUtil networkUtil;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    networkUtil = new NetworkUtil();
    getrecentplaylist();
    getownplaylist();
    getfavmusiclist();
    getfavalbumlist();
    getfavartist();







  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  bool isrecentloading = true;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  List<Recentplay> recetplay = new List();

  List<USerplaylistItem> userplaylist = new List();

  void getownplaylist() async {
    //  Dialogs.showLoadingDialog(context, _keyLoader);//inv
    await networkUtil.ownplaylist(NetworkUtil.userid).then((value) {
//      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
//          .pop();
    });
//    registers=NetworkUtil.rregisters;
    userplaylist = USerplaylist.userplaylistLIst;
    isrecentloading = false;
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    setState(() {
      print(userplaylist[0].user_playlist_name);
    });
  }

  void getrecentplaylist() async {
    //  Dialogs.showLoadingDialog(context, _keyLoader);//inv
    await networkUtil.recentplay(NetworkUtil.userid).then((value) {
//      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
//          .pop();
    });
//    registers=NetworkUtil.rregisters;
    recetplay = RecentplayList.RecentPlayLIst;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    username=prefs.getString("name");
    imgurl=prefs.getString("userprfpic");

    isrecentloading = false;

    setState(() {
      print(recetplay[0].music_file);
    });
  }

  List<Recentplay> myownfavmusiclistLIst = new List();
  List<MyownfavalbumItem> myownfavalbumlistLIst = new List();

  void getfavmusiclist() async {
    //  Dialogs.showLoadingDialog(context, _keyLoader);//inv
    await networkUtil.myfavownmusic(NetworkUtil.userid).then((value) {
//      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
//          .pop();
    });
//    registers=NetworkUtil.rregisters;
    myownfavmusiclistLIst = Myownfavmusic.myownfavmusiclistLIst;
//    isrecentloading = false;
    setState(() {
      print(myownfavmusiclistLIst[0].music_file);
    });
  }

  List<FavouriteartistItem> favlistartists = new List();

  void getfavartist() async {
    //  Dialogs.showLoadingDialog(context, _keyLoader);//inv
    await networkUtil.favoriteartist(NetworkUtil.userid).then((value) {
//      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
//          .pop();
    });
//    registers=NetworkUtil.rregisters;
    favlistartists = Favouriteartist.RecentPlayLIst;
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

//    isrecentloading = false;
    setState(() {
      print(favlistartists[0].artist_image);
    });
  }

  void getfavalbumlist() async {
    //  Dialogs.showLoadingDialog(context, _keyLoader);//inv
    await networkUtil.myfavowalbum(NetworkUtil.userid).then((value) {
//      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
//          .pop();
    });
//    registers=NetworkUtil.rregisters;
    myownfavalbumlistLIst = Myownfavalbum.myownfavmusiclistLIst;
    isrecentloading = false;
    setState(() {
      print(myownfavalbumlistLIst[0].album_name);
    });
  }


  @override
  Widget build(BuildContext context) {
    _appConfig = new AppConfig(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              color: Color(0xffF6F6F6),
              height: _appConfig.rHP(30),
              width: double.infinity,
              child: Image.asset(
                "assets/image/profile/profile_banner.png",
                fit: BoxFit.fill,
              ),
            ),
            ListView.builder(
              itemCount: 9,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: _mainListBuilder,
            ),
            Positioned(
              top: 40,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, false);
                },
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textswapping() {
    return issongselectd
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: _appConfig.rW(20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      issongselectd = true;
                    });
                  },
                  child: Container(
                    child: issongselectd
                        ? Container(
                            child: Text(
                              "Song",
                              style: regular2textstyle,
                            ),
                          )
                        : Container(
                            child: Text(
                              "Song",
                              style: unselectd,
                            ),
                          ),
                  ),
                ),
              ),
              Container(
                width: _appConfig.rW(20),
                child: GestureDetector(
                  onTap: () {
                    issongselectd = false;
                    print("jshjshjsjd" + issongselectd.toString());
                  },
                  child: Container(
                    child: issongselectd
                        ? Container(
                            child: Text(
                              "alubm",
                              style: unselectd,
                            ),
                          )
                        : Container(
                            child: Text(
                              "alubm",
                              style: regular2textstyle,
                            ),
                          ),
                  ),
                ),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                width: _appConfig.rW(20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      issongselectd = true;
                    });
                  },
                  child: Container(
                    child: issongselectd
                        ? Container(
                            child: Text(
                              "Song",
                              style: regular2textstyle,
                            ),
                          )
                        : Container(
                            child: Text(
                              "Song",
                              style: unselectd,
                            ),
                          ),
                  ),
                ),
              ),
              Container(
                width: _appConfig.rW(20),
                child: GestureDetector(
                  onTap: () {
                    issongselectd = false;
                    print("jshjshjsjd" + issongselectd.toString());
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                    child: issongselectd
                        ? Container(
                            child: Text(
                              "Album",
                              style: unselectd,
                            ),
                          )
                        : Container(
                            child: Text(
                              "alubm",
                              style: regular2textstyle,
                            ),
                          ),
                  ),
                ),
              )
            ],
          );
  }

  Widget _mainListBuilder(BuildContext context, int index) {
    if (index == 0) return _buildHeader(context);
    if (index == 1) return _buildSectionHeader(context);
    if (index == 2) return _buildCollectionsRow();
    if (index == 3) return favlisttitle();
    if (index == 4)
      return issongselectd ? _buildListItemsong() : _buildListItemalbum();
    if (index == 5) return recntplaytitle();
    if (index == 6) return recentplylist();
    if (index == 7) return favlistartisttitle();
    if (index == 8) return favlist();
  }

  Widget favlisttitle() {
    return Container(
      padding: EdgeInsets.only(left: 5.0, top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: _appConfig.rW(50),
            child: Row(
              children: <Widget>[
                Container(
                  child: Image.asset(
                    "assets/image/profile/ic_favorite.png",
                    height: 50,
                    width: 50,
                  ),
                ),
                /* SizedBox(width: 10,),*/
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Favorite",
                    style: boldtextStyle,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: _appConfig.rW(46),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: GestureDetector(
                    onTap: () {
                      issongselectd = true;
                      setState(() {});
                    },
                    child: Container(
                      child: issongselectd
                          ? Container(
                              child: Text(
                                "Song",
                                style: regular2textstyle,
                              ),
                            )
                          : Container(
                              child: Text(
                                "Song",
                                style: unselectd,
                              ),
                            ),
                    ),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      issongselectd = false;
                      print("jshjshjsjd" + issongselectd.toString());
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
                      child: issongselectd
                          ? Container(
                              child: Text(
                                "Album",
                                style: unselectd,
                              ),
                            )
                          : Container(
                              child: Text(
                                "Album",
                                style: regular2textstyle,
                              ),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container favlist() {
    return Container(
      height: 200.0,
      padding: EdgeInsets.symmetric(horizontal: 1.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: favlistartists.length,
        itemBuilder: (BuildContext context, int index) {
          return favlistartist(index);
        },
      ),
    );
  }

  Widget favlistartist(int pos) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new AlbumScreen(
                favlistartists[pos].artist_name,
                favlistartists[pos].artist_image,
                "Artist",
                favlistartists[pos].artist_id,
                favlistartists[pos].likedCount,
                favlistartists[pos].is_liked)));
      },
      child: Container(
        width: _appConfig.rW(35),
        height: _appConfig.rW(35),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                /*  Container(
                  width: _appConfig.rW(20),
                  height: _appConfig.rW(20),
                  child: Image.asset("assets/image/profile/ract6060.png"),
                ),*/

                Container(
                  margin: EdgeInsets.all(7),
                  height: _appConfig.rW(22),
                  width: _appConfig.rW(22),
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(NetworkUtil.BASE_URL1 +
                              favlistartists[pos].artist_image))),
                ),
                Container(
                  width: _appConfig.rW(27),
                  height: _appConfig.rW(27),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: _appConfig.rW(10),
                        width: _appConfig.rW(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 2.0, color: const Color(0xffF6F6F6)),
                          // Box decoration takes a gradient
                          gradient: LinearGradient(
                            // Where the linear gradient begins and ends
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            // Add one stop for each color. Stops should increase from 0 to 1
                            stops: [0.0, 1.0],
                            colors: [
                              // Colors are easy thanks to Flutter's Colors class.
                              const Color(0xFF4F8BF1),
                              const Color(0xFF995CE4),
                            ],
                          ),
                        ),
                        child: Center(
                            child: Text(
                          favlistartists[pos].likedCount,
                          style: recnttextview,
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Container(
                    width: _appConfig.rW(22),
                    child: Text(
                      favlistartists[pos].artist_name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                          wordSpacing: 0.1,
                          fontFamily: 'Montserrat'),
                      maxLines: 1,
                    ),
                  ),
                ),
                Container(
                  width: _appConfig.rW(8),
                  child: favlistartists[pos].is_liked == 0
                      ? Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              likesong(
                                  NetworkUtil.userid, "Artist", favlistartists[pos].artist_id);
//                      favlistartists[pos].is_liked=1;
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
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          width: _appConfig.rW(8),
                          child: GestureDetector(
                            onTap: () {
                              unlikesong(
                                  NetworkUtil.userid, "Artist", favlistartists[pos].artist_id);
//                      favlistartists[pos].is_liked=0;

                              print("jhjdhhdj");
                            },
                            child: Image.asset(
                              "assets/image/profile/favorite_pressed.png",
                              height: 22,
                              width: 22,
                            ),
                          ),
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListItemalbum() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
      width: double.infinity,
      height: 150,
      child: Container(
        width: double.infinity,
        child: new StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          scrollDirection: Axis.horizontal,
          itemCount: myownfavalbumlistLIst.length + 1,
          itemBuilder: (BuildContext context, int index) => index != 0
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new AlbumScreen(
                            myownfavalbumlistLIst[index - 1].album_name,
                            myownfavalbumlistLIst[index - 1].album_image,
                            "Album",
                            myownfavalbumlistLIst[index - 1].album_id,
                            myownfavalbumlistLIst[index - 1].likedCount,
                            myownfavalbumlistLIst[index - 1].is_liked)));
                  },
                  child: Container(
                    height: _appConfig.rH(6),
                    width: _appConfig.rH(15),
                    child: GestureDetector(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                NetworkUtil.BASE_URL1 +
                                    myownfavalbumlistLIst[index - 1]
                                        .album_image,
                                height: _appConfig.rH(6),
                                width: _appConfig.rH(6),
                                fit: BoxFit.cover,
                              ),
                            )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Container(
                                  width: 100,
                                  child: Text(
                                    myownfavalbumlistLIst[index - 1].album_name,
                                    maxLines: 2,
                                    style: regulartextstyle,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              : Container(
                  child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                            new NowPlaying(myownfavmusiclistLIst, 0, 1)));
                  },
                  child: Image.asset(
                    "assets/image/profile/all_play.png",
                    fit: BoxFit.fitHeight,
                    height: 200,
                  ),
                )),
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(index == 0 ? 11 : 2, index == 0 ? 4 : 5),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
    );
  }

  Widget _buildListItemsong() {
    return Container(
      padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
      width: double.infinity,
      height: 150,
      child: Container(
        width: double.infinity,
        child: new StaggeredGridView.countBuilder(
          crossAxisCount: 4,
          scrollDirection: Axis.horizontal,
          itemCount: myownfavmusiclistLIst.length + 1,
          itemBuilder: (BuildContext context, int index) => index != 0
              ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new NowPlaying(
                            myownfavmusiclistLIst, index - 1, 1)));
                  },

                  ///
                  ///
                  ///
                  ///
                  ///

                  child: Container(
                    height: _appConfig.rH(6),
                    width: _appConfig.rH(15),
                    child: GestureDetector(
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                NetworkUtil.BASE_URL1 +
                                    myownfavmusiclistLIst[index - 1]
                                        .music_image,
                                height: _appConfig.rH(6),
                                width: _appConfig.rH(6),
                                fit: BoxFit.cover,
                              ),
                            )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Container(
                                  width: 100,
                                  child: Text(
                                    myownfavmusiclistLIst[index - 1]
                                        .music_title,
                                    maxLines: 2,
                                    style: regulartextstyle,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              : Container(
                  child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                            new NowPlaying(myownfavmusiclistLIst, 0, 1)));
                  },
                  child: Image.asset(
                    "assets/image/profile/all_play.png",
                    fit: BoxFit.fitHeight,
                    height: 200,
                  ),
                )),
          staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(index == 0 ? 11 : 2, index == 0 ? 4 : 5),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
    );
  }

  Widget recntplaytitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child:
                      Image.asset('assets/image/profile/ic_recent_played.png'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Recent Played",
                    style: boldtextStyle,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new NowPlaying(recetplay, 0, 1)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: Text(
                      "Play all",
                      style: unselectd,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /*   FlatButton(
            onPressed: (){},
            child: Text("Create new", style: TextStyle(color: Colors.blue),),
          )*/
        ],
      ),
    );
  }

  Widget favlistartisttitle() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child: Image.asset(
                      'assets/image/profile/ic_favorite_artists.png'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Favourite Artists",
                    style: boldtextStyle,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new ViewListArtist()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: Text(
                      "See all",
                      style: unselectd,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /*   FlatButton(
            onPressed: (){},
            child: Text("Create new", style: TextStyle(color: Colors.blue),),
          )*/
        ],
      ),
    );
  }

  Widget recentplylist() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recetplay.length,
          itemBuilder: (BuildContext context, int pos) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) => new NowPlaying(recetplay, pos, 1)));
              },
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            width: _appConfig.rW(66),
                            child: Text(
                              recetplay[pos].music_title,
                              style: recnttexttitle,
                              maxLines: 1,
                            )),
                        Container(
                          width: _appConfig.rW(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              recetplay[pos].is_liked == 0
                                  ? Container(
                                      margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child: GestureDetector(
                                        onTap: () {
                                          likesong(NetworkUtil.userid, "Music",
                                              recetplay[pos].music_id);
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
                                      margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      width: _appConfig.rW(8),
                                      child: GestureDetector(
                                        onTap: () {
                                          unlikesong(NetworkUtil.userid, "Music",
                                              recetplay[pos].music_id);
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
                                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text(
                                  recetplay[pos].like_count.toString(),
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
                              recetplay[pos].artistlist[0].artist_name,
                              style: recnttextview,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textWidthBasis: TextWidthBasis.longestLine,
                            ),
                          )
                        : recetplay[pos].artistlist.length == 0
                            ? Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
                                width: _appConfig.rW(60),
                                child: Text(
                                  recetplay[pos].album_name,
                                  style: recnttextview,
                                  overflow: TextOverflow.ellipsis,
                                  textWidthBasis: TextWidthBasis.longestLine,
                                  maxLines: 1,
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.fromLTRB(0, 5, 0, 15),
                                width: _appConfig.rW(60),
                                child: Text(
                                  recetplay[pos].album_name +
                                      " - " +
                                      recetplay[pos].artistlist[0].artist_name,
                                  style: recnttextview,
                                  overflow: TextOverflow.ellipsis,
                                  textWidthBasis: TextWidthBasis.longestLine,
                                  maxLines: 1,
                                ),
                              ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Container _buildSectionHeader(BuildContext context) {
    return  Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 50,
            width: 50,
            child: Image.asset('assets/image/profile/ic_own_playlist.png'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              "Own Playlist",
              style: boldtextStyle,
            ),
          ),
          /*   FlatButton(
            onPressed: (){},
            child: Text("Create new", style: TextStyle(color: Colors.blue),),
          )*/
        ],
      ),
    );
  }

  Container _buildCollectionsRow() {
    return Container(
      height: 200.0,
      padding: EdgeInsets.symmetric(horizontal: 1.0),
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: userplaylist.length==0?

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 150.0,
              height: 150.0,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: new LinearGradient(
                    colors: [
                      const Color(0xFF4F8BF1),
                      const Color(0xFF995CE4),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 1.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(7),
                        height: 60,
                        width: 60,
                        child: Image.asset('assets/image/profile/ic_music.png',
                            fit: BoxFit.fill),
                      ),
                      Container(
                        margin: EdgeInsets.all(7),
                        height: 60,
                        width: 60,
                        child: Image.asset('assets/image/profile/ic_music.png',
                            fit: BoxFit.fill),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(7),
                        height: 60,
                        width: 60,
                        child: Image.asset('assets/image/profile/ic_music.png',
                            fit: BoxFit.fill),
                      ),
                      Container(
                        margin: EdgeInsets.all(7),
                        height: 60,
                        width: 60,
                        child:
                        Image.asset('assets/image/profile/icon_play_white.png'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

               Padding(
                padding: const EdgeInsets.only(top:8.0,left: 10),
                child: Text(
                  "Create PlayList",
                  style: regulartextstyle,
                  overflow: TextOverflow.ellipsis,
                  textWidthBasis: TextWidthBasis.longestLine,
                ),

            )
          ],
        ) : ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: userplaylist.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                if (userplaylist[index].music_count == 0) {
                  Fluttertoast.showToast(
                      msg: "There is no Songs added",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1);
                } else {
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => new AlbumScreen(
                          userplaylist[index].user_playlist_name,
                          userplaylist[index].imagesslist[0].music_image,
                          "PlayList",
                          userplaylist[index].user_playlist_id,
                          userplaylist[index].music_count.toString(),
                          1)));
                }
              },

              onLongPress: () {
                showAlertDialog(context, userplaylist[index].user_playlist_id);
              },

              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                  width: 160.0,
                  height: 180.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      setimagplaylist(userplaylist[index].music_count, index),
                      SizedBox(
                        height: 5.0,
                      ),
                      userplaylist[index].user_playlist_name == null
                          ? Text("")
                          : Text(
                              userplaylist[index].user_playlist_name,
                              style: regulartextstyle,
                              overflow: TextOverflow.ellipsis,
                              textWidthBasis: TextWidthBasis.longestLine,
                            )
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
///  user profile
  Container _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _appConfig.rH(10)),
      child: Stack(
        children: <Widget>[
          Container(
            height: 130.0,
            width: _appConfig.rW(80),
            margin: EdgeInsets.only(
                top: 50.0, left: 40.0, right: 40.0, bottom: 0.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0))),
              elevation: 5.0,
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 80.0,
                  ),
                  Text(username,
                      style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Montserrat')),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                elevation: 5.0,
                shape: CircleBorder(),
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage:imgurl==""?AssetImage('assets/image/profile/img5.jpg'):NetworkImage(NetworkUtil.BASE_URL1+imgurl),
                ),
              ),
            ],
          ),
          Positioned(
            top: 70,
            left: 70,
            right: 0,
            child: GestureDetector(
              onTap: () {
                profile();
              },
              child: Image.asset(
                'assets/image/profile/ic_edit.png',
                width: 40,
                height: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
  TextEditingController _textFieldController = TextEditingController();

  Future profile() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            content: Container(
              height: _appConfig.rHP(50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Edit Name",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: _appConfig.rHP(2),
                  ),
                  TextField(
                    controller: _textFieldController,
                    decoration: InputDecoration(hintText: "TextField in Dialog"),
                  ),
                  SizedBox(
                    height: _appConfig.rHP(10),
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage:ischange?FileImage(_imageFile):
                      AssetImage('assets/image/profile/img5.jpg'),
                    ),
                  ),
                  SizedBox(
                    height: _appConfig.rHP(5),
                  ),
                  GestureDetector(
                    onTap: () {
                      /* Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new AllArtistList()));*/
                      _onImageButtonPressed(ImageSource.gallery);
                      ischange=true;
                    },
                    child: Center(
                      child: Container(
                        width: _appConfig.rWP(40),
                        height: _appConfig.rHP(6),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.all(Radius.circular(20)),
                          gradient: new LinearGradient(
                              colors: [
                                Theme.Colors.firstGradientStart,
                                Theme.Colors.firstGradientEnd
                              ],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 1.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Choose Image",
                                    style: TextStyle(
                                        fontSize: _appConfig.rWP(4),
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  'Save',
                  style: TextStyle(color: Colors.indigo),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  submit();
                },
              ),
              new FlatButton(
                child: new Text(
                  'Cancel',
                  style: TextStyle(color: Colors.indigo),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  File _imageFile;

  bool ischange=false;
  dynamic _pickImageError;
  void _onImageButtonPressed(ImageSource source) async {

    try {
      _imageFile = await ImagePicker.pickImage(source: source);

      setState(() {
        if(_imageFile!=null)
          _cropImage(_imageFile);
        print("shjsdhsagjwe"+_imageFile.path);
        ischange=true;
      });
    } catch (e) {
      _pickImageError = e;

    }
  }
  Future<Null> _cropImage(File imageFile) async {
    ischange=true;
    _imageFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,

        maxWidth: 512,
        maxHeight: 512,
        cropStyle: CropStyle.circle
    );

    a=baseencode();
    ischange=true;

    Navigator.pop(context);
    profile();
    setState(() {
    });
  }
  String a;
  void submit() async {
    print(a);
    if(_textFieldController.text=="")
      {
        _textFieldController.text=username;
      }
    Dialogs.showLoadingDialog(context, _keyLoader); //inv
    await networkUtil
        .edtprofile( NetworkUtil.userid,a,
        _textFieldController.text)
        .then((value) {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    });
    await _onChanged();

    username=NetworkUtil.rregisters.user_name;
    imgurl=NetworkUtil.rregisters.user_profile_pic;
    setState(() {
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    });
  }

  String  baseencode()
  {

    List<int> imageBytes = _imageFile.readAsBytesSync();
    return base64.encode(imageBytes);
  }

  SharedPreferences sharedPreferences;
  _onChanged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("setuserid",NetworkUtil.rregisters.user_id );
      sharedPreferences.setBool("isfirst", false);
      sharedPreferences.setString("name", NetworkUtil.rregisters.user_name);
      sharedPreferences.setString("email", NetworkUtil.rregisters.user_email);
      sharedPreferences.setString("userprfpic",NetworkUtil.rregisters.user_profile_pic);
      sharedPreferences.commit();

    });
  }
  String username="";
  String imgurl="";


  Widget setimagplaylist(int count, int pos) {
    if (count == 0) {
      return Container(
        width: 150.0,
        height: 150.0,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF4F8BF1),
                const Color(0xFF995CE4),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  child: Image.asset('assets/image/profile/ic_music.png',
                      fit: BoxFit.fill),
                ),
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  child: Image.asset('assets/image/profile/ic_music.png',
                      fit: BoxFit.fill),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  child: Image.asset('assets/image/profile/ic_music.png',
                      fit: BoxFit.fill),
                ),
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  child:
                      Image.asset('assets/image/profile/icon_play_white.png'),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (count == 1) {
      return Container(
        width: 150.0,
        height: 150.0,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF4F8BF1),
                const Color(0xFF995CE4),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(NetworkUtil.BASE_URL1 +
                              userplaylist[pos].imagesslist[0].music_image))),
                ),
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  child: Image.asset('assets/image/profile/ic_music.png',
                      fit: BoxFit.fill),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  child: Image.asset('assets/image/profile/ic_music.png',
                      fit: BoxFit.fill),
                ),
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  child:
                      Image.asset('assets/image/profile/icon_play_white.png'),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (count == 2) {
      return Container(
        width: 150.0,
        height: 150.0,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF4F8BF1),
                const Color(0xFF995CE4),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(NetworkUtil.BASE_URL1 +
                              userplaylist[pos].imagesslist[0].music_image))),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(NetworkUtil.BASE_URL1 +
                              userplaylist[pos].imagesslist[1].music_image))),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  child: Image.asset(
                    'assets/image/profile/ic_music.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  child:
                      Image.asset('assets/image/profile/icon_play_white.png'),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (count == 3) {
      return Container(
        width: 150.0,
        height: 150.0,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF4F8BF1),
                const Color(0xFF995CE4),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(NetworkUtil.BASE_URL1 +
                              userplaylist[pos].imagesslist[0].music_image))),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(NetworkUtil.BASE_URL1 +
                              userplaylist[pos].imagesslist[1].music_image))),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(NetworkUtil.BASE_URL1 +
                              userplaylist[pos].imagesslist[2].music_image))),
                ),
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  child:
                      Image.asset('assets/image/profile/icon_play_white.png'),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (count >= 4) {
      return Container(
        width: 150.0,
        height: 150.0,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: new LinearGradient(
              colors: [
                const Color(0xFF4F8BF1),
                const Color(0xFF995CE4),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(NetworkUtil.BASE_URL1 +
                              userplaylist[pos].imagesslist[0].music_image))),
                ),
                Container(
                  height: 60,
                  width: 60,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(NetworkUtil.BASE_URL1 +
                              userplaylist[pos].imagesslist[1].music_image))),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(NetworkUtil.BASE_URL1 +
                              userplaylist[pos].imagesslist[2].music_image))),
                ),
                Container(
                  margin: EdgeInsets.all(7),
                  height: 60,
                  width: 60,
                  child:
                      Image.asset('assets/image/profile/icon_play_white.png'),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }

  Future likesong(String user_id, String type, String music_id) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    await networkUtil.islike(user_id, type, music_id);
    getrecentplaylist();
    getfavartist();
    setState(() {});
  }

  Future unlikesong(String user_id, String type, String music_id) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    await networkUtil.isunlike(user_id, type, music_id);
    getrecentplaylist();
    getfavartist();
    setState(() {});
  }

  showAlertDialog(BuildContext context, String id) {
    // set up the buttons

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("are you sure delete this playlist?"),
      actions: [
        FlatButton(
          child: Text("Confirm"),
          onPressed: () {
            Navigator.pop(context);
            deleteplaylist(NetworkUtil.userid, id);
          },
        ),
        FlatButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff


      getrecentplaylist();
      getownplaylist();
      getfavmusiclist();
      getfavalbumlist();
      getfavartist();


    }
  }
  Future deleteplaylist(String user_id, String plylistid) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    await networkUtil.deleteplaylist(user_id, plylistid);
    getownplaylist();
    setState(() {});
  }
}
