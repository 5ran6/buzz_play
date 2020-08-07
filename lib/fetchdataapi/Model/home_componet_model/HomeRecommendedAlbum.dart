

class HomeRecommendedAlbum {
  String status;
  String message;
  String response;

  static List<HomeRecommendedAlbumItem> homerecmndmalbumlist=new List();

  HomeRecommendedAlbum.map(dynamic obj) {
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
  HomeRecommendedAlbum.getuserid(dynamic obj) {
    homerecmndmalbumlist = obj.map<HomeRecommendedAlbumItem>((json) => new HomeRecommendedAlbumItem.fromJson(json)).toList();

  }
}




class HomeRecommendedAlbumItem
{

  final String  album_id;
  final String album_name;
  final String album_image;

  final String likedCount;
  final int is_liked;





  HomeRecommendedAlbumItem({ this.album_id, this.album_image, this.album_name,
   this.is_liked,this.likedCount});



  factory HomeRecommendedAlbumItem.fromJson(Map<String, dynamic> jsonMap){



    return HomeRecommendedAlbumItem(
      album_id : jsonMap['album_id'],
      album_image:   jsonMap['album_image'],
      album_name:   jsonMap['album_name'],

      is_liked:   jsonMap['is_liked'],
      likedCount:  jsonMap['likedCount'],

    );


  }


}

