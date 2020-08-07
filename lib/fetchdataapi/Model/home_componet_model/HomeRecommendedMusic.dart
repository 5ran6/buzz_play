

class HomeRecommendedMusic {
  String status;
  String message;
  String response;

  static List<HomeRecommendedMusicItem> homerecmndmusiclist=new List();

  HomeRecommendedMusic.map(dynamic obj) {
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
  HomeRecommendedMusic.getuserid(dynamic obj) {
    homerecmndmusiclist = obj.map<HomeRecommendedMusicItem>((json) => new HomeRecommendedMusicItem.fromJson(json)).toList();

  }
}




class HomeRecommendedMusicItem
{

  final String  music_id;
  final String music_title;
  final String music_file;
  final String music_image;
  final  String music_duration;
  final String likedCount;
  final int is_liked;
  final int is_in_playlist;




  HomeRecommendedMusicItem({ this.music_id, this.music_title, this.music_file,
    this.music_image,this.music_duration,this.is_liked,this.likedCount,this.is_in_playlist});



  factory HomeRecommendedMusicItem.fromJson(Map<String, dynamic> jsonMap){



    return HomeRecommendedMusicItem(
      music_id : jsonMap['music_id'],
      music_title:   jsonMap['music_title'],
      music_file:   jsonMap['music_file'],
      music_image : jsonMap['music_image'],
      music_duration:   jsonMap['music_duration'],
      is_liked:   jsonMap['is_liked'],
      likedCount:  jsonMap['likedCount'],
      is_in_playlist:  jsonMap['is_in_playlist'],
    );


  }


}

