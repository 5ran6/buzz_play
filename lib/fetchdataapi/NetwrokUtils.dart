import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:buzz_play/fetchdataapi/Model/AllowDownload.dart';
import 'package:buzz_play/fetchdataapi/Model/Search.dart';
import 'package:buzz_play/fetchdataapi/Model/albumdata/MovieAlbumModel.dart';
import 'package:buzz_play/fetchdataapi/Model/fevartistdata/FavArtistModel.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/BannerSlider.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomeMostPlayed.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomePopularAlbums.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomePopularMovie.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomeRecommendedAlbum.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomeRecommendedMovie.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/HomeRecommendedMusic.dart';
import 'package:buzz_play/fetchdataapi/Model/home_componet_model/Homecopnetslist.dart';
import 'package:buzz_play/fetchdataapi/Model/moviedata/MoviemoviewModel.dart';
import 'package:buzz_play/fetchdataapi/Model/myprofilemodel/Favourite_artist.dart';
import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';
import 'package:buzz_play/fetchdataapi/Model/SignupModel.dart';
import 'package:buzz_play/fetchdataapi/Model/myprofilemodel/MyownFavalbum.dart';
import 'package:buzz_play/fetchdataapi/Model/myprofilemodel/MyownFavmusic.dart';
import 'package:buzz_play/fetchdataapi/Model/myprofilemodel/Myownplaylist.dart';
import 'package:buzz_play/fetchdataapi/Model/paymet/Packget.dart';

class NetworkUtil {
  static final BASE_URL = "https://appiconmakers.com/demoMusicPlayer/API/";

  static final BASE_URL1 = "https://appiconmakers.com/demoMusicPlayer/";
  static String userid;
  static int isdown=0;

  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) {
    return http.get(url).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(statusCode);
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url,
      {Map<String, String> headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      print("API Response: " + res);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(statusCode);
      }
      return _decoder.convert(res);
    });
  }









  Future<Registers> postregisterfb(String email, String password, String token,
      String profile, String name) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "signup";
    await post(BASE_TOKEN_URL, body: {
      "user_email": email,
      "user_password": password,
      "user_token": token,
      "user_profile_pic": profile,
      "user_name": name
    }).then((dynamic res) async {
      rregisters =await  new Registers.fromJson(res[0]);
      return rregisters;
    });
  }

  Future<void> signin(String email, String password, String token) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "signin";
    await post(BASE_TOKEN_URL, body: {
      "user_email": email,
      "user_password": password,
      "user_token": token,
    }).then((dynamic res) async {


      rregisters = await new Registers.fromJson(res[0]);
      return rregisters;
    });
  }








  Future<List<Recentplay>> recentplay(
      String user_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "home";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "home_components_name": "Recently Played",
    }).then((dynamic res) async {


      var results=await RecentplayList.getuserid(res);


      return results;
    });
  }




  Future<List<Recentplay>> getplayslistdata(
      String user_id,String user_playlist_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "getPlaylistMusic";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "user_playlist_id": user_playlist_id,
    }).then((dynamic res) async {


      var results=await RecentplayList.getuserid(res);


      return results;
    });
  }

  static Registers rregisters;




  Future<List<Favouriteartist>> favoriteartist(
      String user_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "home";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "home_components_name": "Favourite Artists",
    }).then((dynamic res) async {


      var results=await Favouriteartist.getuserid(res);


      return results;
    });
  }

  Future<Registers> edtprofile(String user_id,
      String profile, String name) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "ediProfile";
    await post(BASE_TOKEN_URL, body: {"user_id":user_id,
      "user_profile_pic": profile,
      "user_name": name
    }).then((dynamic res) async {
      rregisters =await   Registers.fromJson(res[0]);
      return rregisters;
    });
  }


  Future<List<USerplaylist>> ownplaylist(
      String user_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "getPlaylists";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,

    }).then((dynamic res) async {


      var results=await USerplaylist.getuserid(res);


      return results;
    });
  }




  Future<MovieAlbumModel> getalbumsongs(
      String user_id,String album_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "viewAlbum";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "album_id":album_id
    }).then((dynamic res) async {


      albumModel =await MovieAlbumModel.fromJson(res);

      return albumModel;
    });
  }

   static MovieAlbumModel albumModel;

  static MoviemoviewModel moviemoviewModel;


  Future<MoviemoviewModel> getmoviewsong(
      String user_id,String album_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "viewMovie";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "movie_id":album_id
    }).then((dynamic res) async {


      moviemoviewModel =await MoviemoviewModel.fromJson(res);

      return moviemoviewModel;
    });
  }
static FavArtistModel favArtistModel;
  Future<FavArtistModel> getfevartist(
      String user_id,String album_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "viewArtist";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "artist_id":album_id
    }).then((dynamic res) async {


      favArtistModel =await FavArtistModel.fromJson(res);

      return favArtistModel;
    });
  }






  Future<List<Myownfavmusic>> myfavownmusic(
      String user_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "home";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "is_myProfile":"1",
      "home_components_name": "Recommended Music",
    }).then((dynamic res) async {


      var results=await Myownfavmusic.getuserid(res);


      return results;
    });
  }

  Future<List<Myownfavalbum>> myfavowalbum(
      String user_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "home";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "home_components_name": "Recommended Album",
    }).then((dynamic res) async {


      var results=await Myownfavalbum.getuserid(res);


      return results;
    });
  }


  Future<List<Homecopnetslist>> homecompent() async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "home_components";
    await post(BASE_TOKEN_URL, body: {}).then((dynamic res) async {


      var results=Homecopnetslist.getuserid(res);


      return results;
    });
  }



  Future<List<BannerSide>> homebannersliderlist(String user_id)async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "home";
    await post(BASE_TOKEN_URL, body: {
    "user_id": user_id,
    "home_components_name": "Banner Slider"}).then((dynamic res) async {


      var results=await BannerSide.getuserid(res);


      return results;
    });
  }


  Future<List<Recentplay>> homemostplayelist(String user_id)async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "home";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "home_components_name": "Most Played"}).then((dynamic res) async {


      var results=await RecentplayList.getuserid(res);


      return results;
    });
  }





  Future<List<HomePopularAlbums>> homepopulralbumlist(String user_id)async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "home";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "home_components_name": "Popular Albums"}).then((dynamic res) async {


      var results=await HomePopularAlbums.getuserid(res);


      return results;
    });
  }



  Future<List<HomeRPopularMovie>> homepopulrmoviewlist(String user_id)async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "home";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "home_components_name": "Popular Movies"}).then((dynamic res) async {


      var results=await HomeRPopularMovie.getuserid(res);


      return results;
    });
  }




  Future<List<HomeRecommendedMovie>> homeprecmdedmoviewlist(String user_id)async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "home";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "home_components_name": "Recommended Movies"}).then((dynamic res) async {


      var results=await HomeRecommendedMovie.getuserid(res);


      return results;
    });
  }




  Future<List<HomeRecommendedAlbum>> homeprecmdedalbumlist(String user_id)async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "home";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "home_components_name": "Recommended Album"}).then((dynamic res) async {


      var results=await HomeRecommendedAlbum.getuserid(res);


      return results;
    });
  }




  Future<List<HomeRecommendedMusic>> homeprecmdedmusiclist(String user_id)async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "home";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "home_components_name": "Recommended Music"}).then((dynamic res) async {


      var results=await HomeRecommendedMusic.getuserid(res);


      return results;
    });
  }











  Future<void> islike(
      String user_id,String type,String music_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "like";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "like_type": type,
      "like_type_id":music_id,
    }).then((dynamic res) async {




      return true;
    });
  }


  Future<void> isunlike(
      String user_id,String type,String music_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "unlike";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "like_type": type,
      "like_type_id":music_id,
    }).then((dynamic res) async {




      return true;
    });
  }

  Future<List<Search>> searchdata(
      String user_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "search";
    await post(BASE_TOKEN_URL, body: {

    }).then((dynamic res) async {


      var results=await SearchList.getuserid(res);


      return results;
    });
  }


  Future<List<Recentplay>> getall_music(
      String user_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "getAllMusics";
    await post(BASE_TOKEN_URL,
        body: {"user_id": user_id})
        .then((dynamic res) async {
      return RecentplayList.getuserid(res);
    });
  }
  Future<List<HomePopularAlbums>> getall_album(
      String user_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "getAllAlbums";
    await post(BASE_TOKEN_URL,
        body: {"user_id": user_id})
        .then((dynamic res) async {
      return HomePopularAlbums.getuserid(res);
    });
  }
  Future<List<Favouriteartist>> getall_artist(
      String user_id) async
  {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "getAllArtists";
    await post(BASE_TOKEN_URL,
        body: {"user_id": user_id})
        .then((dynamic res) async {
      return Favouriteartist.getuserid(res);
    });
  }
  Future<List<HomeRPopularMovie>> getall_movies(
      String user_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "getAllMovies";
    await post(BASE_TOKEN_URL,
        body: {"user_id": user_id})
        .then((dynamic res)
    async {
      return HomeRPopularMovie.getuserid(res);
    });
  }


  Future<void> addplaylis(
      String user_id,String user_playlist_id,String music_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "addInPlaylist";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "user_playlist_id": user_playlist_id,
      "music_id":music_id,
    }).then((dynamic res) async {




      return true;
    });
  }


  Future<int> isdownad(String user_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "isAllowDownloads";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id
    }).then((dynamic res) async {
      isdown=await AllowDownloads.fromJson(res).is_allow_downloads;
      return isdown;
    });
  }


  Future<List<Packget>> getpckg() async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "getPackages";
    await post(BASE_TOKEN_URL, body: {

    }).then((dynamic res) async {

var list=await MyPackge.getuserid(res);

      return list ;
    });
  }
  static Recentplay ecentplay;
  Future<Recentplay> sinlmusic(
      String user_id,String music_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "playMusic";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,

      "music_id":music_id,
    }).then((dynamic res) async {


      ecentplay=await   Recentplay.fromJson(res);

      return ecentplay;
    });
  }
  Future<void> createplylist(
      String user_id,String createPlayList) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "createPlayList";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "user_playlist_name": createPlayList,

    }).then((dynamic res) async {




      return true;
    });
  }


  Future<void> deleteplaylist(
      String user_id,String user_playlist_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "deletePlayList";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "user_playlist_id": user_playlist_id,

    }).then((dynamic res) async {




      return true;
    });
  }
  Future<void> removefromplaylist(
      String user_id,String music_id) async {
    String BASE_TOKEN_URL = NetworkUtil.BASE_URL + "removeFromPlaylist";
    await post(BASE_TOKEN_URL, body: {
      "user_id": user_id,
      "music_id": music_id,

    }).then((dynamic res) async {




      return true;
    });
  }


}
