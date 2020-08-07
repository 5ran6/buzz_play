

class HomeRPopularMovie {
  String status;
  String message;
  String response;

  static List<HomeRPopularMovieItem> homerecmndmalbumlist=new List();

  HomeRPopularMovie.map(dynamic obj) {
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
  HomeRPopularMovie.getuserid(dynamic obj) {
    homerecmndmalbumlist = obj.map<HomeRPopularMovieItem>((json) => new HomeRPopularMovieItem.fromJson(json)).toList();

  }
}




class HomeRPopularMovieItem
{

  final String  movie_id;
  final String movie_name;
  final String movie_image;

  final String viewCount;
  final int is_liked;





  HomeRPopularMovieItem({ this.movie_id, this.movie_image, this.movie_name,
   this.is_liked,this.viewCount});



  factory HomeRPopularMovieItem.fromJson(Map<String, dynamic> jsonMap){



    return HomeRPopularMovieItem(
      movie_id : jsonMap['movie_id'],
      movie_image:   jsonMap['movie_image'],
      movie_name:   jsonMap['movie_name'],

      is_liked:   jsonMap['is_liked'],
      viewCount:  jsonMap['viewCount'],

    );


  }


}

