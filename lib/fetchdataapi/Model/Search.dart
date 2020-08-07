

class SearchList {
  String status;
  String message;
  String response;

  static List<Search> RecentPlayLIst=new List();

  SearchList.map(dynamic obj) {
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
  SearchList.getuserid(dynamic obj) {
    RecentPlayLIst = obj.map<Search>((json) => new Search.fromJson(json)).toList();

  }
}




class Search
{

  final String search_type;
  final String id;
  final String search_text;



  Search({this.search_text, this.id, this.search_type});



  factory Search.fromJson(Map<String, dynamic> jsonMap){



    return Search(
        search_text : jsonMap['search_text'],
        id:   jsonMap['id'],
        search_type:   jsonMap['search_type']
      );


  }


}

