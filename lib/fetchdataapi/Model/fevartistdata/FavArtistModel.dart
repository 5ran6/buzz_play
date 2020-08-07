import 'package:buzz_play/fetchdataapi/Model/RecentPlay.dart';







class FavArtistModel
{

  final int like_count;

  final String artist_id;
  final String artist_name;
  final String artist_image;


  int is_liked;








  final  List<Recentplay> mostplay;


  FavArtistModel({this.artist_name, this.artist_image,
    this.is_liked,this.like_count,this.mostplay,
    this.artist_id,});



  factory FavArtistModel.fromJson(Map<String, dynamic> jsonMap){

    var list = jsonMap['music_list'] as List;
    print(list.runtimeType);
    List<Recentplay> imagesList = list.map((i) => Recentplay.fromJson(i)).toList();



    return FavArtistModel(

      is_liked:   jsonMap['is_liked'],
      like_count:jsonMap['like_count'],
      artist_name:jsonMap['artist_name'],
      artist_id:jsonMap['artist_id'],
      artist_image:jsonMap['artist_image'],


      mostplay: imagesList,
    );


  }


}

