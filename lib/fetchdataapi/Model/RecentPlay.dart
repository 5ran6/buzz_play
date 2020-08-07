

class RecentplayList {
  String status;
  String message;
  String response;

  static List<Recentplay> RecentPlayLIst=new List();

  RecentplayList.map(dynamic obj) {
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
  RecentplayList.getuserid(dynamic obj) {
    RecentPlayLIst = obj.map<Recentplay>((json) => new Recentplay.fromJson(json)).toList();

  }
}




class Recentplay
{

  final String music_title;
  final String music_id;
  final String music_file;
  final String music_image;
  final String music_duration;
  final String movie_name;
   int is_liked;
  final int like_count;
  final String album_name;
  final List<Artists> artistlist;
  final String movie_id;


  Recentplay({this.music_id, this.music_title, this.music_image, this.music_duration,this.movie_name,this.movie_id,
    this.music_file,this.is_liked,this.like_count,this.album_name,this.artistlist});



  factory Recentplay.fromJson(Map<String, dynamic> jsonMap){

    var list = jsonMap['artists'] as List;
    print(list.runtimeType);
    List<Artists> imagesList = list.map((i) => Artists.fromJson(i)).toList();



    return Recentplay(music_duration : jsonMap['music_duration'],
        is_liked:   jsonMap['is_liked'],
        music_file:   jsonMap['music_file'],
        music_image:  jsonMap['music_image'],
        like_count:jsonMap['like_count'],
        music_id:jsonMap['music_id'],
        movie_id:jsonMap['movie_id'],
        movie_name:jsonMap['movie_name'],
        album_name:jsonMap['album_name'],
        artistlist: imagesList,
    music_title : jsonMap['music_title']);


  }


}

class Artists{

  final String artist_name;

  Artists({this.artist_name});


  factory Artists.fromJson(Map<String, dynamic> jsonMap){
    return Artists(artist_name: jsonMap['artist_name']);
  }

  }