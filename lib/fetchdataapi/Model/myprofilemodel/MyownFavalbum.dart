class Myownfavalbum {
  String status;
  String message;
  String response;

  static List<MyownfavalbumItem> myownfavmusiclistLIst = new List();

  Myownfavalbum.map(dynamic obj) {
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

  Myownfavalbum.getuserid(dynamic obj) {
    myownfavmusiclistLIst = obj
        .map<MyownfavalbumItem>((json) => new MyownfavalbumItem.fromJson(json))
        .toList();
  }
}

class MyownfavalbumItem {
  final String album_id;
  final String album_name;
  final String album_image;
  final String likedCount;
  final int is_liked;


  MyownfavalbumItem(
      {this.album_id,
      this.album_name,
      this.album_image,

      this.likedCount,
      this.is_liked
    });

  factory MyownfavalbumItem.fromJson(Map<String, dynamic> jsonMap) {
/*
    var list = jsonMap['images'] as List;
    print(list.runtimeType);
    List<Imagess> imagesList = list.map((i) => Imagess.fromJson(i)).toList();
*/

    return MyownfavalbumItem(
      album_id: jsonMap['album_id'],
      album_name: jsonMap['album_name'],
      likedCount: jsonMap['likedCount'],
      is_liked: jsonMap['is_liked'],
      album_image: jsonMap['album_image'],

//      imagesslist: imagesList,
    );
  }
}
