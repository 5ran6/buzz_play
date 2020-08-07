

class USerplaylist {
  String status;
  String message;
  String response;

  static List<USerplaylistItem> userplaylistLIst=new List();

  USerplaylist.map(dynamic obj) {
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
  USerplaylist.getuserid(dynamic obj) {
    userplaylistLIst = obj.map<USerplaylistItem>((json) => new USerplaylistItem.fromJson(json)).toList();

  }
}




class USerplaylistItem
{

  final String  user_playlist_id;
  final String user_playlist_name;
  final int music_count;
  final List<Imagess> imagesslist;



  USerplaylistItem({ this.user_playlist_id, this.user_playlist_name, this.imagesslist,
    this.music_count});



  factory USerplaylistItem.fromJson(Map<String, dynamic> jsonMap){

    var list = jsonMap['images'] as List;
    print(list.runtimeType);
    List<Imagess> imagesList = list.map((i) => Imagess.fromJson(i)).toList();


    return USerplaylistItem(
      user_playlist_id : jsonMap['user_playlist_id'],
      user_playlist_name:   jsonMap['user_playlist_name'],
      music_count:   jsonMap['music_count'],

//        album_name:jsonMap['album_name'],
      imagesslist: imagesList,
    );


  }


}


class Imagess{

  final String music_image;

  Imagess({this.music_image});


  factory Imagess.fromJson(Map<String, dynamic> jsonMap){
    return Imagess(music_image: jsonMap['music_image']);
  }

}