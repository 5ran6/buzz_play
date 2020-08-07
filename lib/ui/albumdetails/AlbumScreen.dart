import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';
import 'package:buzz_play/fetchdataapi/Model/albumdata/MovieAlbumModel.dart';
import 'package:buzz_play/fetchdataapi/Model/myprofilemodel/Favourite_artist.dart';
import 'package:buzz_play/fetchdataapi/NetwrokUtils.dart';
import 'package:buzz_play/ui/musicplayer/Nowplayingmusic.dart';
import 'package:buzz_play/utils/AppConfig.dart';
import 'package:buzz_play/utils/Dialogs.dart';
import 'package:path_provider/path_provider.dart';

class AlbumScreen extends StatefulWidget {
  String name;
  String url;
  String type;
  String id;
  String countview;
  int islike;

  AlbumScreen(@required this.name, @required this.url, @required this.type,
      @required this.id, @required this.countview, @required this.islike);

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

AppConfig _appConfig;

class _AlbumScreenState extends State<AlbumScreen> {
  final fabc = 0xFFffb3b3;
  bool isLocal;
  PlayerMode mode;
  String url;
  NetworkUtil networkUtil;
  List<FavouriteartistItem> favlistartists = new List();

//  Recentplay song;
  void initState() {
    super.initState();
//    song = widget.songs[widget.index];
    this.isLocal = false;
    this.mode = PlayerMode.MEDIA_PLAYER;
    networkUtil = new NetworkUtil();

    if (widget.type == "Album") {
      getrecentplaylist();
    } else if (widget.type == "Movie") {
      getmovielist();
    } else if (widget.type == "Artist") {
      getartistlist();
    } else if (widget.type == "PlayList") {
      getplaylist();
    }
//    url = NetworkUtil.BASE_URL1 + song.music_file;

//    print(url);

//    _play();
//    initAnim();
//    initPlayer();
//
//    MediaNotification.setListener('pause', () {
//      _playpause();
//    });
//
//    MediaNotification.setListener('play', () {
//      _playpause();
//    });
//
//    MediaNotification.setListener('next', () {
//      next();
//    });
//
//    MediaNotification.setListener('prev', () {
//      prev();
//    });
//
//    MediaNotification.setListener('select', () {
//      // yet to be impl
//    });
  }

//  MovieAlbumModel _albumModel=new MovieAlbumModel();
  void getrecentplaylist() async {

    print("user id+++++++++"+NetworkUtil.userid);
    await networkUtil.getalbumsongs(NetworkUtil.userid, widget.id).then((value) {});
    recetplay = NetworkUtil.albumModel.mostplay;
    setState(() {
      widget.countview=recetplay.length.toString();
//      print(recetplay[0].music_file);
    });
  }

  void getmovielist() async {
    await networkUtil.getmoviewsong(NetworkUtil.userid, widget.id).then((value) {});
    recetplay = NetworkUtil.moviemoviewModel.mostplay;
    setState(() {
      widget.countview=recetplay.length.toString();
//      print(recetplay[0].music_file);
    });
  }

  void getartistlist() async {
    await networkUtil.getfevartist(NetworkUtil.userid, widget.id).then((value) {});
    recetplay = NetworkUtil.favArtistModel.mostplay;
    setState(() {
      widget.countview=recetplay.length.toString();
//      print(recetplay[0].music_file);
    });
  }

  void getplaylist() async {
    await networkUtil.getplayslistdata(NetworkUtil.userid, widget.id).then((value) {});
    recetplay = RecentplayList.RecentPlayLIst;
     setState(() {
      widget.countview=recetplay.length.toString();
//      print(recetplay[0].music_file);
    });
  }

  void getfavartist() async {
    await networkUtil.favoriteartist(NetworkUtil.userid).then((value) {});
//    favlistartists = Favouriteartist.RecentPlayLIst;
    if (widget.type == "Album") {
      getrecentplaylist();
    } else if (widget.type == "Movie") {
      getmovielist();
    }
    setState(() {
      widget.countview=recetplay.length.toString();
//      print(favlistartists[0].artist_image);
    });
  }

  List<Recentplay> recetplay = new List();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    _appConfig = new AppConfig(context);
    return new Scaffold(
      key: scaffoldState,
      body: Stack(children: <Widget>[
        albums(),
        new Positioned(
          //Place it at the top, and not use the entire screen
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            title: Text(
              widget.type,
              style: TextStyle(
                color: Colors.black,
                  fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600
              ),
            ),
            //No more green
            backgroundColor: Colors.transparent,
            elevation: 0.0, //Shadow gone
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.black,
              onPressed: () => {Navigator.pop(context)},
            ),
          ),
        ),
      ]),
    );
    ;
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  Future likesong(String user_id, String type, String music_id) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    await networkUtil.islike(user_id, type, music_id);
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    if (widget.type == "Album") {
      getrecentplaylist();
    } else if (widget.type == "Movie") {
      getmovielist();
    } else if (widget.type == "Artist") {
      getartistlist();
    } else if (widget.type == "PlayList") {
      getplaylist();
    }
//    getrecentplaylist();/
//    getfavartist();
    setState(() {});
  }

  Future unlikesong(String user_id, String type, String music_id) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    await networkUtil.isunlike(user_id, type, music_id);
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    if (widget.type == "Album") {
      getrecentplaylist();
    } else if (widget.type == "Movie") {
      getmovielist();
    } else if (widget.type == "Artist") {
      getartistlist();
    } else if (widget.type == "PlayList") {
      getplaylist();
    }
    setState(() {});
  }

//  AppConfig _appConfig;
  Widget albums() {
    return new Container(
      child: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(top: _appConfig.rHP(8)),
              height: _appConfig.rHP(30),
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/image/playing/bgplaymusic.png"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: new Image.network(
                            NetworkUtil.BASE_URL1 + widget.url,
                            height: _appConfig.rHP(20),
                            width: _appConfig.rHP(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.name,
                          style:
                              TextStyle(fontSize: 18, fontFamily: 'Montserrat'),
                        ),
                        Text(
                          widget.countview==null?"" :widget.countview+ " Songs",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontFamily: 'Montserrat'),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {


                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) =>
                                new NowPlaying(recetplay, 0, 1)));


                        },
                        child: Image.asset(
                          "assets/image/playing/ic_play.png",
                          height: _appConfig.rHP(10),
                          width: _appConfig.rWP(10),
                        ),
                      ),
                      SizedBox(
                        width: _appConfig.rWP(2),
                      ),
                      widget.islike == 0
                          ? Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              width: _appConfig.rW(10),
                              child: GestureDetector(
                                onTap: () {
                                  likesong(NetworkUtil.userid, widget.type, widget.id);
                                  widget.islike = 1;
                                  print("jhjdhhdj");
                                },
                                child: Image.asset(
                                  "assets/image/playing/ic_favorite.png",
                                  height: _appConfig.rHP(10),
                                  width: _appConfig.rWP(10),
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              width: _appConfig.rW(10),
                              child: GestureDetector(
                                onTap: () {
                                  unlikesong(NetworkUtil.userid, widget.type, widget.id);
                                  widget.islike = 0;

                                  print("jhjdhhdj");
                                },
                                child: Image.asset(
                                  "assets/image/playing/ic_favorite1.png",
                                  height: _appConfig.rHP(10),
                                  width: _appConfig.rWP(10),
                                ),
                              ),
                            ),
                      SizedBox(
                        width: _appConfig.rWP(2),
                      ),
                      Container(

                        child: GestureDetector(
                          onTap: ()
                          {
                            _download(0);
                          },
                          child: downloading
                              ? CircularProgressIndicator(): Image.network(
                            "assets/image/playing/ic_download.png",
                            height: _appConfig.rHP(10),
                            width: _appConfig.rWP(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: _appConfig.rWP(3),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 20, 0, 0),
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: recetplay.length,
                        itemBuilder: (BuildContext context, int pos) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (context) =>
                                      new NowPlaying(recetplay, pos, 1)));
                            },
                            onLongPress: () {
                              if (widget.type == "PlayList") {


                                showAlertDialog(context, recetplay[pos].music_id);


                              }
                            },
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 15, 10),
                                    child: Container(
                                      width: _appConfig.rH(6),
                                      height: _appConfig.rH(6),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                              width: _appConfig.rW(53),
                                              child: Text(
                                                recetplay[pos].music_title,
                                                maxLines: 1,
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
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                15, 0, 0, 0),
                                                        width: _appConfig.rW(8),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            likesong(
                                                                NetworkUtil.userid,
                                                                "Music",
                                                                recetplay[pos]
                                                                    .music_id);
                                                            recetplay[pos]
                                                                .is_liked = 1;
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
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                15, 0, 0, 0),
                                                        width: _appConfig.rW(8),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            unlikesong(
                                                                NetworkUtil.userid,
                                                                "Music",
                                                                recetplay[pos]
                                                                    .music_id);
                                                            recetplay[pos]
                                                                .is_liked = 0;

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
                                                  margin: EdgeInsets.fromLTRB(
                                                      5, 0, 0, 0),
                                                  child: Text(
                                                    recetplay[pos]
                                                        .like_count
                                                        .toString(),
                                                    //style: recnttextview,
                                                    textAlign: TextAlign.start,
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
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 15),
                                              width: _appConfig.rW(60),
                                              child: recetplay[pos]
                                                          .artistlist
                                                          .length >
                                                      0
                                                  ? Text(
                                                      recetplay[pos]
                                                          .artistlist[0]
                                                          .artist_name,
                                                      //  style: recnttextview,
                                                      maxLines: 1,
                                                    )
                                                  : Text(""),
                                            )
                                          : recetplay[pos].artistlist.length ==
                                                  0
                                              ? Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 5, 0, 15),
                                                  width: _appConfig.rW(60),
                                                  child: Text(
                                                    recetplay[pos].album_name,
                                                    //   style: recnttextview,
                                                    maxLines: 1,
                                                  ),
                                                )
                                              : Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 5, 0, 15),
                                                  width: _appConfig.rW(60),
                                                  child: Text(
                                                    recetplay[pos].album_name +
                                                        " - " +
                                                        recetplay[pos]
                                                            .artistlist[0]
                                                            .artist_name,
                                                    //style: recnttextview,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  var progress = "";
  bool downloading = false;
  Future<void> _download(int i) async {
    Dio dio = Dio();

    var dirToSave = await getApplicationDocumentsDirectory();

    await dio.download(NetworkUtil.BASE_URL1+recetplay[i].music_file,
        "${dirToSave.path}/" +recetplay[i].music_title + ".mp3",
        onReceiveProgress: (rec, total) {
          setState(() {
            downloading = true;
            progress = ((rec / total)).toStringAsFixed(0) + "%";
          });
        });

    try {} catch (e) {
      throw e;
    }
    setState(() {
      downloading = false;
      progress = "Complete";
    });
  }
  cardImageAsset() {}

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

  Future deleteplaylist(String user_id, String plylistid) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    await networkUtil.removefromplaylist(user_id, plylistid);
    await getplaylist();
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    setState(() {});
  }
}

class ImageWithLabel extends StatelessWidget {
  ImageWithLabel(this.index);

  final int index;

  @override
  Widget build(BuildContext context) => Container(
        width: _appConfig.rWP(26),
        height: _appConfig.rHP(14.5),
      );
}
