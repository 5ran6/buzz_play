

class BannerSide {
  String status;
  String message;
  String response;

  static List<BannerSideItem> bannersliderLIst=new List();

  BannerSide.map(dynamic obj) {
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
  BannerSide.getuserid(dynamic obj) {
    bannersliderLIst = obj.map<BannerSideItem>((json) => new BannerSideItem.fromJson(json)).toList();

  }
}




class BannerSideItem
{

  final String  banner_slider_id;
  final String banner_slider_name;
  final String banner_slider_name_alignment;
  final String banner_slider_image;

  final String banner_slider_show_button;
  final String banner_slider_button_alignment;
  final String banner_slider_button_text;
  final String banner_slider_order;
  final String banner_slider_status;



  BannerSideItem({ this.banner_slider_id, this.banner_slider_show_button, this.banner_slider_name_alignment,
    this.banner_slider_image,this.banner_slider_button_alignment,this.banner_slider_button_text
  ,this.banner_slider_name,this.banner_slider_order,this.banner_slider_status});



  factory BannerSideItem.fromJson(Map<String, dynamic> jsonMap){

    /*var list = jsonMap['artists'] as List;
    print(list.runtimeType);
    List<Artists> imagesList = list.map((i) => Artists.fromJson(i)).toList();

*/

    return BannerSideItem(
      banner_slider_id : jsonMap['banner_slider_id'],
      banner_slider_name:   jsonMap['banner_slider_name'],
      banner_slider_name_alignment:   jsonMap['banner_slider_name_alignment'],
      banner_slider_image:  jsonMap['banner_slider_image'],
        banner_slider_show_button:jsonMap['banner_slider_show_button'],
        banner_slider_button_alignment:jsonMap['banner_slider_button_alignment'],
        banner_slider_button_text:jsonMap['banner_slider_button_text'],
        banner_slider_order:jsonMap['banner_slider_order'],
        banner_slider_status:jsonMap['banner_slider_status']
//        album_name:jsonMap['album_name'],
//        artistlist: imagesList,
    );


  }


}

