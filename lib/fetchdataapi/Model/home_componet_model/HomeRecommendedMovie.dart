

class HomeRecommendedMovie {
  String status;
  String message;
  String response;

  static List<HomeRecommendedMovieItem> homerecmdmoviewlist=new List();

  HomeRecommendedMovie.map(dynamic obj) {
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
  HomeRecommendedMovie.getuserid(dynamic obj) {
    homerecmdmoviewlist = obj.map<HomeRecommendedMovieItem>((json) => new HomeRecommendedMovieItem.fromJson(json)).toList();

  }
}




class HomeRecommendedMovieItem
{

  final String  movie_id;
  final String movie_name;
  final String movie_image;

  final String likedCount;
  final int is_liked;





  HomeRecommendedMovieItem({ this.movie_id, this.movie_image, this.movie_name,
   this.is_liked,this.likedCount});



  factory HomeRecommendedMovieItem.fromJson(Map<String, dynamic> jsonMap){



    return HomeRecommendedMovieItem(
      movie_id : jsonMap['movie_id'],
      movie_image:   jsonMap['movie_image'],
      movie_name:   jsonMap['movie_name'],

      is_liked:   jsonMap['is_liked'],
      likedCount:  jsonMap['likedCount'],

    );


  }


}

