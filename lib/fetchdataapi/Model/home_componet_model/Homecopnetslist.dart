

class Homecopnetslist {
  String status;
  String message;
  String response;

  static List<HomecopnetslistItem> homelist=new List();

  Homecopnetslist.map(dynamic obj) {
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
  Homecopnetslist.getuserid(dynamic obj) {
    homelist = obj.map<HomecopnetslistItem>((json) => new HomecopnetslistItem.fromJson(json)).toList();

  }
}




class HomecopnetslistItem
{

  final String  home_components_id;
  final String home_components_name;
  final String home_components_order;
  final String home_components_slider_allowed;




  HomecopnetslistItem({ this.home_components_id, this.home_components_name, this.home_components_order,
    this.home_components_slider_allowed});



  factory HomecopnetslistItem.fromJson(Map<String, dynamic> jsonMap){



    return HomecopnetslistItem(
        home_components_id : jsonMap['home_components_id'],
        home_components_name:   jsonMap['home_components_name'],
        home_components_order:   jsonMap['home_components_order'],
      home_components_slider_allowed:  jsonMap['home_components_slider_allowed'],


    );


  }


}

