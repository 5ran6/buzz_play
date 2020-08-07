import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';
import 'package:buzz_play/fetchdataapi/Model/Search.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/BannerSlider.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomePopularAlbums.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomePopularMovie.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomeRecommendedAlbum.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomeRecommendedMovie.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomeRecommendedMusic.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/Homecopnetslist.dart';
import 'package:buzz_play/fetchdataapi/Model/myprofilemodel/Favourite_artist.dart';
import 'package:buzz_play/fetchdataapi/NetwrokUtils.dart';
import 'package:buzz_play/ui/albumdetails/AlbumScreen.dart';
import 'package:buzz_play/ui/albumdetails/Allsong.dart';
import 'package:buzz_play/ui/albumdetails/allalbum.dart';
import 'package:buzz_play/ui/albumdetails/allartists.dart';
import 'package:buzz_play/ui/albumdetails/allmovies.dart';
import 'package:buzz_play/ui/musicplayer/Nowplayingmusic.dart';
import 'package:buzz_play/ui/profile/Profile.dart';
import 'package:buzz_play/ui/viewlist/ViewListAlbum.dart';
import 'package:buzz_play/ui/viewlist/ViewListArtist.dart';
import 'package:buzz_play/ui/viewlist/ViewListMostPlay.dart';
import 'package:buzz_play/ui/viewlist/ViewListMovie.dart';
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
      title: 'Home',
      theme: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
      ),
      home: new HomeUI(),
    );
  }
}

class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  NetworkUtil networkUtil;
  AppConfig _appConfig;
  TextStyle boldtextStyle;

  TextStyle regulartextstyle;

  TextStyle countmusiccountstyle;

  TextStyle regular2textstyle;

  TextStyle unselectd;
  TextStyle chiptextstyle;
  TextStyle recnttexttitle;

  TextStyle recnttextview;

  bool issongselectd = false;
  TabController _controller;

  bool isbannerload=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
    networkUtil = new NetworkUtil();


    _onChanged();
    gethomelist();
    getrecentplaylist();
    getbannerslider();
    gethomemostplaylist();
    getpopuleralbumlist();
    getpopmovielist();
    getrecdalbumlist();
    getrecmdedmovielist();
    getrecmdmusiclist();
    getfavartist();
    getsearch();


  }


  bool isfirst = true;
  SharedPreferences sharedPreferences;
  static String userid;
  _onChanged() async {
    sharedPreferences = await SharedPreferences.getInstance();
    isfirst = sharedPreferences.getBool("isfirst");
    userid =  sharedPreferences.getString("setuserid");
    NetworkUtil.userid= userid;


    imgurl=sharedPreferences.getString("userprfpic");


    print("=============@@@@@@@"+imgurl);
    setState(() {
//      NetworkUtil.userid= userid;
      print("user id: "+userid);
    });

  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }



  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff


    /*  gethomelist();
      getrecentplaylist();
      getbannerslider();
      gethomemostplaylist();
      getpopuleralbumlist();
      getpopmovielist();
      getrecdalbumlist();
      getrecmdedmovielist();
      getrecmdmusiclist();
      getfavartist();
      getsearch();*/


    }
  }



  /// list
  List<HomecopnetslistItem> homelistcompnet = new List();
  List<BannerSideItem> homebannerlist = new List();
  List<Recentplay> homemostplaylist = new List();
  List<HomePopularAlbumsItem> homepuleralbumlist = new List();
  List<HomeRPopularMovieItem> homepopmoviewlist = new List();
  List<HomeRecommendedAlbumItem> homerecalbumlist = new List();
  List<HomeRecommendedMovieItem> homerecmdmoviewlist = new List();
  List<HomeRecommendedMusicItem> homerecmdmusiclist = new List();
  List<Recentplay> recetplay = new List();
  List<FavouriteartistItem> favlistartists = new List();

  List<Search> searclist = new List();

  bool mostplatlist = false;

  /// api function call
  void gethomelist() async {

    await networkUtil.homecompent().then((value) {});
    homelistcompnet = Homecopnetslist.homelist;
    setState(() {
      print(homelistcompnet[0].home_components_name);
    });



  }

  void getbannerslider() async {

    sharedPreferences = await SharedPreferences.getInstance();
    //  isfirst = sharedPreferences.getBool("isfirst");
    userid =  sharedPreferences.getString("setuserid");

    await networkUtil.homebannersliderlist(userid).then((value) {});
    homebannerlist = BannerSide.bannersliderLIst;
    isbannerload=true;

    setState(() {
//      print(homebannerlist[0].banner_slider_name);
    });
  }

  void gethomemostplaylist() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //  isfirst = sharedPreferences.getBool("isfirst");
    userid =  sharedPreferences.getString("setuserid");
    await networkUtil.homemostplayelist(userid).then((value) {});
    homemostplaylist = RecentplayList.RecentPlayLIst;

    setState(() {
//      print(homelistcompnet[0].home_components_name);
    });
  }

  void getpopuleralbumlist() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //  isfirst = sharedPreferences.getBool("isfirst");
    userid =  sharedPreferences.getString("setuserid");
    await networkUtil.homepopulralbumlist(userid).then((value) {});
    homepuleralbumlist = HomePopularAlbums.homepopalbumlist;
    setState(() {
//      print(homelistcompnet[0].home_components_name);
    });
  }

  void getfavartist() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //  isfirst = sharedPreferences.getBool("isfirst");
    userid =  sharedPreferences.getString("setuserid");
    await networkUtil.favoriteartist(userid).then((value) {});
    favlistartists = Favouriteartist.RecentPlayLIst;

    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

    setState(() {
//      print(favlistartists[0].artist_image);
    });
  }

  void getpopmovielist() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //  isfirst = sharedPreferences.getBool("isfirst");
    userid =  sharedPreferences.getString("setuserid");
    await networkUtil.homepopulrmoviewlist(userid).then((value) {});
    homepopmoviewlist = HomeRPopularMovie.homerecmndmalbumlist;

    setState(() {
      //print(homelistcompnet[0].home_components_name);
    });
  }

  void getrecdalbumlist() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //  isfirst = sharedPreferences.getBool("isfirst");
    userid =  sharedPreferences.getString("setuserid");
    await networkUtil.homeprecmdedalbumlist(userid).then((value) {});
    homerecalbumlist = HomeRecommendedAlbum.homerecmndmalbumlist;

    setState(() {
//      print(homelistcompnet[0].home_components_name);
    });
  }

  void getrecmdedmovielist() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //  isfirst = sharedPreferences.getBool("isfirst");
    userid =  sharedPreferences.getString("setuserid");
    await networkUtil.homeprecmdedmoviewlist(userid).then((value) {});
    homerecmdmoviewlist = HomeRecommendedMovie.homerecmdmoviewlist;

    setState(() {
//      print(homelistcompnet[0].home_components_name);
    });
  }

  void getrecmdmusiclist() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //  isfirst = sharedPreferences.getBool("isfirst");
    userid =  sharedPreferences.getString("setuserid");
    await networkUtil.homeprecmdedmusiclist(userid).then((value) {});
    homerecmdmusiclist = HomeRecommendedMusic.homerecmndmusiclist;

    setState(() {
//      print(homelistcompnet[0].home_components_name);
    });
  }

  void getrecentplaylist() async {

    sharedPreferences = await SharedPreferences.getInstance();
  //  isfirst = sharedPreferences.getBool("isfirst");
    userid =  sharedPreferences.getString("setuserid");


    await networkUtil.recentplay(userid).then((value) {});
    recetplay = RecentplayList.RecentPlayLIst;
    setState(() {
      print(recetplay[0].music_file);
    });
  }

  void getsearch() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //  isfirst = sharedPreferences.getBool("isfirst");
    userid =  sharedPreferences.getString("setuserid");
    await networkUtil.searchdata(userid).then((value) {});
    searclist = SearchList.RecentPlayLIst;
    setState(() {
//      print("========>>>>>" + searclist[0].search_type);
    });
  }
  String imgurl="";
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

    recnttextview = TextStyle(
        fontSize: _appConfig.rWP(4),
        fontWeight: FontWeight.w600,
        color: Color(0xffD1D1D1),

        fontFamily: 'Montserrat');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new Profile()));
                  },
                  child: Material(
                    elevation: 5.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      child: Image.network(
                        NetworkUtil.BASE_URL1+imgurl,
                        height: _appConfig.rH(5),
                        width: _appConfig.rH(5),

                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  child: Image.asset(
                "assets/image/logo.png",
                height: _appConfig.rHP(14),
                width: _appConfig.rWP(14),
              )),
              Container(
                child: GestureDetector(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearchDelegate(),
                      );
                    },
                    child: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.black54,
                    )),
              ),
            ],
          ),
        ),
      ),
      body: Container(
          color: Color(0xfff6f6f6),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(5, 10, 5 , 10),
                  child: Row(

                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new AllSongsList()));
                        },
                        child: Container(
                          width: _appConfig.rWP(23),
                          height: _appConfig.rHP(4),
                          decoration: new BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(30)),
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
                                  "Music",
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new AllMovieList()));
                        },
                        child: Container(
                          width: _appConfig.rWP(23),
                          height: _appConfig.rHP(4),
                          decoration: new BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(30)),
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
                                  "Movie",
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new AllAlbumsList()));

                        },
                        child: Container(
                          width: _appConfig.rWP(23),
                          height: _appConfig.rHP(4),
                          decoration: new BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(30)),
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
                                  "Album",
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new AllArtistList()));
                        },
                        child: Container(
                          width: _appConfig.rWP(23),
                          height: _appConfig.rHP(4),
                          decoration: new BoxDecoration(
                            borderRadius:
                                new BorderRadius.all(Radius.circular(30)),
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
                                  "Artist",
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
                    ],
                  ),
                ),
                homelistcompnet.length==0?Container(): ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: homelistcompnet.length,
                  itemBuilder: (context, position) {
                    /// sliderbanner

                    return Container(
                      child: slotnumber(position),
                    );
                  },
                ),
              ],
            ),
          )),
    );
  }

  Widget slotnumber(position) {
    if (homelistcompnet[position].home_components_name == "Banner Slider")
      return fullsider(position);
    if (homelistcompnet[position].home_components_name == "Most Played")
      return mostplay();
    if (homelistcompnet[position].home_components_name == "Popular Albums")
      return popularlist();
    if (homelistcompnet[position].home_components_name == "Favourite Artists")
      return favlist();
    if (homelistcompnet[position].home_components_name == "Recently Played")
      return recentplylist();
    if (homelistcompnet[position].home_components_name == "Recommended Music")
      return tab();
    if (homelistcompnet[position].home_components_name == "Popular Movies")
      return popularmoviewlist();
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  Future likesong(String user_id, String type, String music_id) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    await networkUtil.islike(user_id, type, music_id);

    getrecentplaylist();
    getfavartist();
//    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
    setState(() {});
  }

  Future unlikesong(String user_id, String type, String music_id) async {
    Dialogs.showLoadingDialog(context, _keyLoader);
    await networkUtil.isunlike(user_id, type, music_id);
    getrecentplaylist();
    getfavartist();

    setState(() {});
  }

  /// widget for popular Album list
  Widget popularlist() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      height: _appConfig.rH(40),
      child: Column(
        children: <Widget>[
          Container(
            height: _appConfig.rH(7),
            margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: _appConfig.rH(5),
                  width: _appConfig.rH(5),
                  child: Image.asset('assets/image/home/ic_popular.png'),
                ),
                Container(
                  width: _appConfig.rWP(85),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "Popular Albums",
                          style: boldtextStyle,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new ViewListAlbum()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                          child: Text(
                            "See all",
                            style: unselectd,
                          ),
                        ),
                      )
                    ],
                  ),
                )

                /*   FlatButton(
            onPressed: (){},
            child: Text("Create new", style: TextStyle(color: Colors.blue),),
          )*/
              ],
            ),
          ),
          Container(
            height: _appConfig.rH(28),
            margin: EdgeInsets.symmetric(vertical: 13.0),
            child: homepuleralbumlist.length==0?Container(): ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: homepuleralbumlist.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new AlbumScreen(
                            homepuleralbumlist[index].album_name,
                            homepuleralbumlist[index].album_image,
                            "Album",
                            homepuleralbumlist[index].album_id,
                            homepuleralbumlist[index].viewCount,
                            homepuleralbumlist[index].is_liked)));
                  },
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                      width: _appConfig.rHP(19.5),
                      height: _appConfig.rHP(23),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: _appConfig.rHP(17),
                            height: _appConfig.rHP(17),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      NetworkUtil.BASE_URL1 +
                                          homepuleralbumlist[index].album_image,
                                      height: _appConfig.rH(18),
                                      width: _appConfig.rH(18),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    width: _appConfig.rWP(20),
                                    height: _appConfig.rHP(3),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16.0),
                                        )),
                                    child: Center(
                                        child: Text(
                                      homepuleralbumlist[index]
                                              .music_count
                                              .toString() +
                                          " Songs",
                                      style: countmusiccountstyle,
                                          overflow: TextOverflow.ellipsis,

                                          textWidthBasis: TextWidthBasis.longestLine,
                                    )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 5, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  homepuleralbumlist[index].album_name,
                                  style: regular2textstyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  textWidthBasis: TextWidthBasis.longestLine,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.perm_identity,
                                      color: Color(0xffAEAEAE),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        homepuleralbumlist[index].viewCount,
                                        style: unselectd,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,

                                        textWidthBasis: TextWidthBasis.longestLine,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  /// widget for fav artist list
  Container favlist() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: _appConfig.rH(5),
                        width: _appConfig.rH(5),
                        child: Image.asset(
                            'assets/image/home/ic_favorite_artists.png'),
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
                          padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
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
          ),
          SizedBox(height: _appConfig.rHP(1.5),),
          Container(
            height: _appConfig.rHP(19),
            padding: EdgeInsets.symmetric(horizontal: 1.0),
            child: favlistartists.length==0? Container():ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: favlistartists.length,
              itemBuilder: (BuildContext context, int index) {
                return favlistartist(index);
              },
            ),
          ),
        ],
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
        height: _appConfig.rHP(40),
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
                  height: _appConfig.rHP(10),
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

                      textWidthBasis: TextWidthBasis.longestLine,
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
                                  "1", "Artist", favlistartists[pos].artist_id);
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
                                  "1", "Artist", favlistartists[pos].artist_id);
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

  /// widget for most poplur Movie list
  Widget popularmoviewlist() {
    return Container(
      height: _appConfig.rH(41),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: <Widget>[
                Container(
                  height: _appConfig.rH(5),
                  width: _appConfig.rH(5),
                  child: Image.asset('assets/image/home/ic_popular.png'),
                ),
                Container(
                  width: _appConfig.rWP(83),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "Popular Movie",
                          style: boldtextStyle,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new ViewListMovie()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                          child: Text(
                            "See all",
                            style: unselectd,
                          ),
                        ),
                      )
                    ],
                  ),
                )

                /*   FlatButton(
            onPressed: (){},
            child: Text("Create new", style: TextStyle(color: Colors.blue),),
          )*/
              ],
            ),
          ),
          SizedBox(height: _appConfig.rHP(3),),
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            height: _appConfig.rH(30),
            child:homepopmoviewlist.length==0?Container(): ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: homepopmoviewlist.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new AlbumScreen(
                            homepopmoviewlist[index].movie_name,
                            homepopmoviewlist[index].movie_image,
                            "Movie",
                            homepopmoviewlist[index].movie_id,
                            homepopmoviewlist[index].viewCount,
                            homepopmoviewlist[index].is_liked)));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      margin:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 6.0),
                      width: _appConfig.rHP(20),
                      height: _appConfig.rHP(22),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10)),
                                    child: Image.network(
                                      NetworkUtil.BASE_URL1 +
                                          homepopmoviewlist[index].movie_image,
                                      height: _appConfig.rH(22),
                                      width: _appConfig.rH(20),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                /*Positioned(
                                  bottom: 5,
                                  right: 5,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    width: _appConfig.rWP(20),
                                    height: _appConfig.rHP(3),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16.0),
                                        )),
                                    child: Center(
                                        child: Text(
                                          homepuleralbumlist[index]
                                              .music_count
                                              .toString() +
                                              " Songs",
                                          style: countmusiccountstyle,
                                        )),
                                  ),
                                )*/
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 5, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  homepopmoviewlist[index].movie_name,
                                  style: regular2textstyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  textWidthBasis: TextWidthBasis.longestLine,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.perm_identity,
                                      color: Color(0xffAEAEAE),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        homepopmoviewlist[index]
                                            .viewCount
                                            .toString(),
                                        style: unselectd,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,

                                        textWidthBasis: TextWidthBasis.longestLine,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  /// banner slider full
  Widget fullsider(int pos) {
    return isbannerload?Container(
        child: CarouselSlider(
      height: _appConfig.rHP(30),
      autoPlay: true,
      viewportFraction: 0.95,
      autoPlayInterval: Duration(milliseconds: 1800),
      items: homebannerlist.map(
        (url) {
          return Container(
            margin: EdgeInsets.all(10),
            child: Container(
              child: GestureDetector(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  child: Stack(children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Image.network(
                          NetworkUtil.BASE_URL1 + url.banner_slider_image,
                          fit: BoxFit.cover,
                          height: _appConfig.rHP(24),
                          width: _appConfig.rWP(90)),
                    ),
                    url.banner_slider_name_alignment == "Left"
                        ? Container(
                            height: _appConfig.rHP(24),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black, Color(0x00ffffff)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    width: _appConfig.rHP(22),
                                    child: Text(
                                      url.banner_slider_name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Montserrat',
                                          fontSize: _appConfig.rWP(5),
                                          color: Colors.white),
                                      maxLines: 1,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  url.banner_slider_show_button == "0"
                                      ? Container()
                                      : Container(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          width: _appConfig.rWP(30),
                                          height: _appConfig.rHP(3.5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              )),
                                          child: Center(
                                              child: Text(
                                            url.banner_slider_button_text,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Montserrat',
                                                fontSize: 18,
                                                color: Colors.black),
                                          )),
                                        )

                                  /*
                                  MaterialButton(
                                    padding: const EdgeInsets.all(8.0),
                                    textColor: Colors.white,
                                    color: Colors.blue,
                                    child: Text(
                                        url.banner_slider_button_text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontFamily: 'Montserrat',
                                            fontSize: 25,
                                            color: Colors.white),
                                        maxLines: 2),
                                  ),*/
                                ],
                              ),
                            ))
                        : Container(
                            height: _appConfig.rHP(24),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black, Color(0x00ffffff)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      url.banner_slider_name,
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'Montserrat',
                                          color: Colors.white),
                                      maxLines: 2,
                                    ),
                                  ),
                                  url.banner_slider_show_button == "0"
                                      ? Container()
                                      : Container(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          width: _appConfig.rWP(30),
                                          height: _appConfig.rHP(3.5),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(5.0),
                                              )),
                                          child: Center(
                                              child: Text(
                                            url.banner_slider_button_text,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Montserrat',
                                                fontSize: _appConfig.rWP(3),
                                                color: Colors.black),
                                          )),
                                        ),
                                ],
                              ),
                            ),
                          ),
                  ]),
                ),
              ),
            ),
          );
        },
      ).toList(),
    )):Container();
  }

  /// Recent Playlist
  Widget recentplylist() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(5, 20, 0, 0),
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: _appConfig.rH(5),
                        width: _appConfig.rH(5),
                        child: Image.asset(
                            'assets/image/home/ic_recently_played.png'),
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
                              builder: (context) =>
                                  new NowPlaying(recetplay, 0, 1)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
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
          ),
          SizedBox(height: _appConfig.rHP(1),),
          Container(
            margin: EdgeInsets.fromLTRB(5, 20, 0, 0),
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child:recetplay.length==0?Container(): ListView.builder(
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
                                        recetplay[pos]
                                            .artistlist[0]
                                            .artist_name,
                                        style: recnttextview,
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
    );
  }

  /// widget for most played
  Widget mostplay() {
    return Container(
      height: _appConfig.rH(36),
      child: Column(
        children: <Widget>[
          Container(

            margin: EdgeInsets.fromLTRB(5, 5, 0, 0),
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: _appConfig.rH(5),
                  width: _appConfig.rH(5),
                  child: Image.asset('assets/image/home/ic_most_played.png'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Most Played",
                    style: boldtextStyle,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: _appConfig.rWP(50),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (context) => new ViewListMostPlay()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                          child: Text(
                            "See all",
                            textAlign: TextAlign.right,
                            style: unselectd,
                          ),
                        ),
                      ),
                    ),
                  ],
                )

                /*   FlatButton(
            onPressed: (){},
            child: Text("Create new", style: TextStyle(color: Colors.blue),),
          )*/
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
            height: _appConfig.rH(28),
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: homemostplaylist.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                            new NowPlaying(homemostplaylist, index, 1)));
                  },
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                      width: _appConfig.rHP(19.5),
                      height: _appConfig.rHP(23),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                NetworkUtil.BASE_URL1 +
                                    homemostplaylist[index].music_image,
                                width: _appConfig.rHP(17),
                                height: _appConfig.rHP(17),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            child: Text(
                              homemostplaylist[index].music_title,
                              style: regular2textstyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              textWidthBasis: TextWidthBasis.longestLine,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            child: Text(
                              homemostplaylist[index].artistlist[0].artist_name,
                              style: unselectd,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              textWidthBasis: TextWidthBasis.longestLine,
                            ),
                          )
                        ],
                      )),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  ///widget for  recomanded movielist
  Widget moviewlist() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: _appConfig.rH(25),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: homerecmdmoviewlist.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new AlbumScreen(
                            homerecmdmoviewlist[index].movie_name,
                            homerecmdmoviewlist[index].movie_image,
                            "Movie",
                            homerecmdmoviewlist[index].movie_id,
                            homerecmdmoviewlist[index].likedCount,
                            homerecmdmoviewlist[index].is_liked)));
                  },
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                      width: _appConfig.rWP(35),
                      height: _appConfig.rHP(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                NetworkUtil.BASE_URL1 +
                                    homerecmdmoviewlist[index].movie_image,
                                height: _appConfig.rH(15),
                                width: _appConfig.rH(15),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            child: Text(
                              homerecmdmoviewlist[index].movie_name,
                              style: regular2textstyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              textWidthBasis: TextWidthBasis.longestLine,
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  ///widget for rec musiclist
  Widget musiclist() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: _appConfig.rH(25),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: homerecmdmusiclist.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                            new NowPlaying(recetplay, index, 1)));
                  },
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                      width: _appConfig.rWP(35),
                      height: _appConfig.rHP(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                NetworkUtil.BASE_URL1 +
                                    homerecmdmusiclist[index].music_image,
                                height: _appConfig.rH(15),
                                width: _appConfig.rH(15),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            child: Text(
                              homerecmdmusiclist[index].music_title,
                              style: regular2textstyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              textWidthBasis: TextWidthBasis.longestLine,
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  ///widget for redd albumlist
  Widget albumlist() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            height: _appConfig.rH(25),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: homerecalbumlist.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new AlbumScreen(
                            homerecalbumlist[index].album_name,
                            homerecalbumlist[index].album_image,
                            "Album",
                            homerecalbumlist[index].album_id,
                            homerecalbumlist[index].likedCount,
                            homerecalbumlist[index].is_liked)));
                  },
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                      width: _appConfig.rWP(35),
                      height: _appConfig.rHP(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            child: Text(
                              homerecalbumlist[index].album_name,
                              style: regular2textstyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,

                              textWidthBasis: TextWidthBasis.longestLine,
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget tab() {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 20, 10, 0),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: _appConfig.rH(5),
                        width: _appConfig.rH(5),
                        child: Image.asset(
                            'assets/image/home/ic_favorite_artists.png'),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "Recommended",
                          style: boldtextStyle,
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
          ),
          SizedBox(height: _appConfig.rHP(1),),
          new Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: new TabBar(
              indicatorColor: Colors.deepPurple,
              labelColor: Colors.deepPurple,
              indicatorWeight: 5,
              unselectedLabelColor: Colors.grey,

              labelStyle: TextStyle(fontSize: 22.0, fontFamily: 'Montserrat'),
              //For Selected tab

              controller: _controller,
              tabs: [
                new Tab(
                  text: 'Music',
                ),
                new Tab(
                  text: 'Movies',
                ),
                new Tab(
                  text: 'Album',
                ),
              ],
            ),
          ),
          new Container(
            height: _appConfig.rHP(30),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: new TabBarView(
              controller: _controller,
              children: <Widget>[
                musiclist(),
                moviewlist(),
                albumlist(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  List<Search> suggestion = new List();

  void getmovielist(String id, context) async {
    await networkUtil.getmoviewsong(NetworkUtil.userid, id).then((value) {});
    NetworkUtil.moviemoviewModel.mostplay;

    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => new AlbumScreen(
            NetworkUtil.moviemoviewModel.movie_name,
            NetworkUtil.moviemoviewModel.movie_image,
            "Movie",
            NetworkUtil.moviemoviewModel.movie_id,
            NetworkUtil.moviemoviewModel.like_count.toString(),
            NetworkUtil.moviemoviewModel.is_liked)));
  }

  void getartistlist(String id, context) async {
    await networkUtil.getfevartist(NetworkUtil.userid, id).then((value) {});
    NetworkUtil.favArtistModel.mostplay;

    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => new AlbumScreen(
            NetworkUtil.favArtistModel.artist_name,
            NetworkUtil.favArtistModel.artist_image,
            "Artist",
            NetworkUtil.favArtistModel.artist_id,
            NetworkUtil.favArtistModel.like_count.toString(),
            NetworkUtil.favArtistModel.is_liked)));
  }

  void getalbumlist(String id, context) async {
    await networkUtil.getalbumsongs(NetworkUtil.userid, id).then((value) {});
    NetworkUtil.albumModel.mostplay;

    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) => new AlbumScreen(
            NetworkUtil.albumModel.album_name,
            NetworkUtil.albumModel.album_image,
            "Album",
            NetworkUtil.albumModel.album_id,
            NetworkUtil.albumModel.like_count.toString(),
            NetworkUtil.albumModel.is_liked)));
  }
  void singmusic(String id, context) async {
    await networkUtil.sinlmusic(NetworkUtil.userid, id).then((value) {});


    recent.add(NetworkUtil.ecentplay);

    Navigator.of(context).push(new MaterialPageRoute(
        builder: (context) =>
        new NowPlaying(recent, 0, 1)));
  }

  NetworkUtil networkUtil;
  List<Recentplay> recent=new List();

  @override
  Widget buildResults(BuildContext context) {
    networkUtil = new NetworkUtil();
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    //Add the search term to the searchBloc.
    //The Bloc will then handle the searching and add the results to the searchResults stream.
    suggestion.clear();
    for (int i = 0; i < SearchList.RecentPlayLIst.length; i++) {
      if (SearchList.RecentPlayLIst[i].search_text
          .toLowerCase()
          .contains(query)) {
        suggestion.add(SearchList.RecentPlayLIst[i]);
      }
    }

    return ListView.builder(
      itemCount: suggestion.length,
      itemBuilder: (context, index) {
        var result = suggestion[index];
        return GestureDetector(
          onTap: () {
            if (result.search_type == "music") {

              singmusic(result.id, context);
            } else if (result.search_type == "artist") {
              getartistlist(result.id, context);
            } else if (result.search_type == "movie") {
              getmovielist(result.id, context);
            } else if (result.search_type == "album") {
              getalbumlist(result.id, context);
            }
          },
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[300], width: 2.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      result.search_text,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff5d5d5d),
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Container(
                    child: Text(
                      result.search_type,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Colors.grey,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.
    return Column(
      children: <Widget>[],
    );
  }
}
