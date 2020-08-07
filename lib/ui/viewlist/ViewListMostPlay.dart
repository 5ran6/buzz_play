import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomePopularAlbums.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomePopularMovie.dart';
import 'package:buzz_play/fetchdataapi/NetwrokUtils.dart';
import 'package:buzz_play/ui/albumdetails/AlbumScreen.dart';
import 'package:buzz_play/ui/musicplayer/Nowplayingmusic.dart';
import 'package:buzz_play/utils/AppConfig.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent,
        //brightness: Brightness.dark
      ),
      home: ViewListMostPlay(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ViewListMostPlay extends StatefulWidget {
  @override
  _ViewListMostPlayState createState() => _ViewListMostPlayState();
}

AppConfig _appConfig;

class _ViewListMostPlayState extends State<ViewListMostPlay> {
  var value;
  bool isExpanded = false;
  bool islist = false;



  List<Recentplay> homemostplaylist = new List();
  TextStyle boldtextStyle;

  TextStyle regulartextstyle;

  TextStyle countmusiccountstyle;

  TextStyle regular2textstyle;

  TextStyle unselectd;
  TextStyle chiptextstyle;
  TextStyle recnttexttitle;

  TextStyle recnttextview;
  NetworkUtil networkUtil;

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    networkUtil = new NetworkUtil();


    getpopuleralbumlist();
  }


  void getpopuleralbumlist() async {
    await networkUtil.homemostplayelist(NetworkUtil.userid).then((value) {});
    homemostplaylist = RecentplayList.RecentPlayLIst;

    setState(() {

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

    recnttextview = TextStyle(
        fontSize: _appConfig.rWP(4),
        fontWeight: FontWeight.w600,
        color: Color(0xffD1D1D1),
        fontFamily: 'Montserrat');

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(_appConfig.rHP(7)),
        child: AppBar(
          backgroundColor: Colors.white,
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Most Played Songs',
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
      ),
      body: popularlist(),
    );
  }


  Widget popularlist() {
    return Container(

      height: double.infinity,
      margin: EdgeInsets.only(top: 20),
      width: double.infinity,
      child: Column(
        children: <Widget>[

          Container(
            height: _appConfig.rH(80),
            child: GridView.builder(

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7
              ),
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

                      child: Column(
                        children: <Widget>[
                          Container(
                            width: _appConfig.rHP(15),
                            height: _appConfig.rHP(15),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      NetworkUtil.BASE_URL1 +
                                          homemostplaylist[index].music_image,
                                      height: _appConfig.rH(18),
                                      width: _appConfig.rH(18),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              /*  Positioned(
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
                                          homemostplaylist[index]
                                              .viewCount
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  homemostplaylist[index].music_title,
                                  style: regular2textstyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  textWidthBasis: TextWidthBasis.longestLine,
                                ),
                                Text(
                                  homemostplaylist[index].artistlist[0].artist_name,
                                  style: unselectd,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,

                                  textWidthBasis: TextWidthBasis.longestLine,
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
}
