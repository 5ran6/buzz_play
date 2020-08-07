





import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';







class MoviemoviewModel
{

  final int like_count;
  final String album_name;
  final String movie_description;
  final String movie_id;
  final String movie_image;
  final String movie_year;
  final String movie_name;
  int is_liked;








  final  List<Recentplay> mostplay;


  MoviemoviewModel({this.movie_image, this.movie_name, this.movie_description,
    this.is_liked,this.like_count,this.album_name,this.mostplay,
    this.movie_id,this.movie_year});



  factory MoviemoviewModel.fromJson(Map<String, dynamic> jsonMap){

    var list = jsonMap['music_list'] as List;
    print(list.runtimeType);
    List<Recentplay> imagesList = list.map((i) => Recentplay.fromJson(i)).toList();



    return MoviemoviewModel(

        is_liked:   jsonMap['is_liked'],
        like_count:jsonMap['like_count'],
        movie_description:jsonMap['movie_description'],
        movie_id:jsonMap['movie_id'],
        movie_image:jsonMap['movie_image'],
        movie_year:jsonMap['movie_year'],
        movie_name:jsonMap['movie_name'],
        album_name:jsonMap['album_name'],
        mostplay: imagesList,
       );


  }


}

