import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';







class MovieAlbumModel
{

  final int like_count;
  final String album_name;
  final String artist_id;
  final String album_id;
  final String album_image;
  final String category_name;
  final String movie_name;
  int is_liked;








  final  List<Recentplay> mostplay;


  MovieAlbumModel({this.album_image, this.movie_name, this.category_name,
    this.is_liked,this.like_count,this.album_name,this.mostplay,
    this.artist_id,this.album_id});



  factory MovieAlbumModel.fromJson(Map<String, dynamic> jsonMap){

    var list = jsonMap['music_list'] as List;
    print(list.runtimeType);
    List<Recentplay> imagesList = list.map((i) => Recentplay.fromJson(i)).toList();



    return MovieAlbumModel(

        is_liked:   jsonMap['is_liked'],
        like_count:jsonMap['like_count'],
        album_image:jsonMap['album_image'],
        artist_id:jsonMap['artist_id'],
        category_name:jsonMap['category_name'],
        album_id:jsonMap['album_id'],
        movie_name:jsonMap['movie_name'],
        album_name:jsonMap['album_name'],
        mostplay: imagesList,
       );


  }


}

