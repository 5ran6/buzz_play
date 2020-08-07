

class HomeMOstPlayed {
  String status;
  String message;
  String response;

  static List<HomeMostPlayed> homemostplaylist=new List();

  HomeMOstPlayed.map(dynamic obj) {
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
  HomeMOstPlayed.getuserid(dynamic obj) {
    homemostplaylist = obj.map<HomeMostPlayed>((json) => new HomeMostPlayed.fromJson(json)).toList();

  }
}




class HomeMostPlayed
{

  final String music_title;
  final String music_id;
  final String artist_id;
  final String album_id;
  final String music_file;
  final String music_image;
  final String music_duration;
  final String playCount;
  int is_in_playlist;
  int is_liked;
  final int like_count;
  final String album_name;
  final List<Artists> artistlist;


  HomeMostPlayed({this.music_id, this.music_title, this.music_image, this.music_duration,
    this.music_file,this.is_liked,this.like_count,this.album_name,this.artistlist,
    this.artist_id,this.is_in_playlist,this.album_id,this.playCount});



  factory HomeMostPlayed.fromJson(Map<String, dynamic> jsonMap){

    var list = jsonMap['artists'] as List;
    print(list.runtimeType);
    List<Artists> imagesList = list.map((i) => Artists.fromJson(i)).toList();



    return HomeMostPlayed(music_duration : jsonMap['music_duration'],
        is_liked:   jsonMap['is_liked'],
        music_file:   jsonMap['music_file'],
        music_image:  jsonMap['music_image'],
        like_count:jsonMap['like_count'],
        music_id:jsonMap['music_id'],
        artist_id:jsonMap['artist_id'],
        is_in_playlist:jsonMap['is_in_playlist'],
        album_id:jsonMap['album_id'],
        playCount:jsonMap['playCount'],
        album_name:jsonMap['album_name'],
        artistlist: imagesList,
        music_title : jsonMap['music_title']);


  }


}

class Artists{

  final String artist_name;
  final String artist_id;

  Artists({this.artist_name,this.artist_id});


  factory Artists.fromJson(Map<String, dynamic> jsonMap){
    return Artists(artist_name: jsonMap['artist_name'],
        artist_id: jsonMap['artist_id']);
  }

}