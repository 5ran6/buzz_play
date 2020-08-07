import 'package:flutter/material.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomePopularAlbums.dart';
import 'package:buzz_play/fetchdataapi/NetwrokUtils.dart';
import 'package:buzz_play/ui/albumdetails/AlbumScreen.dart';
import 'package:buzz_play/utils/AppConfig.dart';

class Playlist extends StatefulWidget {
  @override
  _PlaylistState createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  var value;
  bool isExpanded = false;
  bool islist = false;
  List<HomePopularAlbumsItem> homepuleralbumlist = new List();

  TextStyle boldtextStyle;

  TextStyle regulartextstyle;

  TextStyle countmusiccountstyle;

  TextStyle regular2textstyle;

  TextStyle unselectd;
  TextStyle chiptextstyle;
  TextStyle recnttexttitle;
  AppConfig _appConfig;

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
    await networkUtil.homepopulralbumlist(NetworkUtil.userid).then((value) {});
    homepuleralbumlist = HomePopularAlbums.homepopalbumlist;
    setState(() {
      //   print(homelistcompnet[0].home_components_name);
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
                    'album',
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
                  childAspectRatio: 0.5
              ),
              itemCount: homepuleralbumlist.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                        new AlbumScreen(homepuleralbumlist[index].album_name,
                            homepuleralbumlist[index].album_image,"Album",
                            homepuleralbumlist[index].album_id,homepuleralbumlist[index].viewCount,
                            homepuleralbumlist[index].is_liked)));
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  homepuleralbumlist[index].album_name,
                                  style: regular2textstyle,
                                  maxLines: 1,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
}
