import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';

class Myownfavmusic {
  String status;
  String message;
  String response;

  static List<Recentplay> myownfavmusiclistLIst = new List();

  Myownfavmusic.map(dynamic obj) {
    if (obj != null) {
      this.status = obj["status"];
      if (status == null) {
        this.status = obj["status_code"];
      }
      this.message = obj["message"];
      this.response =
          obj["response"] != null ? obj["response"].toString() : null;
    }
  }

  Myownfavmusic.getuserid(dynamic obj) {
    myownfavmusiclistLIst = obj
        .map<Recentplay>((json) => new Recentplay.fromJson(json))
        .toList();
  }
}

/*class MyownfavmusicItem {
  final String music_id;
  final String music_title;
  final String music_file;
  final String likedCount;
  final int is_liked;
  final int is_in_playlist;
  final String music_duration;
  final String music_image;

  MyownfavmusicItem(
      {this.music_id,
      this.music_title,
      this.music_file,
      this.music_image,
      this.music_duration,
      this.likedCount,
      this.is_liked,
      this.is_in_playlist});

  factory MyownfavmusicItem.fromJson(Map<String, dynamic> jsonMap) {
*//*
    var list = jsonMap['images'] as List;
    print(list.runtimeType);
    List<Imagess> imagesList = list.map((i) => Imagess.fromJson(i)).toList();
*//*

    return MyownfavmusicItem(
      music_id: jsonMap['music_id'],
      music_title: jsonMap['music_title'],
      music_duration: jsonMap['music_duration'],
      likedCount: jsonMap['likedCount'],
      is_in_playlist: jsonMap['is_in_playlist'],
      is_liked: jsonMap['is_liked'],
      music_file: jsonMap['music_file'],

      music_image: jsonMap['music_image'],
//      imagesslist: imagesList,
    );
  }
}*/
