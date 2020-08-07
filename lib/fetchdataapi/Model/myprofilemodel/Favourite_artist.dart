

class Favouriteartist {
  String status;
  String message;
  String response;

  static List<FavouriteartistItem> RecentPlayLIst=new List();

  Favouriteartist.map(dynamic obj) {
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
  Favouriteartist.getuserid(dynamic obj) {
    RecentPlayLIst = obj.map<FavouriteartistItem>((json) => new FavouriteartistItem.fromJson(json)).toList();

  }
}




class FavouriteartistItem
{

  final String artist_id;
  final String artist_name;
  final String artist_image;
  final String likedCount;
  final int is_liked;



  FavouriteartistItem({ this.artist_id, this.artist_name, this.artist_image,
    this.likedCount,this.is_liked});



  factory FavouriteartistItem.fromJson(Map<String, dynamic> jsonMap){

    /*var list = jsonMap['artists'] as List;
    print(list.runtimeType);
    List<Artists> imagesList = list.map((i) => Artists.fromJson(i)).toList();

*/

    return FavouriteartistItem(
        artist_id : jsonMap['artist_id'],
        artist_name:   jsonMap['artist_name'],
        artist_image:   jsonMap['artist_image'],
        likedCount:  jsonMap['likedCount'],
        is_liked:jsonMap['is_liked'],
//        album_name:jsonMap['album_name'],
//        artistlist: imagesList,
);


  }


}

