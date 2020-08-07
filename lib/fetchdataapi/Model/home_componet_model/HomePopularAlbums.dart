

class HomePopularAlbums {
  String status;
  String message;
  String response;

  static List<HomePopularAlbumsItem> homepopalbumlist=new List();

  HomePopularAlbums.map(dynamic obj) {
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
  HomePopularAlbums.getuserid(dynamic obj) {
    homepopalbumlist = obj.map<HomePopularAlbumsItem>((json) => new HomePopularAlbumsItem.fromJson(json)).toList();

  }
}




class HomePopularAlbumsItem
{

  final String  album_id;
  final String album_name;
  final String album_image;
  final String viewCount;
  final  int is_liked;
  final int like_count;
  final int music_count;




  HomePopularAlbumsItem({ this.album_id, this.album_name, this.album_image,
    this.viewCount,this.music_count,this.is_liked,this.like_count});



  factory HomePopularAlbumsItem.fromJson(Map<String, dynamic> jsonMap){



    return HomePopularAlbumsItem(
      album_id : jsonMap['album_id'],
      album_name:   jsonMap['album_name'],
      album_image:   jsonMap['album_image'],
      is_liked : jsonMap['is_liked'],
      like_count:   jsonMap['like_count'],
      music_count:   jsonMap['music_count'],
      viewCount:  jsonMap['viewCount'],
    );


  }


}

